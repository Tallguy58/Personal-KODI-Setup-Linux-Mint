#!/bin/bash

# --- CONFIGURATION ---
# Replace these with your actual Google Cloud Console API credentials
API_KEY="YOUR_NEW_API_KEY"
CLIENT_ID="YOUR_NEW_CLIENT_://googleusercontent.com"
CLIENT_SECRET="YOUR_NEW_CLIENT_SECRET"

# Detect OS and set the correct Kodi userData path
if [ -d "$HOME/.kodi/userdata" ]; then
    # Linux / Raspberry Pi (LibreELEC path might differ, usually /storage/.kodi/)
    YOUTUBE_SETTINGS="$HOME/.kodi/userdata/addon_data/plugin.video.youtube/settings.xml"
elif [ -d "$HOME/Library/Application Support/Kodi/userdata" ]; then
    # macOS
    YOUTUBE_SETTINGS="$HOME/Library/Application Support/Kodi/userdata/addon_data/plugin.video.youtube/settings.xml"
elif [ -d "/storage/.kodi/userdata" ]; then
    # LibreELEC / CoreELEC
    YOUTUBE_SETTINGS="/storage/.kodi/userdata/addon_data/plugin.video.youtube/settings.xml"
else
    echo "❌ Error: Could not find Kodi userdata folder."
    echo "Please edit this script and manually set the YOUTUBE_SETTINGS path."
    exit 1
fi

# Check if the settings file actually exists
if [ ! -f "$YOUTUBE_SETTINGS" ]; then
    echo "❌ Error: YouTube settings.xml not found at:"
    echo "  $YOUTUBE_SETTINGS"
    echo "Have you run the YouTube addon at least once?"
    exit 1
fi

# Create a backup just in case
cp "$YOUTUBE_SETTINGS" "${YOUTUBE_SETTINGS}.bak"
echo "💾 Backup created at ${YOUTUBE_SETTINGS}.bak"

# Use python to safely update the XML attributes
python3 -c "
import xml.etree.ElementTree as ET
import sys

file_path = '$YOUTUBE_SETTINGS'
tree = ET.parse(file_path)
root = tree.getroot()

updated = 0
for setting in root.findall('setting'):
    setting_id = setting.get('id')
    if setting_id == 'youtube.api.key':
        setting.text = '$API_KEY'
        updated += 1
    elif setting_id == 'youtube.api.client.id':
        setting.text = '$CLIENT_ID'
        updated += 1
    elif setting_id == 'youtube.api.client.secret':
        setting.text = '$CLIENT_SECRET'
        updated += 1

if updated > 0:
    tree.write(file_path, encoding='utf-8', xml_declaration=True)
    print('✅ Successfully updated {} API fields in settings.xml'.format(updated))
else:
    print('❌ Failed to find the target API settings fields.')
"
