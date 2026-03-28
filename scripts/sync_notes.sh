#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
NOTES_DIR="$ROOT_DIR/notes"
POSTS_DIR="$ROOT_DIR/blog/content/posts"
STATIC_IMG_DIR="$ROOT_DIR/blog/static/images"

mkdir -p "$POSTS_DIR"
mkdir -p "$STATIC_IMG_DIR"

find "$POSTS_DIR" -type f -name "*.md" -delete

rsync -av \
  --include="*/" \
  --include="*.md" \
  --exclude="templates/" \
  --exclude="99-草稿/" \
  --exclude="assets/" \
  --exclude=".obsidian/" \
  --exclude="*" \
  "$NOTES_DIR/" "$POSTS_DIR/"

if [ -d "$NOTES_DIR/assets/images" ]; then
  rsync -av "$NOTES_DIR/assets/images/" "$STATIC_IMG_DIR/"
fi

echo "[INFO] 同步完成"
