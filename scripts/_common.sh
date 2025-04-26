#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

#=================================================
# PERSONAL HELPERS
#=================================================

# https://rclone.org/downloads/#script-download-and-install
# Script return 3 if rclone already installed. For installation process, is not an error
install_rclone() {   
    if curl -s https://rclone.org/install.sh 2>/dev/null | bash; then
        return 0
    else
        ret=$?
        if [[ $ret -ne 3 ]]; then
            return 1
        fi
    fi
    return 0
}

# We don't remove Rclone because it could be installed before
remove_rclone() {
    echo "We don't uninstall rclone because it could be necessary for another app"
    true
}


#=================================================
# CONFIG PANELS HELPERS
#=================================================

# Print a multilanguage alert message for markdown inputs
# You need to define associative array messages like this :
# declare -A messages=([fr]="Message en français" [en]="English message" [es]="Mensaje en español" ...)
# inside your fonction and then call this function
# $1 : style (string) alert style can be : info(default), warning, danger
i8n_markdown_alert() {
    local style=${1:-info}

    if [[ ${#messages[@]} -eq 0 ]]; then
        return 0
    fi

    echo "ask:"

    for lang in "${!messages[@]}"; do
        echo "  ${lang}: <div class=\"alert alert-${style}\">${messages[${lang}]}</div>"
    done
}

# Print a multilanguage alert message for alert inputs
# You need to define associative array messages like this :
# declare -A messages=([fr]="Message en français" [en]="English message" [es]="Mensaje en español" ...)
# inside your fonction and then call this function
# $1 : style (string) alert style can be : info(default), warning, danger
i8n_alert() {
    local style=${1:-info}

    echo "style: '${style}'"
    echo "ask:"

    for lang in "${!messages[@]}"; do
        echo "  ${lang}: \"${messages[${lang}]}\""
    done
}


#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
