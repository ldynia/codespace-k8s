#!/usr/bin/env bash

# Remember to authenticate before executng this script
# gh auth login

# Get workflow IDs with status "disabled_manually"
workflow_ids=($(gh api repos/$GITHUB_REPOSITORY/actions/workflows | jq '.workflows[] | select(.["state"] | contains("disabled_manually")) | .id'))
for workflow_id in "${workflow_ids[@]}"
do
  echo "Listing runs for the workflow ID $workflow_id"
  run_ids=( $(gh api repos/$GITHUB_REPOSITORY/actions/workflows/$workflow_id/runs --paginate | jq '.workflow_runs[].id') )
  for run_id in "${run_ids[@]}"
  do
    echo "Deleting Run ID $run_id"
    gh api repos/$GITHUB_REPOSITORY/actions/runs/$run_id -X DELETE >/dev/null
  done
done