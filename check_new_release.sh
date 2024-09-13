#!/bin/bash

set -e

# 设置上游仓库
UPSTREAM_REPO="git-for-windows/git"

# 获取上游仓库的最新发布版本
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$UPSTREAM_REPO/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | sed 's/^v//')

if [ -z "$LATEST_VERSION" ]; then
  echo "无法获取上游仓库的最新版本。"
  exit 1
fi

echo "最新的上游版本：$LATEST_VERSION"

# 获取当前仓库的标签列表
CURRENT_TAGS=$(git tag | sed 's/^v//')

echo "已处理的版本：$CURRENT_TAGS"

# 检查最新版本是否已在当前仓库中处理
if echo "$CURRENT_TAGS" | grep -q "^$LATEST_VERSION$"; then
  echo "new_release=false" >> $GITHUB_OUTPUT
else
  echo "new_release=true" >> $GITHUB_OUTPUT
  echo "latest_version=$LATEST_VERSION" >> $GITHUB_OUTPUT
fi
