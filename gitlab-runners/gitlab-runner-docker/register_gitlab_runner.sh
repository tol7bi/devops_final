#! /bin/bash

# reference https://docs.gitlab.com/runner/register/index.html

if [ -z "$GITLAB_ACCESS_TOKEN" ]; then
  echo "GITLAB_ACCESS_TOKEN were not provided. Please provide a GitLab access token using GITLAB_ACCESS_TOKEN environment variable."
  exit 1
fi

if [ -z "$GITLAB_SOURCE" ]; then
  echo "GITLAB_SOURCE were not provided. Please provide a GitLab source using GITLAB_SOURCE environment variable."
  exit 1
fi

if [ -z "$GROUP_ID" ] && [ -z "$PROJECT_ID" ]; then
  echo "GROUP_ID or PROJECT_ID were not provided. Please provide ether GROUP_ID or PROJECT_ID environment variables."
  exit 1
fi

if [ "$RUN_UNTAGGED" == "false" ] && [ -z "$TAG_LIST" ]; then
  echo "TAG_LIST were not provided. Please provide a TAG_LIST environment variable."
  echo "If you want to run untagged jobs, please set RUN_UNTAGGED environment variable to true."
  exit 1
fi

if [ -z "$GROUP_ID" ]; then
  runner_type="project_type"
else
  runner_type="group_type"
fi

response=$(
  curl -X"POST" "$GITLAB_SOURCE/api/v4/user/runners"\
  --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
  --data "runner_type=$runner_type&group_id=$GROUP_ID&project_id=$PROJECT_ID&run_untagged=$RUN_UNTAGGED&tag_list=$TAG_LIST"
)

token=$(echo "$response" | jq -r .token)

sudo gitlab-runner register --non-interactive --url "$GITLAB_SOURCE" --token "$token" --executor "docker" --docker-image "ruby:3.3" --name "docker-runner" --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" --docker-privileged
