#!/bin/bash

adb devices
adb shell settings put global window_animation_scale 0 &
adb shell settings put global transition_animation_scale 0 &
adb shell settings put global animator_duration_scale 0 &
adb shell input keyevent 82 &
adb shell settings put secure show_ime_with_hard_keyboard 0 &
