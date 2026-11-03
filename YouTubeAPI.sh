#!/bin/bash

# --- CONFIGURATION ---
# Replace these with your actual Google Cloud Console API credentials

currentuser=$(users | awk '{print $1}')

cat <<'EOF'> /home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/addon_data/plugin.video.youtube/api_keys.json
{
    "keys": {
        "developer": {},
        "user": {
            "api_key": "AIzaSyB5ouj1587KeOyfa1NCOi_H-MG_pWv2xHM",
            "client_id": "559344656644-luav1m2ggerrdm4037q9af38u9k3bmal",
            "client_secret": "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"
        }
    }
}
EOF
