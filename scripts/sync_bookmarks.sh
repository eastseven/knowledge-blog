#!/usr/bin/env bash
set -euo pipefail

# 从 Obsidian Bookmarks 同步笔记到 blog notes 目录
# 自动转换 frontmatter 为 Hugo 兼容格式，并按内容/显式分类路由到对应 notes 目录

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BOOKMARKS_DIR="$HOME/Documents/notebook/Bookmarks"
NOTES_DIR="$ROOT_DIR/notes"

mkdir -p "$NOTES_DIR"

for src in "$BOOKMARKS_DIR"/*.md; do
  [ -f "$src" ] || continue

  python3 - "$src" "$NOTES_DIR" <<'PY'
import sys, re, os
from datetime import datetime
from pathlib import Path

src = sys.argv[1]
notes_dir = Path(sys.argv[2])

with open(src, 'r') as f:
    content = f.read()

match = re.match(r'^---\n(.*?)\n---\n(.*)', content, re.DOTALL)
if not match:
    category_dir = '04-DevOps'
    target_dir = notes_dir / category_dir
    target_dir.mkdir(parents=True, exist_ok=True)
    dest = target_dir / os.path.basename(src)
    with open(dest, 'w') as f:
        f.write(content)
    print(f'  converted: {os.path.basename(src)} -> {category_dir}')
    sys.exit(0)

fm_text = match.group(1)
body = match.group(2)

fm = {}
current_key = None
for line in fm_text.split('\n'):
    list_match = re.match(r'^  - (.+)$', line)
    if list_match and current_key:
        if current_key not in fm or not isinstance(fm[current_key], list):
            fm[current_key] = []
        fm[current_key].append(list_match.group(1).strip().strip('"\''))
        continue
    kv_match = re.match(r'^(\w+):\s*(.*)$', line)
    if kv_match:
        current_key = kv_match.group(1)
        val = kv_match.group(2).strip().strip('"\'')
        if val == '':
            fm[current_key] = []
        elif val.startswith('[') and val.endswith(']'):
            fm[current_key] = [v.strip().strip('"\'') for v in val[1:-1].split(',') if v.strip()]
        else:
            fm[current_key] = val

def first_value(value):
    if isinstance(value, list):
        return value[0] if value else ''
    return value or ''

def route_category(fm):
    explicit = first_value(fm.get('category') or fm.get('categories'))
    tags = fm.get('tags', [])
    if not isinstance(tags, list):
        tags = [str(tags)]
    tagset = {str(t).lower() for t in tags}

    def mapped(name):
        key = str(name).strip().lower()
        if key in {'ai', '03-ai', '人工智能'}:
            return '03-AI', 'AI'
        if key in {'devops', '04-devops', '运维', '基础设施', '自托管', 'homelab'}:
            return '04-DevOps', 'DevOps'
        if key in {'backend', '后端', '01-后端'}:
            return '01-后端', '后端'
        if key in {'database', 'db', '数据库', '02-数据库'}:
            return '02-数据库', '数据库'
        return '', ''

    if explicit:
        d, c = mapped(explicit)
        if d:
            return d, c

    ai_tags = {'ai', 'llm', 'ai-agent', 'agent', 'codex', 'claude', 'model', 'prompt', 'rag'}
    db_tags = {'database', 'db', 'mysql', 'postgresql', 'postgres', 'sql'}
    backend_tags = {'backend', 'api', 'java', 'spring', 'springboot', 'server'}
    devops_tags = {'devops', 'self-hosted', 'homelab', 'docker', 'docker-compose', 'kubernetes', 'k8s', 'reverse-proxy', 'infrastructure', 'ops'}

    if tagset & ai_tags:
        return '03-AI', 'AI'
    if tagset & db_tags:
        return '02-数据库', '数据库'
    if tagset & backend_tags:
        return '01-后端', '后端'
    if tagset & devops_tags:
        return '04-DevOps', 'DevOps'
    return '04-DevOps', 'DevOps'

category_dir, category_name = route_category(fm)
target_dir = notes_dir / category_dir
target_dir.mkdir(parents=True, exist_ok=True)
filename = os.path.basename(src)
dest = target_dir / filename

# Remove stale copies of the same bookmark from other published category dirs.
for stale in notes_dir.glob(f'*/{filename}'):
    if stale != dest and stale.parent.name != '99-草稿':
        stale.unlink()

title = fm.get('title', os.path.splitext(os.path.basename(src))[0])
date = fm.get('date', datetime.now().strftime('%Y-%m-%d'))
tags = fm.get('tags', [])
url = fm.get('url', '')
author = fm.get('author', '')
slug = os.path.splitext(os.path.basename(src))[0].lower().replace(' ', '-')

if isinstance(tags, list):
    tags_str = '[' + ', '.join(tags) + ']'
else:
    tags_str = '[' + str(tags) + ']'

hugo_fm = f'''---
title: {title}
date: {date}
slug: "{slug}"
tags: {tags_str}
categories: [{category_name}]
draft: false'''

if url:
    hugo_fm += f'\nsource: "{url}"'
if author:
    hugo_fm += f'\nauthor: "{author}"'

hugo_fm += '\n---'
output = hugo_fm + '\n' + body

with open(dest, 'w') as f:
    f.write(output)

print(f'  converted: {os.path.basename(src)} -> {category_dir}')
PY

done

echo "[INFO] Bookmarks 同步到 notes/ 分类目录完成"
