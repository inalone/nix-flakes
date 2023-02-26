#!/bin/bash

date_and_week=$(date "+%d/%m/%Y")
current_time=$(date "+%H:%M:%S")

battery_charge=$(cat /sys/class/power_supply/BAT1/capacity)
battery_status=$(cat /sys/class/power_supply/BAT1/status)

#audio_device="$(~/.config/sway/audio_sink.sh get)"
audio_device="poo"
wpctl_output="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
is_muted="$(echo $wpctl_output | grep MUTED)"
volume_decimal="${wpctl_output:8:4}"
volume="$(awk -v volume_decimal="${volume_decimal}" 'BEGIN{volume=(volume_decimal*100); print volume}')%"

if [ $battery_status = "Discharging" ];
then
		if [ $battery_charge -lt "20" ];
		then
			battery_icon='🪫'
		else
    	battery_icon='🔋'
		fi
else
    battery_icon='⚡'
fi

if [ ! -z "$is_muted" ]; then
	volume="🔇"
fi

echo "$audio_device $volume | $battery_icon $battery_charge% | $date_and_week $current_time"
