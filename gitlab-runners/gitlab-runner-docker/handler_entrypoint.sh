#!/bin/bash

# Register Runner
bash register_gitlab_runner.sh


if [[ $? -eq 1 ]]; then
  echo "Failed to register runner."
  exit 1
fi

#Define cleanup procedure
cleanup() {
    echo "Container stopped, performing cleanup..."
    runner_ids=$(sudo cat /etc/gitlab-runner/config.toml | grep -oE 'id = [0-9]+' | grep -oE '[0-9]+')
    sudo gitlab-runner unregister --all-runners
    if [ -n "$runner_ids" ]; then
      echo $runner_ids | xargs -I runner_id curl --request DELETE --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$GITLAB_SOURCE/api/v4/runners/runner_id"
      echo "Runner(s) unregistered from GitLab."
    else
      echo "No runners found to unregister."
    fi
}

#Trap SIGTERM
trap 'cleanup' SIGTERM

#Execute a command
gitlab-runner run &

while true
do
  tail -f /dev/null & wait ${!}
done