#!/bin/bash

set -e -u -o pipefail

options=()

image_path="$(zenity --file-selection --title="プロットする画像を選択 - Printoon")"

if zenity --question --text="反転モードを使用しますか?" --title="反転モード - Printoon" --width=360; then
    options+=("i=true")
fi

temp_image_path="$(./plot.sh "$image_path" ${options[@]} dont_plot=true print_image_path=true 2> /dev/null)"

if zenity --question --text="プロットされる画像を確認しますか?" --title="プレビュー - Printoon" --width=360; then
    eog "$temp_image_path"

    if zenity --question --text="プロットを行いますか?" --title="プレビュー - Printoon" --width=360; then
        : # do nothing
    else
        exit 1
    fi
fi

./plot.sh "$image_path" ${options[@]} process_image=false
