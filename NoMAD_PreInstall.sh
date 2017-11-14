#!/bin/bash

# Pre-Install script based on the one shared by  richard at richard - purves dot com
# Written by Ben Reilly https://github.com/notverypc
# Orignal Sctipt is here: https://macadmins.slack.com/files/U056UG2QX/F7V9W2068/nomad-preinstall_sh.sh

# Get Console User and UID
consoleuser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

# Find LaunchAgent
FullLaunchAgentPath=$(/usr/bin/find /Library/LaunchAgents -maxdepth 1 -type f -iname "*nomad*.plist")
LaunchAgent=$(/usr/bin/find /Library/LaunchAgents -maxdepth 1 -type f -iname "*nomad*.plist" -exec basename {} \;)

# Is anyone logged in?
if [ -n "$consoleuser" ]; then
	# User present. We must be cautious.

	# Find if there's a launch agent present
	if [ ! -z "$LaunchAgent" ];
	then
		# Kill the launch agent. No mercy.
		/usr/bin/sudo -iu "$consoleuser" launchctl unload "$FullLaunchAgentPath"
	fi

  # Is NoMAD running?
	pid=$( /usr/bin/pgrep NoMAD )
	if [ ! -z "$pid" ];
	then
		/bin/kill -9 $pid
	fi
fi
