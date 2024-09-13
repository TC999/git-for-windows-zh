#!/bin/bash

set -e

# 检查 GITHUB_TOKEN 是否设置
if [ -z "$GITHUB_TOKEN" ]; then
  echo "GITHUB_TOKEN 未设置。"
  exit 1
fi

UPSTREAM_REPO="git-for-windows/git"
LOCAL_REPO="$GITHUB_REPOSITORY"

# 获取本地仓库的所有标签
LOCAL_TAGS=$(git ls-remote --tags "https://github.com/$LOCAL_REPO.git" | awk -F'/' '{print $NF}' | sed 's/^v//')

# 获取上游仓库的所有发布版本
UPSTREAM_TAGS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$UPSTREAM_REPO/releases?per_page=100" | jq -r '.[].tag_name' | sed 's/^v//')

# 计算未处理的版本
NEW_VERSIONS=()
for VERSION in $UPSTREAM_TAGS; do
  if ! echo "$LOCAL_TAGS" | grep -q "^$VERSION$"; then
    NEW_VERSIONS+=("$VERSION")
  fi
done

# 将新版本列表保存到文件，并设置输出变量
if [ ${#NEW_VERSIONS[@]} -eq 0 ]; then
  echo "没有新版本需要处理。"
  echo "has_new_versions=false" >> "$GITHUB_OUTPUT"
else
  echo "需要处理的新版本：${NEW_VERSIONS[@]}"
  printf "%s\n" "${NEW_VERSIONS[@]}" > new_versions.txt
  echo "has_new_versions=true" >> "$GITHUB_OUTPUT"
fi
