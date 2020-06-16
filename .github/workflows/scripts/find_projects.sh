#!/bin/bash

git diff-tree "$1" --no-commit-id --name-status -r HEAD --diff-filter d |
    grep -E 'projects/' |
    awk '{print $2}' |
    grep -Evi '\.md' |
    while read -r dir; do
        if [[ "$(find "$(dirname "$dir")" -name '*.tf' 2>/dev/null | wc -l)" -gt 0 ]]; then
            dirname "$dir"
        fi
    done |
    sort -u |
    jq -csR 'split("\n") | map(select(length > 0)) | map({ project_dir: . }) | { include: . }'
