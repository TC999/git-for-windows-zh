#!/bin/bash

set -e

UPSTREAM_REPO="git-for-windows/git"
OUTPUT_FILE="versions.txt"

# 获取最近十个发布版本的标签名，并去除前缀 "v"
VERSIONS=$(curl -s "https://api.github.com/repos/$UPSTREAM_REPO/releases?per_page=10" | jq -r '.[].tag_name' | sed 's/^v//')

# 将版本列表保存到文件中
echo "$VERSIONS" > "$OUTPUT_FILE"

echo "获取的版本列表："
cat "$OUTPUT_FILE"
