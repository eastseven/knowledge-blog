#!/usr/bin/env bash
set -euo pipefail

# 从 Obsidian Bookmarks 同步笔记到 blog notes 目录
# 自动转换 frontmatter 为 Hugo 兼容格式

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BOOKMARKS_DIR="$HOME/Documents/notebook/Bookmarks"
NOTES_AI_DIR="$ROOT_DIR/notes/03-AI"

mkdir -p "$NOTES_AI_DIR"

for src in "$BOOKMARKS_DIR"/*.md; do
  [ -f "$src" ] || continue

  filename=$(basename "$src")
  dest="$NOTES_AI_DIR/$filename"

  # 用 python 转换 frontmatter
  python3 -c "
import sys, re, os
from datetime import datetime

src = sys.argv[1]
dest = sys.argv[2]

with open(src, 'r') as f:
    content = f.read()

# Split frontmatter and body
match = re.match(r'^---\n(.*?)\n---\n(.*)', content, re.DOTALL)
if not match:
    # No frontmatter, copy as-is
    with open(dest, 'w') as f:
        f.write(content)
    sys.exit(0)

fm_text = match.group(1)
body = match.group(2)

# Parse YAML frontmatter manually
fm = {}
current_key = None
current_list = None
for line in fm_text.split('\n'):
    list_match = re.match(r'^  - (.+)$', line)
    if list_match and current_key:
        if current_key not in fm or not isinstance(fm[current_key], list):
            fm[current_key] = []
        fm[current_key].append(list_match.group(1).strip())
        continue
    kv_match = re.match(r'^(\w+):\s*(.*)$', line)
    if kv_match:
        current_key = kv_match.group(1)
        val = kv_match.group(2).strip()
        if val == '':
            fm[current_key] = []
        elif val.startswith('[') and val.endswith(']'):
            fm[current_key] = [v.strip() for v in val[1:-1].split(',')]
        else:
            fm[current_key] = val

# Build Hugo frontmatter
title = fm.get('title', os.path.splitext(os.path.basename(src))[0])
date = fm.get('date', datetime.now().strftime('%Y-%m-%d'))
tags = fm.get('tags', [])
url = fm.get('url', '')
author = fm.get('author', '')
stars = fm.get('stars', '')

# Generate slug from filename
slug = os.path.splitext(os.path.basename(src))[0].lower().replace(' ', '-')

# Build tags line
if isinstance(tags, list):
    tags_str = '[' + ', '.join(tags) + ']'
else:
    tags_str = '[' + str(tags) + ']'

# Build Hugo FM
hugo_fm = f'''---
title: \"{title}\"
date: {date}
slug: "{slug}"
tags: {tags_str}
categories: [AI]
draft: false'''

# Add extra metadata as custom params
if url:
    hugo_fm += f'\nsource: "{url}"'
if author:
    hugo_fm += f'\nauthor: "{author}"'

hugo_fm += '\n---'

# Combine
output = hugo_fm + '\n' + body

with open(dest, 'w') as f:
    f.write(output)

print(f'  converted: {os.path.basename(src)}')
" "$src" "$dest"

done

echo "[INFO] Bookmarks 同步到 notes/03-AI/ 完成"
