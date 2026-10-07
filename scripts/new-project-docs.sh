#!/usr/bin/env bash
# Dựng bộ tài liệu theo một hồ sơ (profile) của docs-template vào một thư mục dự án.
#
# Dùng:
#   scripts/new-project-docs.sh [--dry-run] [--topic <topic>] <profile> <target-dir> [project-name]
#
#   profile       minimal | full | standard | platform | lite | retiring (tên file trong profiles/)
#   target-dir    thư mục dự án (repo mới hoặc repo có sẵn); tạo nếu chưa có
#   project-name  thay cho "<Tên dự án>" trong mọi file chép sang; bỏ trống thì giữ placeholder
#
# Script chỉ THÊM file: file đã có ở đích luôn được giữ nguyên và được báo "bỏ qua".
# Chạy lại với hồ sơ lớn hơn để bổ sung các ô còn thiếu.
# Topic là gói chọn thêm trong topics/<topic>/files.txt; có thể dùng --topic nhiều lần.
#
# Nguồn của mỗi đường dẫn P trong hồ sơ (theo thứ tự):
#   1. template/<thư mục của P>/<tên>.<profile>.<đuôi>   (biến thể riêng của hồ sơ)
#   2. template/P
#   3. P ở gốc bộ khuôn (file dùng chung: .github/pull_request_template.md, scripts/check-links.py)
#
# Với file .md, .yaml, .yml:
#   - "<Tên dự án>" -> project-name (bỏ trống thì giữ nguyên);
#   - "<Ngày tạo>"  -> ngày hôm nay (ngày dựng bộ tài liệu, ví dụ ngày chấp nhận ADR 0001);
#   - YYYY-MM-DD ở dòng metadata đầu file ("> Trạng thái: …") -> ngày hôm nay.
# Các YYYY-MM-DD khác (trong khối mẫu, bảng lịch sử) giữ nguyên để người dùng điền khi dùng mẫu.
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
PLACEHOLDER='<Tên dự án>'
DATE_PLACEHOLDER='<Ngày tạo>'

usage() {
  cat <<EOF
Dùng: $(basename "$0") [--dry-run] [--topic <topic> ...] <profile> <target-dir> [project-name]

Hồ sơ có sẵn:
EOF
  local f
  for f in "$KIT_DIR"/profiles/*.txt; do
    printf '  %-10s %s\n' "$(basename "$f" .txt)" "$(sed -n 's/^# Mô tả: //p' "$f" | head -n 1)"
  done
  cat <<EOF

Ví dụ:
  $(basename "$0") standard ../my-app "My App"
  $(basename "$0") --topic backend/nestjs --topic ci-cd/delivery standard ../my-app "My App"
  $(basename "$0") --dry-run lite .
EOF
}

die() { printf 'new-project-docs: %s\n' "$*" >&2; exit 1; }

abs_path() {
  realpath -m -- "$1" 2>/dev/null && return 0
  case "$1" in /*) printf '%s\n' "$1" ;; *) printf '%s/%s\n' "$PWD" "$1" ;; esac
}

dry_run=0
topics=()
args=()
while [ "$#" -gt 0 ]; do
  a="$1"
  case "$a" in
    --dry-run|-n) dry_run=1 ;;
    --topic)
      [ "$#" -gt 1 ] || die "thiếu tên sau --topic"
      topics+=("$2")
      shift ;;
    --topic=*) topics+=("${a#--topic=}") ;;
    -h|--help) usage; exit 0 ;;
    -*) usage >&2; die "không hiểu tuỳ chọn: $a" ;;
    *) args+=("$a") ;;
  esac
  shift
done
[ "${#args[@]}" -ge 2 ] && [ "${#args[@]}" -le 3 ] || { usage >&2; exit 2; }

profile="$(printf '%s' "${args[0]}" | tr '[:upper:]' '[:lower:]')"
target="${args[1]}"
project_name="${args[2]-}"
profile_file="$KIT_DIR/profiles/$profile.txt"
[ -f "$profile_file" ] || die "không có hồ sơ '$profile' (xem profiles/)"
[ -n "$target" ] || die "target-dir rỗng"
case "$project_name" in *$'\n'*) die "project-name không được chứa xuống dòng" ;; esac
for topic in "${topics[@]}"; do
  [[ "$topic" =~ ^[a-z0-9-]+/[a-z0-9-]+$ ]] || die "tên topic không hợp lệ: '$topic'"
  [ -f "$KIT_DIR/topics/$topic/files.txt" ] || die "không có topic '$topic' (xem topics/README.md)"
  if { [ "$topic" = frontend/react ] || [ "$topic" = backend/nestjs ]; } && [ "$profile" != standard ] && [ "$profile" != full ]; then
    die "topic '$topic' cần hồ sơ standard hoặc full vì liên kết tới các tài liệu chung của hồ sơ đó"
  fi
done

# Không cho dựng vào chính bộ khuôn (tránh làm bẩn template/).
target_abs="$(abs_path "$target")"
[ ! -e "$target_abs" ] || [ -d "$target_abs" ] || die "target-dir không phải thư mục: $target"
case "$target_abs/" in
  "$KIT_DIR"/*) die "target-dir nằm trong bộ khuôn ($KIT_DIR). Dựng ra thư mục khác; với repo tạo bằng 'Use this template', xem README mục 'Cách dùng'." ;;
esac

today="$(date +%F)"
# mktemp luôn tạo file 0600; file .md/.yaml/.yml render qua file tạm được chmod về quyền mà umask
# của người gọi cho file mới (umask 022 -> 644), giống file chép bằng cp.
file_mode="$(printf '%o' $(( 0666 & ~0$(umask) )))"

# Đọc hồ sơ: bỏ comment, dòng trống; kiểm đường dẫn; tìm nguồn trước khi chép bất cứ gì.
paths=()
sources=()
while IFS= read -r line || [ -n "$line" ]; do
  line="${line%%#*}"
  line="$(printf '%s' "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  [ -n "$line" ] || continue
  case "$line" in
    /*|../*|*/../*|*/..|..) die "$profile.txt: đường dẫn không hợp lệ: $line" ;;
  esac
  dir="$(dirname "$line")"
  base="$(basename "$line")"
  if [ "${base%.*}" != "$base" ]; then
    variant="${base%.*}.$profile.${base##*.}"
  else
    variant="$base.$profile"
  fi
  if [ "$dir" = "." ]; then variant_path="$KIT_DIR/template/$variant"; else variant_path="$KIT_DIR/template/$dir/$variant"; fi
  if [ -f "$variant_path" ]; then
    src="$variant_path"
  elif [ -f "$KIT_DIR/template/$line" ]; then
    src="$KIT_DIR/template/$line"
  elif [ "$profile" = full ] && [ "$line" = docs/dev/frontend.md ]; then
    src="$KIT_DIR/topics/frontend/react/files/$line"
  elif [ -f "$KIT_DIR/$line" ]; then
    src="$KIT_DIR/$line"
  else
    die "$profile.txt: không tìm thấy nguồn cho $line"
  fi
  paths+=("$line")
  sources+=("$src")
done < "$profile_file"
[ "${#paths[@]}" -gt 0 ] || die "hồ sơ $profile rỗng"

# Topic dùng cùng đường dẫn ở project đích. Kiểm hết nguồn trước khi ghi file.
for topic in "${topics[@]}"; do
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%#*}"
    line="$(printf '%s' "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    [ -n "$line" ] || continue
    case "$line" in
      /*|../*|*/../*|*/..|..) die "$topic/files.txt: đường dẫn không hợp lệ: $line" ;;
    esac
    src="$KIT_DIR/topics/$topic/files/$line"
    [ -f "$src" ] || die "$topic/files.txt: không tìm thấy nguồn cho $line"
    # FULL đã gồm frontend; một topic lặp lại không được chép hai lần.
    duplicate=0
    for existing in "${paths[@]}"; do
      [ "$existing" = "$line" ] && duplicate=1 && break
    done
    [ "$duplicate" -eq 1 ] && continue
    paths+=("$line")
    sources+=("$src")
  done < "$KIT_DIR/topics/$topic/files.txt"
done

# Chép một file văn bản, thay tên dự án và ngày ở dòng metadata đầu file.
render() {
  local src="$1" dest="$2"
  PROJECT_NAME="$project_name" PLACEHOLDER="$PLACEHOLDER" DATE_PLACEHOLDER="$DATE_PLACEHOLDER" \
  awk -v today="$today" '
    # Thay chuỗi cố định (không phải regex), an toàn với mọi ký tự trong tên dự án.
    function replace_all(s, from, to,    out, i) {
      out = ""
      while ((i = index(s, from)) > 0) { out = out substr(s, 1, i - 1) to; s = substr(s, i + length(from)) }
      return out s
    }
    BEGIN { name = ENVIRON["PROJECT_NAME"]; ph = ENVIRON["PLACEHOLDER"]; dph = ENVIRON["DATE_PLACEHOLDER"]; done_meta = 0; fence = "" }
    {
      line = $0
      if (fence == "") {
        if (match(line, /^ ? ? ?(```|~~~)/)) { fence = substr(line, RSTART + RLENGTH - 3, 3) }
        else if (!done_meta && line ~ /^> Trạng thái:/) { gsub(/YYYY-MM-DD/, today, line); done_meta = 1 }
      } else if (line ~ ("^ ? ? ?" fence)) { fence = "" }
      if (name != "") line = replace_all(line, ph, name)
      line = replace_all(line, dph, today)
      print line
    }' "$src" > "$dest"
}

copied=0
skipped=0
[ "$dry_run" -eq 1 ] && printf '(chạy thử: không ghi gì)\n'
printf 'Hồ sơ: %s · Đích: %s · Tên dự án: %s · Ngày: %s\n' \
  "$profile" "$target_abs" "${project_name:-(giữ $PLACEHOLDER)}" "$today"
[ "${#topics[@]}" -eq 0 ] || printf 'Topic: %s\n' "${topics[*]}"

for i in "${!paths[@]}"; do
  rel="${paths[$i]}"
  src="${sources[$i]}"
  dest="$target_abs/$rel"
  from="${src#"$KIT_DIR"/}"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    printf '  bỏ qua  %s (đã có)\n' "$rel"
    skipped=$((skipped + 1))
    continue
  fi
  printf '  chép    %s  <-  %s\n' "$rel" "$from"
  copied=$((copied + 1))
  [ "$dry_run" -eq 1 ] && continue
  mkdir -p "$(dirname "$dest")"
  case "$rel" in
    *.md|*.yaml|*.yml)
      tmp="$(mktemp "$(dirname "$dest")/.new-project-docs.XXXXXX")"
      { render "$src" "$tmp" && chmod "$file_mode" "$tmp"; } || { rm -f "$tmp"; die "không ghi được $rel"; }
      mv "$tmp" "$dest"
      ;;
    *)
      cp "$src" "$dest"
      ;;
  esac
done

if [ "$dry_run" -eq 1 ]; then
  printf 'Tổng (chạy thử): %d sẽ chép, %d bỏ qua (đã có)\n' "$copied" "$skipped"
else
  printf 'Tổng: %d chép, %d bỏ qua (đã có)\n' "$copied" "$skipped"
fi
if [ "$skipped" -gt 0 ]; then
  printf 'File đã có được giữ nguyên. Xem đường dẫn nguồn ở các dòng "chép" khi cần so sánh.\n'
fi
checker="$target_abs/scripts/check-links.py"
[ -f "$checker" ] || checker="$KIT_DIR/scripts/check-links.py"
if [ "$dry_run" -eq 0 ] && [ "$profile" = minimal ]; then
  cat <<EOF
Tiếp theo: điền README.md bằng lệnh và thông tin thật của dự án; xoá mục chưa cần.
EOF
elif [ "$dry_run" -eq 0 ] && [ "$profile" = retiring ]; then
  cat <<EOF
Tiếp theo (hồ sơ retiring: không thêm tài liệu mới):
  1. Điền banner đầu README.md (ngày ngừng hẳn, hệ thống thay thế) và kế hoạch ngừng docs/plan/roadmap.md.
  2. File nào báo "bỏ qua" (repo đã có): dựng hồ sơ retiring ra thư mục tạm rồi chép banner, mục
     "Giai đoạn ngừng" và kế hoạch ngừng vào repo; cách làm trong PROFILES.md của bộ khuôn, mục RETIRING.
  3. Tìm chỗ cần điền: grep -nE '<[^!/-]|YYYY-MM-DD|CẦN XÁC NHẬN' "$target_abs/README.md" "$target_abs/docs/plan/roadmap.md"
  4. Kiểm link: python3 "$checker" "$target_abs"
EOF
elif [ "$dry_run" -eq 0 ] && [ "$copied" -gt 0 ]; then
  cat <<EOF
Tiếp theo:
  1. Mở docs/README.md (bản đồ tài liệu), xoá hàng không dùng; bắt đầu điền từ docs/product/spec.md
     (hồ sơ lite: mục đầu của docs/README.md).
  2. Tìm chỗ cần điền: grep -rnE '<[^!/-]|YYYY-MM-DD|CẦN XÁC NHẬN' "$target_abs/docs"
  3. Viết AGENTS.md sau cùng, khi docs/ đã có nội dung.
  4. Kiểm link: python3 "$checker" "$target_abs"
EOF
fi
