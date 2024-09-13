#!/bin/bash

set -e

# 检查 GITHUB_TOKEN 是否设置
if [ -z "$GITHUB_TOKEN" ]; then
  echo "GITHUB_TOKEN 未设置。"
  exit 1
fi

# 读取版本列表
if [ ! -f "versions.txt" ]; then
  echo "versions.txt 文件未找到。请先运行 get_versions.sh。"
  exit 1
fi

# 读取版本列表到数组
mapfile -t VERSION_ARRAY < versions.txt

# 遍历版本列表
for VERSION in "${VERSION_ARRAY[@]}"; do
  echo "----------------------------------------"
  echo "处理版本：$VERSION"

  # 检查是否已有对应的标签
  if git tag | grep -q "^v$VERSION$"; then
    echo "版本 v$VERSION 已存在，跳过。"
    continue
  fi

  # 生成语言包
  chmod +x ./build.sh
  ./build.sh "$VERSION"

  ZIP_NAME="build-$VERSION.zip"
  if [ ! -f "$ZIP_NAME" ]; then
    echo "语言包 $ZIP_NAME 未找到，生成可能失败，跳过此版本。"
    continue
  fi

  # 创建 Git 标签并推送到远程仓库
  git tag "v$VERSION"
  git push origin "v$VERSION"

  # 创建 GitHub Release
  RELEASE_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -d @- "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases" <<EOF
{
  "tag_name": "v$VERSION",
  "name": "v$VERSION",
  "body": "自动发布 git-for-windows v$VERSION 的中文语言包。",
  "draft": false,
  "prerelease": false
}
EOF
  )

  # 提取 Release 上传 URL
  UPLOAD_URL=$(echo "$RELEASE_RESPONSE" | jq -r '.upload_url' | sed 's/{?name,label}//')

  if [ "$UPLOAD_URL" != "null" ]; then
    # 上传资产
    curl -s -H "Authorization: token $GITHUB_TOKEN" \
      -H "Content-Type: application/zip" \
      --data-binary @"$ZIP_NAME" \
      "$UPLOAD_URL?name=$(basename "$ZIP_NAME")"

    echo "Release v$VERSION 及其资产已创建。"
  else
    echo "创建 Release v$VERSION 失败，跳过上传资产。"
    echo "API 响应：$RELEASE_RESPONSE"
    continue
  fi

  # 清理生成的文件
  rm -f "$ZIP_NAME"
  rm -rf "git-$VERSION"
  rm -f "v$VERSION.tar.gz"

  echo "版本 v$VERSION 处理完成。"
done

echo "----------------------------------------"
echo "所有版本处理完毕。"
