#!/bin/bash

set -e -u -o pipefail

echoerr() {
    echo "$@" 1>&2
}

echoerr "Printoon 1.0.0"

image_path="$1"
i=false
dont_plot=false
process_image=true
print_image_path=false
button_press_time=0.06
button_cool_time=0.04

shift
eval "$@"

plot_color="#000000"
if ${i}; then
    echoerr "反転モードを使用します。"
    plot_color="#FFFFFF"
fi
macro_path="/tmp/printoon-macro.txt"
image_name="$(basename "$image_path")"
temp_image_name="${image_name%.*}.tmp.png"
temp_text_name="${image_name%.*}.txt"
# temp_image_path="/tmp/${temp_image_name}"
temp_image_path="$(dirname "$image_path")/${temp_image_name}"
temp_text_path="$(dirname "$image_path")/${temp_text_name}"


if ${process_image}; then
    echoerr "ファイル $image_name を処理しています..."

    convert "$image_path" -resize 320x120! -monochrome "$temp_image_path"
    convert "$temp_image_path" "$temp_text_path"

    echoerr "画像処理が完了しました。"
fi

if ${print_image_path}; then
    echo "$temp_image_path"
fi


if ${dont_plot}; then
    exit 0
fi

if hcitool dev | fgrep 'hci0' &> /dev/null; then
    : # do nothing
else
    echoerr "Bluetooth がオフになっています。"
    exit 1
fi

# nxbt macro -r -c " " &> /dev/null || true
# if bluetoothctl info "04:03:D6:A1:A2:79" | fgrep "Connected: yes"; then
#     : # do nothing
# else
#     echoerr "認識可能なニンテンドースイッチが見つからないため中断します。"
#     exit 1
# fi


generate_table() {
    search_string="$plot_color"
    eval $(
        cat "$temp_text_path" |
        tail -n +2 |
        sed -e "/$search_string/"'s/^\(.\+\),\(.\+\):.\+$/pixel_\1_\2=true/g' |
        sed -e "/$search_string/!"'s/^\(.\+\),\(.\+\):.\+$/pixel_\1_\2=false/g'
    )
}

last_button=""
macro=""
macro+="L_STICK@-100+100 4.0s"$'\n'
macro+=" 1.0s"$'\n'

append_macro() {
    button="$1"
    if [ "$last_button" == "$button" ]; then
        macro+=" ${button_cool_time}s"$'\n'
    fi
    macro+="$button ${button_press_time}s"$'\n'
    last_button="$button"
}

generate_macro() {
    local min_0
    local max_0
    local next_min_0
    local next_max_0
    local is_clear_0
    local is_clear_1
    declare -a min_0_list
    declare -a max_0_list
    for get_1 in {0..119..2}; {
        min_0=319
        max_0=0
        for get_0 in {0..319}; {
            name_a="pixel_${get_0}_${get_1}"
            name_b="pixel_${get_0}_$(($get_1 + 1))"
            if ${!name_a} || ${!name_b}; then
                if (( $min_0 > $get_0 )); then
                    min_0=$get_0
                fi
                max_0=$get_0
            fi
        }
        min_0_list[$get_1]=$min_0
        max_0_list[$get_1]=$max_0
    }

    direction_0=1
    direction_1=1
    offset_0=0
    for base_1 in {0..119..2}; {
        min_0=${min_0_list[$base_1]}
        max_0=${max_0_list[$base_1]}
        next_min_0=${min_0_list[$(($base_1 + 2))]:-319}
        next_max_0=${max_0_list[$(($base_1 + 2))]:-0}
        if (( $min_0 > $max_0 )); then
            is_clear_1=true
        else
            is_clear_1=false
        fi

        if ${is_clear_1}; then
            : # do nothing
        else
            for base_0 in $(seq $offset_0 319); {
                offset_0=0
                if (( $direction_0 == 1 )); then
                    get_0=$base_0
                else
                    get_0=$(( 319 - $base_0 ))
                fi
                get_1=$base_1
                name_a="pixel_${get_0}_${get_1}"
                name_b="pixel_${get_0}_$(($get_1 + 1))"
                if ${!name_a} || ${!name_b}; then
                    is_clear_0=false
                else
                    is_clear_0=true
                fi

                if ${is_clear_0}; then
                    : # do nothing
                else
                    for offset_1 in {0..1}; {
                        if (( $direction_1 == 1 )); then
                            get_1=$(( $base_1 + $offset_1 ))
                        else
                            get_1=$(( $base_1 + 1 - $offset_1 ))
                        fi
                        name="pixel_${get_0}_${get_1}"
                        if ${!name}; then
                            append_macro "A"
                        fi

                        if (( $offset_1 == 0 )); then
                            if (( $direction_1 == 1 )); then
                                append_macro "DPAD_DOWN"
                            else
                                append_macro "DPAD_UP"
                            fi
                        fi
                    }
                    direction_1=$(( - $direction_1 ))
                fi

                if (( $direction_0 == 1 )); then
                    if (( $get_0 >= $max_0 && $get_0 >= $next_max_0 )); then
                        offset_0=$(( 319 - $get_0 ))
                        break
                    fi
                    append_macro "DPAD_RIGHT"
                else
                    if (( $get_0 <= $min_0 && $get_0 <= $next_min_0 )); then
                        offset_0=$get_0
                        break
                    fi
                    append_macro "DPAD_LEFT"
                fi
            }
        fi

        if ${is_clear_1}; then
            append_macro "DPAD_DOWN"
            append_macro "DPAD_DOWN"
        else
            if (( $direction_1 == 1 )); then
                append_macro "DPAD_DOWN"
                append_macro "DPAD_DOWN"
            else
                append_macro "DPAD_DOWN"
                direction_1=$(( - $direction_1 ))
            fi
            direction_0=$(( - $direction_0 ))
        fi
    }
}


generate_table

echoerr "マクロを作成しています..."
generate_macro
echo "$macro" > "$macro_path"


echoerr "プロットしています..."

if nxbt macro -r -c "$macro_path" &> /dev/null; then
    echoerr "プロットが終了しました。"
else
    echoerr "プロットがキャンセルされました。"
fi
