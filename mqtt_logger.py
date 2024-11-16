import subprocess
import time
from datetime import datetime


def get_log_filename():
    """Generate a log filename based on the current year and month."""
    return '/data/'+datetime.now().strftime("%Y-%m.log")

def log_mqtt_messages():
    """Subscribe to MQTT topics and log messages to monthly files."""
    while True:
        filename = get_log_filename()
        print(f"Logging MQTT messages to {filename}")

        # Start the mosquitto_sub process
        with subprocess.Popen(
            ["mosquitto_sub", "-v", "-t", "#"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        ) as process:

            try:
                with open(filename, "a") as log_file:
                    while True:
                        # Read messages from mosquitto_sub
                        line = process.stdout.readline()
                        if line:
                            # Add a timestamp to the message
                            timestamped_message = f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} {line}"
                            log_file.write(timestamped_message)
                            log_file.flush()
                            print(timestamped_message, end="")  # Optional: Print to console

                        # Check if the month has changed
                        if get_log_filename() != filename:
                            break

            except Exception as e:
                print(f"Error: {e}")
                process.terminate()
                break

if __name__ == "__main__":
    log_mqtt_messages()
