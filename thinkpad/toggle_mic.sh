#!/bin/bash
INPUT_DEVICE="'Capture'"
if amixer sget $INPUT_DEVICE,0 | grep '\[on\]' ; then
    amixer sset $INPUT_DEVICE,0 toggle
    notify-send 'Microphone' 'Muted' -t 50 -i microphone-sensitivity-muted-symbolic
else
    amixer sset $INPUT_DEVICE,0 toggle
    notify-send 'Microphone' 'Enabled' -t 50 -i microphone-sensitivity-high-symbolic
fi
