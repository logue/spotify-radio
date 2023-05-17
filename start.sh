#!/bin/bash

echo "💡 initializing..."
rm -rf /tmp/*
rm -rf /var/log/icecast2/*

echo "🔈 Starting pulseaudio..."
su - user -c "pulseaudio -D --exit-idle-time=-1"
sleep 2

echo "📻 Starting Icecast2..."
/etc/init.d/icecast2 start
sleep 2

echo "🎵 Starting spotifyd..."
su - user -c "spotifyd --username \"$SPOTIFY_USERNAME\" --password \"$SPOTIFY_PASSWORD\""
sleep 2

echo "🛂 Starting custom Boot Script..."
su - user -c "bash /home/user/custom_boot.sh"

echo "🧊 Starting darkice..."
su - user -c "darkice -c /home/user/darkice.cfg"
sleep 2

echo "🚩 Ready."
