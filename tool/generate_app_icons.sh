#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
master="$root/assets/branding/developer-wiki-app-logo.png"
res="$root/android/app/src/main/res"

if command -v magick >/dev/null 2>&1; then
  image_tool=(magick)
elif command -v convert >/dev/null 2>&1; then
  image_tool=(convert)
else
  echo "ImageMagick (magick oder convert) wird benötigt." >&2
  exit 1
fi

if [[ ! -f "$master" ]]; then
  echo "Logo-Master fehlt: $master" >&2
  exit 1
fi

# Die sichtbare Grafik wird anhand des Alpha-Kanals beschnitten. So bleiben
# unsichtbare RGB-Reste außerhalb des Logos ohne Einfluss auf die Skalierung.
trim_geometry="$(
  "${image_tool[@]}" "$master" \
    -alpha extract -threshold 1% -format '%@' info:
)"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
trimmed="$tmp_dir/logo-trimmed.png"
"${image_tool[@]}" "$master" -crop "$trim_geometry" +repage "$trimmed"

declare -A legacy_sizes=(
  [mdpi]=48
  [hdpi]=72
  [xhdpi]=96
  [xxhdpi]=144
  [xxxhdpi]=192
)

declare -A adaptive_sizes=(
  [mdpi]=108
  [hdpi]=162
  [xhdpi]=216
  [xxhdpi]=324
  [xxxhdpi]=432
)

for density in mdpi hdpi xhdpi xxhdpi xxxhdpi; do
  legacy_size="${legacy_sizes[$density]}"
  legacy_mark_size=$((legacy_size * 82 / 100))
  legacy_dir="$res/mipmap-$density"
  mkdir -p "$legacy_dir"

  "${image_tool[@]}" "$trimmed" \
    -resize "${legacy_mark_size}x${legacy_mark_size}>" \
    -gravity center -background none \
    -extent "${legacy_size}x${legacy_size}" \
    -strip "$legacy_dir/ic_launcher.png"
  cp "$legacy_dir/ic_launcher.png" "$legacy_dir/ic_launcher_round.png"

  adaptive_size="${adaptive_sizes[$density]}"
  # Androids sichere Zentralzone umfasst 66 % der adaptiven 108-dp-Fläche.
  adaptive_mark_size=$((adaptive_size * 66 / 100))
  adaptive_dir="$res/mipmap-$density"
  "${image_tool[@]}" "$trimmed" \
    -resize "${adaptive_mark_size}x${adaptive_mark_size}>" \
    -gravity center -background none \
    -extent "${adaptive_size}x${adaptive_size}" \
    -strip "$adaptive_dir/ic_launcher_foreground.png"
done

echo "Android-App-Icons aus $master erzeugt."
