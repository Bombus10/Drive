#!/usr/bin/env bash
# shellcheck disable=SC1090
# shellcheck disable=SC2162

PACKAGE_LIST=$(whiptail --fb --separate-output --checklist "Install Packages" 30 100 20\
    "opera" "Opera browser (snap package)" ON \
    "code" "Visual Studio Code (snap package)" OFF \
    "smartmontools" "Control and monitor storage systems using S.M.A.R.T." ON \
    "shellcheck" "Lint tool for shell scripts. Used by VSCode" ON \
    "glmark2-wayland" "Graphics card benchmark for Wayland" ON \
    "net-tools" "Networking toolkit: ifconfig, nslookup, ping" ON \
    "gnome-shell-extension-manager" "Used for installing custom-hot-corners" ON \
    "curl" "Command line tool for transferring data with URL syntax " ON \
    "ufw" "Enable firewall" ON \
    "source-highlight" "Allows syntax highlighting in less" ON \
    "Steam" "Games engine" Off \
    3>&1 1>&2 2>&3)


if [[ -n "$PACKAGE_LIST" ]]; then
# Update all packages
    echo -e "\n#### Updating existing packages ####"
    sudo apt -y update && sudo apt -y upgrade
    sudo snap refresh
    
    for select_package in $PACKAGE_LIST; do
        case "$select_package" in
            # Install Snap Packages
            opera|code|steam)
                echo -e "\n#### Installing $select_package (snap package) ####"
                sudo snap install "$select_package"
                ;;
            # Install Apt Packages
            *)
                echo -e "\n#### Installing $select_package ####"
                sudo apt -y install "$select_package"
                # Special configurations
                case "$select_package" in
                    source-highlight)
                        if ! grep -q 'export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"' ~/.bashrc && grep -q "export LESS=' -cR '" ~/.bashrc; then
                        cat << 'EOF' >> ~/.bashrc
                        
                        # enable source highlighting in less
                        export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
                        export LESS=' -cR '
EOF
                        source ~/.bashrc
                        fi
                        ;;
                        git)
                            cur_git_user=$(git config --global user.name)
                            if [ -z "$cur_git_user" ]; then
                                echo 'Configuring github'
                                read -p "Enter Github Username: " githubusername
                                read -p "Enter Github Email: " githubemail
                                git config --global user.name "$githubusername"
                                git config --global user.email "$githubemail"
                            else
                                echo "Github already configured with username ${cur_git_user}"
                            fi
                        ;;
                        ufw)
                            sudo ufw enable
                        ;;
                esac
        esac
    done
sudo apt -y autoremove
fi


TWEAK_LIST=$(whiptail --fb --separate-output --checklist "User Interface Tweaks" 30 110 20 \
    "Pin-Apps" "Pin favorite-apps to dock: Opera, Firefox, Terminal, Settings, VSCode, Files" ON \
    "smartmontools" "Control and monitor storage systems using S.M.A.R.T." ON \
    "Dark-Mode" "Set color scheme to prefer-dark" ON \
    "Hide-Dock" "Hide dock when not in use" ON \
    "Multimonitor-Dock" "Show dock on all monitors" ON \
    "Dock-Bottom" "Position dock to bottom of screen" ON \
    3>&1 1>&2 2>&3)

if [[ -n "$TWEAK_LIST" ]]; then
    for select_tweak in $TWEAK_LIST; do
        case "$select_tweak" in
            "Pin-Apps")
            gsettings set org.gnome.shell favorite-apps "['opera_opera.desktop', 'firefox_firefox.desktop, 'org.gnome.Terminal.desktop', 'org.gnome.Settings.desktop', 'code.desktop', 'org.gnome.Nautilus.desktop']"
            ;;
            "Dark-Mode")
            gsettings set org.gnome.desktop.interface color-scheme prefer-dark
            ;;
            "Hide-Dock")
            gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
            gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
            gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
            ;;
            "Dock-Bottom")
            gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
            ;;
            "Multimonitor-Dock")   
            gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
            ;;
        esac
    done
fi

echo "Thank you for using Xander's CompSci_setup script!" 