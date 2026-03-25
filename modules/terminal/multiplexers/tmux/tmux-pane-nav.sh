#!/usr/bin/env sh

direction="$1"
current_pane="$(tmux display-message -p '#{pane_id}')"

current_left=""
current_right=""
current_top=""
current_bottom=""

panes="$(tmux list-panes -F '#{pane_id}	#{pane_left}	#{pane_right}	#{pane_top}	#{pane_bottom}')"

old_ifs=$IFS
IFS='
'
for line in $panes; do
    IFS='	'
    set -- $line
    IFS='
'
    pane_id="$1"
    left="$2"
    right="$3"
    top="$4"
    bottom="$5"

    if [ "$pane_id" = "$current_pane" ]; then
        current_left="$left"
        current_right="$right"
        current_top="$top"
        current_bottom="$bottom"
        break
    fi
done
IFS=$old_ifs

target_id=""
target_key=""

IFS='
'
for line in $panes; do
    IFS='	'
    set -- $line
    IFS='
'
    pane_id="$1"
    left="$2"
    right="$3"
    top="$4"
    bottom="$5"

    overlap=1
    if [ "$right" -lt "$current_left" ] || [ "$left" -gt "$current_right" ]; then
        overlap=0
    fi
    [ "$overlap" -eq 1 ] || continue
    [ "$pane_id" = "$current_pane" ] && continue

    case "$direction" in
        up)
            if [ "$bottom" -lt "$current_top" ]; then
                key="$bottom"
                if [ -z "$target_key" ] || [ "$key" -gt "$target_key" ]; then
                    target_key="$key"
                    target_id="$pane_id"
                fi
            fi
            ;;
        down)
            if [ "$top" -gt "$current_bottom" ]; then
                key="$top"
                if [ -z "$target_key" ] || [ "$key" -lt "$target_key" ]; then
                    target_key="$key"
                    target_id="$pane_id"
                fi
            fi
            ;;
    esac
done

if [ -z "$target_id" ]; then
    IFS='
'
    for line in $panes; do
        IFS='	'
        set -- $line
        IFS='
'
        pane_id="$1"
        left="$2"
        right="$3"
        top="$4"
        bottom="$5"

        overlap=1
        if [ "$right" -lt "$current_left" ] || [ "$left" -gt "$current_right" ]; then
            overlap=0
        fi
        [ "$overlap" -eq 1 ] || continue
        [ "$pane_id" = "$current_pane" ] && continue

        case "$direction" in
            up)
                key="$top"
                if [ -z "$target_key" ] || [ "$key" -gt "$target_key" ]; then
                    target_key="$key"
                    target_id="$pane_id"
                fi
                ;;
            down)
                key="$top"
                if [ -z "$target_key" ] || [ "$key" -lt "$target_key" ]; then
                    target_key="$key"
                    target_id="$pane_id"
                fi
                ;;
        esac
    done
fi

IFS=$old_ifs

if [ -n "$target_id" ]; then
    tmux select-pane -t "$target_id"
fi
