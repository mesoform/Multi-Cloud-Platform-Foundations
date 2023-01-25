#!/bin/bash
PROJECT_YAML=resource/projects.yaml

JSON=$(python -c "import yaml; import json; from pathlib import Path; print(json.dumps(yaml.safe_load(Path('$PROJECT_YAML').read_text())))")
RESOURCES=$(echo "$JSON" | jq -r '.components.specs')
mapfile -t RESOURCE_NAMES< <(echo "$RESOURCES" | jq -r 'keys | .[] ')
for name in "${RESOURCE_NAMES[@]}"; do
  PROJECT_ID=$(echo "$RESOURCES" | jq ".\"${name}\"" | jq -c ".project_id" | tr -d \")
  SUFFIX="-<project_date>" # ignore suffix when searching for project ids using gcloud
  PROJECT_ID_PREFIX=${PROJECT_ID%"$SUFFIX"}
  echo "Deleting $PROJECT_ID_PREFIX projects"
  for project in $(gcloud projects list --filter "parent.id:$GCP_FOLDER_ID AND projectId:${PROJECT_ID_PREFIX%-<project_date>}*" --format=json | jq -c ".[].projectId" | tr -d \"); do
    echo "Deleting project: $project"
    gcloud projects delete $project --quiet
  done
done
