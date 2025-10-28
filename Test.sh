#!/usr/bin/env bash


CHOICES1=$(whiptail --fb --separate-output --checklist "Choose Apt Packages" 20 78 10 \
    "Opera" "" ON \
    "plocate" "" ON \
    "smartmontools" "" ON \
    "VSCode" "" ON \
    "shellcheck" "" ON \
    "glmark2" "" ON \
    "net-tools" "" ON \
    "gnome-shell-extension-manager" "" ON \
    "curl" "" ON \
    "Source-highlight" "" ON 3>&1 1>&2 2>&3)

if ! [ -z "$CHOICE1" ]; then
  echo "No option was selected (user hit Cancel or unselected all options)"
else
    for CHOICE1 in $CHOICES1; do
        case "$CHOICE1" in
            "VSCode")
            if ! find /etc/apt/sources.list.d/ -name 'vscode.sources'; then
                wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/packages.microsoft.gpg 
                echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
                sudo apt -y install code
                echo 'updating your system'
                sudo apt -y update && sudo apt -y upgrade
                echo 'updating snap packages'
                sudo snap refresh
            else 
                echo 'VSCode already installed, skipping'
                echo 'updating your system'
                sudo apt -y update && sudo apt -y upgrade
                echo 'updating snap packages'
                sudo snap refresh
            fi
            ;;
            "Opera")
            if ! snap list | grep -q '^opera'; then
                sudo snap install opera
            else
                echo 'opera already installed, skipping'
            fi
            ;;
            "plocate")
            if dpkg -l | grep -q 'ii plocate'; then
                sudo apt -y install plocate
            else 
                echo 'plocate already installed, skipping'
            fi
            ;;
            "smartmontools")
            if dpkg -l | grep -q 'ii smartmontools'; then
                sudo apt -y install smartmontools
            else 
                echo 'smartmontools already installed, skipping'
            fi
            ;;
            "shellcheck")
            if dpkg -l | grep -q 'ii shellcheck'; then
                sudo apt -y install shellcheck
            else 
                echo 'shellcheck already installed, skipping'
            fi
            ;;
            "glmark2")
            if dpkg -l | grep -q 'ii glmark2'; then
                sudo apt -y install glmark2
            else 
                echo 'glmark2 already installed, skipping'
            fi
            ;;
            "net-tools")   
            if dpkg -l | grep -q 'ii net-tools'; then
                sudo apt -y install net-tools
            else 
                echo 'net-tools already installed, skipping'
            fi
            ;;
            "gnome-shell-extension-manager")
            if dpkg -l | grep -q 'ii gnome-shell-extension-manager'; then
                sudo apt -y install gnome-shell-extension-manager
            else 
                echo 'gnome shell extension manager already installed, skipping'
            fi
            ;;
            "curl")
            if dpkg -l | grep -q 'ii curl'; then
                sudo apt -y install curl
            else 
                echo 'curl already installed, skipping'
            fi
            ;;
            "Source-highlight")
            if dpkg -l | grep -q 'ii source-highlight'; then
                sudo apt -y install source-highlight
                if grep -q 'export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"' ~/.bashrc && grep -q "export LESS=' -cR '" ~/.bashrc; then
                    echo 'less already configured to use source highlight, skipping'
                else
                    echo 'configuring less to use source highlight'
                    echo -e '\n # enable source highlighting in less' >> ~/.bashrc
                    echo 'export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"' >> ~/.bashrc
                    echo "export LESS=' -cR '" >> ~/.bashrc
                    source ~/.bashrc
                fi
            else 
                echo 'source-highlight already installed, skipping'
            fi
            ;;
            *)
            echo "Unsupported item $CHOICE1!" >&2
            exit 1
            ;;
    esac
  done
fi

if ! find /etc/apt/sources.list.d/ -name 'vscode.sources'; then
    if whiptail --yesno "Are you sure?" 10 100; then
        echo 'updating your system'
        sudo apt -y update && sudo apt -y upgrade
        echo 'updating snap packages'
        sudo snap refresh
    else
        echo "No Update performed"
    fi
else
    echo "echo 'updating your system"
    sudo apt -y update && sudo apt -y upgrade
    echo 'updating snap packages'
    sudo snap refresh
fi


CHOICES2=$(whiptail --fb --separate-output --checklist "Easy Defaults" 20 78 10 \
    "Format_Taskbar" "Has Opera, Firefox, Bash Terminal, Settings, VSCode, and File Explorer" ON \
    "Dark_Mode" "" ON \
    "Aute_Hide_Taskbar" "When not in use the taskbar disappears" ON \
    "Fixed_Taskbar_Off" "" ON \
    "Intelligent_Hide_Taskbar_Off" "" ON \
    "Taskbar_On_Bottom" "Taskbar is set on the bottom of the screen" ON \
    "Multimonitor_Tasbkar" "Taskbar is on all monitors" ON 3>&1 1>&2 2>&3)

if ! [ -z "$CHOICE2" ]; then
  echo "No option was selected (user hit Cancel or unselected all options)"
else
    for CHOICE2 in $CHOICES2; do
        case "$CHOICE2" in
            "Format_Taskbar")
            gsettings set org.gnome.shell favorite-apps "['opera_opera.desktop', 'firefox_firefox.desktop, 'org.gnome.Terminal.desktop', 'org.gnome.Settings.desktop', 'code.desktop', 'org.gnome.Nautilus.desktop']"
            ;;
            "Dark_Mode")
            gsettings set org.gnome.desktop.interface color-scheme prefer-dark
            ;;
            "Aute_Hide_Taskbar")
            gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
            ;;
            "Fixed_Taskbar_Off")
            gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
            ;;
            "Intelligent_Hide_Taskbar_Off")
            gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
            ;;
            "Taskbar_On_Bottom")
            gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
            ;;
            "Multimonitor_Tasbkar")   
            gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
            ;;
            *) 
            echo "Unsupported item $CHOICE2!" >&2
            exit 1
            ;;
    esac
  done
fi