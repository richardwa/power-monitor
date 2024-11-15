#!/bin/bash
since="1 hours ago"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
journalctl -u power-monitor --no-pager --since "${1:-$since}" | cut -d' ' -f6- | $DIR/parse-log.py | $DIR/plot.sh
