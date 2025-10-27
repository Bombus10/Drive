#!/usr/bin/env bash


if ! find /etc/apt/sources.list.d/ -name 'vscode.sources'; then
    echo 'Adding Visual Studio Code repository'
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/packages.microsoft.gpg 
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
else 
    echo 'visual studio code repo already installed, skipping'
fi

echo 'updating your system'
sudo apt -y update && sudo apt -y upgrade

echo 'updating snap packages'
sudo snap refresh

if ! snap list | grep -q '^opera'; then
    echo 'installing opera'
    sudo snap install opera
else
    echo 'opera already installed, skipping'
fi

echo 'enabling firewall'
sudo ufw enable

if ! dpkg -l | grep -q 'ii plocate'; then
    echo 'installing plocate'
    sudo apt -y install plocate
else 
    echo 'plocate already installed, skipping'
fi

if ! dpkg -l | grep -q 'ii smartmontools'; then
    echo 'installing smartmontools'
    sudo apt -y install smartmontools
else 
    echo 'smartmontools already installed, skipping'
fi

if ! dpkg -l | grep -q 'ii code'; then
    echo 'installing VSCode'
    sudo apt -y install code
else 
    echo 'VSCode already installed, skipping'
fi

if ! dpkg -l | grep -q 'ii shellcheck'; then
    echo 'installing shellcheck'
    sudo apt -y install shellcheck
else 
    echo 'shellcheck already installed, skipping'
fi

if ! dpkg -l | grep -q 'ii glmark2'; then
    echo 'installing glmark2'
    sudo apt -y install glmark2
else 
    echo 'glmark2 already installed, skipping'
fi

if ! dpkg -l | grep -q 'ii net-tools'; then
    echo 'installing net-tools'
    sudo apt -y install net-tools
else 
    echo 'net-tools already installed, skipping'
fi

if ! dpkg -l | grep -q 'ii  gnome-shell-extension-manager'; then
    echo 'installing gnome shell extension manager'
    sudo apt -y install gnome-shell-extension-manager
else 
    echo 'gnome shell extension manager already installed, skipping'
fi

if ! dpkg -l | grep -q 'ii  curl'; then
    echo 'installing curl'
    sudo apt -y install curl
else 
    echo 'curl already installed, skipping'
fi

if ! dpkg -l | grep -q 'ii  source-highlight'; then
    echo 'enabling source highlight for less'
    sudo apt -y install source-highlight
else 
    echo 'source-highlight already installed, skipping'
fi

if grep -q 'export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"' ~/.bashrc && grep -q "export LESS=' -cR '" ~/.bashrc; then
    echo 'less already configured to use source highlight, skipping'
else
    echo 'configuring less to use source highlight'
    echo -e '\n # enable source highlighting in less' >> ~/.bashrc
    echo 'export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"' >> ~/.bashrc
    echo "export LESS=' -cR '" >> ~/.bashrc
    source ~/.bashrc
fi

echo 'setting up system preferences'
gsettings set org.gnome.shell favorite-apps "['opera_opera.desktop', 'firefox_firefox.desktop, 'org.gnome.Terminal.desktop', 'org.gnome.Settings.desktop', 'code.desktop', 'org.gnome.Nautilus.desktop']"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true

cur_git_user=$(git config --global user.name)

if [ -z "$cur_git_user" ]; then
    echo 'Configuring github'
    read -p "Enter Github Username: " githubusername
    read -p "Enter Github Email: " githubemail
    git config --global user.name "$githubusername"
    git config --global user.email "$githubemail"
else
    echo "Github already configured with username ${cur_git_user}, skipping"
fi


echo 'cleaning up'
sudo apt -y autoremove

echo "thank you for using Xander's update CompSci script!" 