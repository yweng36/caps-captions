#!/bin/bash
CURRENT=$(SwitchAudioSource -c)
if [ "$CURRENT" = "CAPS Multi-Output" ]; then
    SwitchAudioSource -s "MacBook Air Speakers"
    echo "已切换到 MacBook Air Speakers（普通模式）"
else
    SwitchAudioSource -s "CAPS Multi-Output"
    echo "已切换到 CAPS Multi-Output（字幕模式）"
fi
