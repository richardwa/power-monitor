#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if ! test -f $DIR/Dockerfile; then
  echo "Dockerfile required at current directory"
  exit
fi

projectName=$(basename $DIR)
echo $projectName

git add .
git commit -m"update"
gitHash=$(git rev-parse HEAD)
shortGitHash=${gitHash:0:6}
tag="$projectName:$shortGitHash"

targetHost='rich@omv.mangosplit.com'
ssh="/usr/bin/ssh"

# prepare server
$ssh $targetHost "rm -rf $projectName && mkdir $projectName"

# copy all files to docker host
/usr/bin/rsync -e "$ssh" --exclude "node_modules" -av ./ "${targetHost}:~/$projectName/"

# generate remote script for deployment
read -d '\n' script << END
#!/bin/bash
cd $projectName
pwd
docker build -t $tag .

# Check if the container is running
if docker container inspect -f '{{.State.Running}}' $projectName >/dev/null 2>&1; then
  # Stop the container
  docker container stop $projectName
  echo 'Container $projectName stopped.'
fi

# Check if the container exists
if docker container inspect $projectName >/dev/null 2>&1; then
  # Remove the container
  docker container rm $projectName
  echo Container $projectName removed.
else
  echo Container $projectName does not exist.
fi

nohup docker run -d \
  -e TZ=America/New_York \
  --restart=unless-stopped \
  -p 1883:1883 \
  -p 8086:8086 \
  -v /srv/dev-disk-by-uuid-adf61bee-016d-4065-9db0-5edae5a1e20a/public/rich/app_data/power-monitor:/data \
  --name $projectName \
  $tag &
END

echo "$script"
$ssh $targetHost "$script"