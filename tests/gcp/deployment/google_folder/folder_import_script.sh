#!/bin/bash

FOLDER_FILES_PATH=$(pwd)
TF_VAR_sub_folder_parent=${TF_VAR_sub_folder_parent:-staging}

echo "Installing required python packages ..."
pip3 install pyyaml || exit 1
echo "Installing required python packages - DONE"


# $1 - module name
# $2 - Parent ID
function import_modules() {
  MODULE_NAME=${1:-folder}
  PARENT_ID=${2:-${GCP_FOLDER_ID}}
  FILE_PATTERN="${MODULE_NAME/\[0\]/}*.yaml"
  DIRECTORY_PATH=$FOLDER_FILES_PATH/resource
  PATH_PATTERN=$DIRECTORY_PATH/$FILE_PATTERN
  for file in $PATH_PATTERN; do
    if [[ -z $(find "$DIRECTORY_PATH" -name "$FILE_PATTERN" | head -1) ]]; then continue; fi
    JSON=$(python -c "import yaml; import json; from pathlib import Path; print(json.dumps(yaml.safe_load(Path('$file').read_text())))")
    RESOURCES=$(echo "$JSON" | jq -r '.components.specs')
    mapfile -t RESOURCE_NAMES< <(echo "$RESOURCES" | jq -r 'keys | .[] ')
    for name in "${RESOURCE_NAMES[@]}"; do
      DISPLAY_NAME=$(echo "$RESOURCES" | jq ".\"${name}\"" | jq -c ".display_name")
      if [ "$DISPLAY_NAME" == "null" ]; then DISPLAY_NAME=$name; fi
      IMPORT_ID=$(gcloud resource-manager folders list --folder="$PARENT_ID" --filter "displayName:$DISPLAY_NAME" --format=json | jq -c ".[].name" | tr -d \")
      if [ -z "$IMPORT_ID" ]; then continue ;fi
      TERRAFORM_MODULE="module.${MODULE_NAME}.google_folder.self[\"${name}\"]"
      echo -e "\n --------------- Importing $TERRAFORM_MODULE ------------------------------\n"
      if terraform state list "$TERRAFORM_MODULE"; then echo "$TERRAFORM_MODULE already in state"; else terraform import "$TERRAFORM_MODULE" "$IMPORT_ID" ; fi
    done
  done
}


terraform init
import_modules folders
SUB_FOLDER_PARENT_ID=$(gcloud resource-manager folders list --folder="$GCP_FOLDER_ID" --filter "displayName:${TF_VAR_sub_folder_parent}" --format=json | jq -c ".[].name" | tr -d \")
echo "sub folder parent ID = ${SUB_FOLDER_PARENT_ID#folders/}"
terraform refresh
import_modules sub_folders "${SUB_FOLDER_PARENT_ID#folders/}"

echo "Re-running imports to account for errors"
import_modules folders
terraform refresh
import_modules sub_folders "${SUB_FOLDER_PARENT_ID#folders/}"
echo -e "\nimports complete, resources in state:"
terraform state list