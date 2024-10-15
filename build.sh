#!/bin/bash

set -e

# 检查是否提供了git版本参数
if [ -z "$1" ]; then
  echo "用法：$0 <git版本>"
  exit 1
fi

gitver="$1"
tarfile="v$gitver.tar.gz"
dir="git-$gitver"
outdir="build"

# 如果tarball不存在，则下载
if [ ! -f "$tarfile" ]; then
  curl -L -O "https://github.com/TC999/git/archive/refs/tags/$tarfile"
fi

# 解压tarball
tar xf "$tarfile"

# 定义本地化目录
modir="$outdir/mingw64/share/locale/zh_CN/LC_MESSAGES"
guidir="$outdir/mingw64/share/git-gui/lib/msgs"
gitkdir="$outdir/mingw64/share/gitk/lib/msgs"

# 创建必要的目录
mkdir -p "$modir" "$guidir" "$gitkdir"

# 编译本地化文件
msgfmt -o "$modir/git.mo" "$dir/po/zh_CN.po"
msgfmt --tcl -l zh_CN -d "$guidir" "$dir/git-gui/po/zh_cn.po"
msgfmt --tcl -l zh_CN -d "$gitkdir" "$dir/gitk-git/po/zh_cn.po"

zipname="build-$gitver.zip"

# 如果存在旧的zip文件，删除它
[ -f "$zipname" ] && rm -f "$zipname"

# 创建zip归档
if command -v zip >/dev/null 2>&1; then
  (
    cd "$outdir"
    zip -r -y "../$zipname" .
  )
else
  powershell.exe -nologo -noprofile -command \
    "& {
      Param(
        [String] \$sourceDir,
        [String] \$destZip
      )
      Add-Type -A 'System.IO.Compression.FileSystem'
      [IO.Compression.ZipFile]::CreateFromDirectory(\$sourceDir, \$destZip)
    }" \
    -sourceDir "$outdir" \
    -destZip "$zipname" || {
      echo "压缩失败"
      exit 1
    }
fi

# 清理
rm -rf "$outdir" "$dir" "$tarfile"
