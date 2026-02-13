#!/bin/zsh

# チェックボックス選択UI（外部ツール不要）
# source して checkbox_select 関数を利用する
# 結果は CHECKBOX_RESULT 配列に格納される
# 事前に messages.sh が source されている前提

_CHECKBOX_HEADER_LINES=3
_CHECKBOX_INDICATOR_LINES=2
_CHECKBOX_FOOTER_LINES=2

# checkbox_select <header> <page_info> <confirm_label> <items...>
# 戻り値: 0=確定, 1=キャンセル
# 結果: CHECKBOX_RESULT 配列に選択されたアイテムが格納される
checkbox_select() {
  local header="$1"
  local page_info="$2"
  local confirm_label="$3"
  shift 3
  local items=("$@")
  local total=${#items[@]}

  typeset -A selected
  for item in "${items[@]}"; do
    selected[$item]=1
  done

  local cursor=0
  local scroll_offset=0
  local term_height=$(tput lines)
  local max_visible=$((term_height - _CHECKBOX_HEADER_LINES - _CHECKBOX_INDICATOR_LINES - _CHECKBOX_FOOTER_LINES))
  if (( max_visible < 3 )); then max_visible=3; fi

  tput civis
  tput clear

  local list_start=$((_CHECKBOX_HEADER_LINES + 1))

  while true; do
    if (( cursor < scroll_offset )); then
      scroll_offset=$cursor
    elif (( cursor >= scroll_offset + max_visible )); then
      scroll_offset=$((cursor - max_visible + 1))
    fi

    local end=$((scroll_offset + max_visible))
    if (( end > total )); then end=$total; fi

    # ヘッダー（固定位置）
    tput cup 0 0
    printf "\033[1m%s\033[0m  \033[2m%s\033[0m\033[K\n" "$header" "$page_info"
    printf "${_MSG[checkbox_help]}\033[K\n" "$confirm_label"
    printf "\033[K\n"

    # 上スクロールインジケータ
    tput cup $_CHECKBOX_HEADER_LINES 0
    if (( scroll_offset > 0 )); then
      printf "   \033[2m$(printf "${_MSG[scroll_up]}" "$scroll_offset")\033[0m\033[K\n"
    else
      printf "\033[K\n"
    fi

    # リスト（スクロール領域）
    tput cup $list_start 0
    for (( i = 0; i < max_visible; i++ )); do
      local idx=$((scroll_offset + i))
      if (( idx < total )); then
        local item="${items[$((idx + 1))]}"
        local check=" "
        [[ "${selected[$item]}" == "1" ]] && check="✔"

        if (( idx == cursor )); then
          printf "\033[36m\033[1m > [%s] %s\033[0m\033[K\n" "$check" "$item"
        else
          printf "   [%s] %s\033[K\n" "$check" "$item"
        fi
      else
        printf "\033[K\n"
      fi
    done

    # 下スクロールインジケータ
    local remaining=$((total - end))
    if (( remaining > 0 )); then
      printf "   \033[2m$(printf "${_MSG[scroll_down]}" "$remaining")\033[0m\033[K\n"
    else
      printf "\033[K\n"
    fi

    # フッター（固定位置）
    local selected_count=0
    for item in "${items[@]}"; do
      [[ "${selected[$item]}" == "1" ]] && ((selected_count++))
    done
    printf "\033[K\n"
    printf " ${_MSG[selected_count]}\033[K" "$selected_count" "$total"

    read -k 1 key 2>/dev/null

    case "$key" in
      $'\e')
        read -k 1 -t 0.1 key2 2>/dev/null
        if [[ "$key2" == "[" ]]; then
          read -k 1 -t 0.1 key3 2>/dev/null
          case "$key3" in
            A) (( cursor > 0 )) && ((cursor--)) ;;
            B) (( cursor < total - 1 )) && ((cursor++)) ;;
          esac
        fi
        ;;
      " ")
        local item="${items[$((cursor + 1))]}"
        if [[ "${selected[$item]}" == "1" ]]; then
          selected[$item]=0
        else
          selected[$item]=1
        fi
        ;;
      a) for item in "${items[@]}"; do selected[$item]=1; done ;;
      n) for item in "${items[@]}"; do selected[$item]=0; done ;;
      q) CHECKBOX_RESULT=(); tput cnorm; return 1 ;;
      $'\n') break ;;
    esac
  done

  tput cnorm

  CHECKBOX_RESULT=()
  for item in "${items[@]}"; do
    [[ "${selected[$item]}" == "1" ]] && CHECKBOX_RESULT+=("$item")
  done
  return 0
}
