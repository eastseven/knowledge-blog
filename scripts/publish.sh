#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

bash ./scripts/sync_notes.sh

git add .
git commit -m "update blog" || true
git push origin main
