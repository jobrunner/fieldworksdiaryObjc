#!/bin/sh
set -e

brew update
brew install xctool
export LANG=en_US.UTF-8
rvm install ruby-2.1.2
rvm use 2.1.2
sudo gem install cocoapods
