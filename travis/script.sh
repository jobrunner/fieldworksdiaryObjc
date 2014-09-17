#!/bin/sh
set -e

xctool -workspace fieldworksdiary.xcworkspace -scheme fieldworksdiary -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
xctool test -workspace fieldworksdiary.xcworkspace -scheme fieldworksdiaryTests -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
