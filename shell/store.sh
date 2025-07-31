#!/bin/bash

set -e

BASE_URL="https://repo.istoreos.com/repo/all/store/"
TARGET_DIR="store"
mkdir -p "$TARGET_DIR"

# 指定要匹配的包名前缀
packages=(
  "luci-app-store"
  "luci-lib-taskd"
  "luci-lib-xterm"
  "taskd"
)

# 下载页面内容
echo "[+] Fetching index page..."
page_content=$(curl -s "$BASE_URL")

# 从页面中提取所有 .ipk 文件名
echo "[+] Parsing .ipk links..."
all_ipks=$(echo "$page_content" | grep -oP 'href="\K[^"]+\.ipk')

# 根据包名前缀过滤并下载
for prefix in "${packages[@]}"; do
  match=$(echo "$all_ipks" | grep "^${prefix}_" | head -n1)
  if [ -n "$match" ]; then
    echo "[+] Downloading $match ..."
    curl -s -L -o "$TARGET_DIR/$match" "${BASE_URL}${match}"
  else
    echo "[!] Warning: No .ipk found for $prefix"
  fi
done

echo "[✓] Done. Saved in: $TARGET_DIR"
