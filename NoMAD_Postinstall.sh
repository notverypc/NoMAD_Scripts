#!/bin/bash
# Postinstall Script for NoMAD
# Written by Ben Reilly https://github.com/notverypc

# Console user
consoleuser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
consoleuserUID=$(id -u $consoleuser)

# Find LaunchAgent
FullLaunchAgentPath=$(/usr/bin/find /Library/LaunchAgents -maxdepth 1 -type f -iname "*nomad*.plist")
#echo $FullLaunchAgentPath
LaunchAgent=$(/usr/bin/find /Library/LaunchAgents -maxdepth 1 -type f -iname "*nomad*.plist" -exec basename {} \;)
#echo $LaunchAgent
kickstart=$(/usr/bin/find /Library/LaunchAgents -maxdepth 1 -type f -iname "*nomad*.plist" -exec basename {} .plist \;)
#echo $kickstart

# Load LaunchAgents
launchctl bootstrap gui/$consoleuserUID $FullLaunchAgentPath
launchctl enable gui/$consoleuserUID/$LaunchAgent
launchctl kickstart -k gui/$consoleuserUID/$kickstart
