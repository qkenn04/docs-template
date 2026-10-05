#!/usr/bin/env bash
# Tự kiểm bộ khuôn: dựng từng hồ sơ vào thư mục tạm rồi kiểm kết quả.
#
# Dùng:  scripts/test-profiles.sh            (thư mục tạm theo $TMPDIR, tự xoá khi xong)
#        KEEP=1 scripts/test-profiles.sh     (giữ thư mục tạm để xem)
#
# Với mỗi hồ sơ trong profiles/:
#   1. --dry-run không ghi gì;
#   2. dựng thật: số file bằng số dòng của hồ sơ; quyền theo umask 022 (thư mục 755, file 644, .py 755);
#   3. không còn "<Tên dự án>", "<Ngày tạo>"; dòng metadata đầu mỗi file .md có ngày hôm nay;
#   4. check-links.py sạch trên kết quả (link chỉ trỏ tới file có trong hồ sơ);
#   5. openapi.yaml (nếu có) là YAML hợp lệ, openapi 3.1 (cần PyYAML; thiếu thì bỏ qua bước này);
#   6. chạy lại: 0 file chép, mọi file báo "bỏ qua", nội dung không đổi.
#   7. STANDARD/FULL: thêm các topic theo nhu cầu rồi kiểm link trong kết quả thật.
# Cuối cùng: check-links.py sạch trên chính bộ khuôn.
set -euo pipefail

umask 022
KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SCAFFOLD="$KIT_DIR/scripts/new-project-docs.sh"
CHECK="$KIT_DIR/scripts/check-links.py"
NAME='Dự án thử & "ví dụ"/v2'
today="$(date +%F)"
work="$(mktemp -d "${TMPDIR:-/tmp}/docs-template-test.XXXXXX")"
if [ "${KEEP:-0}" = 1 ]; then
  echo "Giữ thư mục tạm: $work"
else
  trap 'rm -rf "${work:?}"' EXIT
fi

failures=0
fail() { printf '  FAIL %s\n' "$*"; failures=$((failures + 1)); }

for pf in "$KIT_DIR"/profiles/*.txt; do
  p="$(basename "$pf" .txt)"
  dir="$work/$p"
  printf '== %s\n' "$p"
  expected="$(grep -cvE '^[[:space:]]*(#|$)' "$pf")"

  "$SCAFFOLD" --dry-run "$p" "$dir" "$NAME" > "$work/$p.dry.log"
  [ ! -e "$dir" ] || fail "$p: --dry-run đã tạo thư mục đích"

  "$SCAFFOLD" "$p" "$dir" "$NAME" > "$work/$p.run1.log"
  actual="$(find "$dir" -type f | wc -l | tr -d ' ')"
  [ "$actual" = "$expected" ] || fail "$p: cần $expected file, có $actual"
  bad_modes="$(find "$dir" \( \( -type d ! -perm 755 \) -o \( -type f ! -name '*.py' ! -perm 644 \) \
    -o \( -type f -name '*.py' ! -perm 755 \) \) -printf '%m %P  ')"
  [ -z "$bad_modes" ] || fail "$p: quyền sai với umask 022: $bad_modes"

  if grep -rlF -e '<Tên dự án>' -e '<Ngày tạo>' "$dir" > "$work/$p.left" 2>/dev/null; then
    fail "$p: còn placeholder tên hoặc ngày trong: $(tr '\n' ' ' < "$work/$p.left")"
  fi
  grep -qF "$NAME" "$dir/README.md" || fail "$p: README.md không có tên dự án"

  while IFS= read -r f; do
    case "$f" in */CLAUDE.md|*/.github/*) continue ;; esac
    meta="$(grep -m1 '^> Trạng thái:' "$f" || true)"
    if [ -z "$meta" ]; then fail "$p: thiếu dòng metadata: ${f#"$dir"/}"; continue; fi
    case "$meta" in *"Cập nhật: $today"*) ;; *) fail "$p: ngày metadata chưa điền: ${f#"$dir"/}" ;; esac
  done < <(find "$dir" -type f -name '*.md')

  python3 "$CHECK" --quiet "$dir" || fail "$p: check-links báo lỗi"

  if [ -f "$dir/docs/api/openapi.yaml" ]; then
    if python3 -c 'import yaml' 2>/dev/null; then
      python3 - "$dir/docs/api/openapi.yaml" <<'PY' || fail "$p: openapi.yaml không hợp lệ"
import sys, yaml
d = yaml.safe_load(open(sys.argv[1], encoding="utf-8"))
assert str(d["openapi"]).startswith("3.1"), d["openapi"]
assert d["info"]["title"] and d["info"]["version"]
assert d["paths"] == {}
PY
    else
      echo "  (bỏ qua kiểm openapi.yaml: thiếu PyYAML)"
    fi
  fi

  before="$(cd "$dir" && find . -type f -exec md5sum {} + | sort)"
  "$SCAFFOLD" "$p" "$dir" "Tên khác" > "$work/$p.run2.log"
  after="$(cd "$dir" && find . -type f -exec md5sum {} + | sort)"
  [ "$before" = "$after" ] || fail "$p: chạy lại đã đổi nội dung file"
  grep -q '^Tổng: 0 chép, '"$expected"' bỏ qua' "$work/$p.run2.log" || fail "$p: chạy lại không báo bỏ qua đủ $expected file"

  if [ "$p" = standard ] || [ "$p" = full ]; then
    "$SCAFFOLD" --topic backend/nestjs --topic ci-cd/github-actions "$p" "$dir" "$NAME" > "$work/$p.topics.log"
    [ -f "$dir/docs/dev/backend-nestjs.md" ] || fail "$p: thiếu topic NestJS"
    [ -f "$dir/docs/ops/ci-cd.md" ] || fail "$p: thiếu topic CI/CD"
    python3 "$CHECK" --quiet "$dir" || fail "$p + topics: check-links báo lỗi"
  fi
  if [ "$p" = full ]; then
    "$SCAFFOLD" --topic frontend/react "$p" "$dir" "$NAME" > "$work/$p.frontend.log"
    [ "$(find "$dir" -type f | wc -l | tr -d ' ')" = "$((expected + 2))" ] || fail "full + frontend: file trùng"
  fi
  if [ "$p" = standard ]; then
    "$SCAFFOLD" --topic frontend/react "$p" "$dir" "$NAME" > "$work/$p.frontend.log"
    python3 "$CHECK" --quiet "$dir" || fail "standard + frontend: check-links báo lỗi"
  fi

  printf '  %s file; %s\n' "$actual" "$(grep '^Tổng:' "$work/$p.run1.log")"
done

printf '== topic độc lập\n'
topic_dir="$work/topics"
"$SCAFFOLD" --topic ci-cd/github-actions minimal "$topic_dir" "$NAME" > "$work/topics.log"
[ -f "$topic_dir/docs/ops/ci-cd.md" ] || fail "minimal + CI/CD: thiếu file"
python3 "$CHECK" --quiet "$topic_dir" || fail "minimal + CI/CD: check-links báo lỗi"
"$SCAFFOLD" --dry-run --topic backend/nestjs standard "$work/dry-topic" "$NAME" > "$work/dry-topic.log"
[ ! -e "$work/dry-topic" ] || fail "topic: --dry-run đã tạo thư mục"
if "$SCAFFOLD" --topic backend/nestjs minimal "$work/invalid-topic" "$NAME" > "$work/invalid-topic.log" 2>&1; then
  fail "minimal + NestJS: cần từ chối vì thiếu tài liệu chung"
fi
[ ! -e "$work/invalid-topic" ] || fail "topic không hợp lệ đã tạo thư mục"

printf '== bộ khuôn\n'
python3 "$CHECK" "$KIT_DIR" || fail "check-links báo lỗi trên bộ khuôn"

if [ "$failures" -gt 0 ]; then
  printf '%d lỗi\n' "$failures"
  exit 1
fi
printf 'Tất cả đạt\n'
