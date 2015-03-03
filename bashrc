# .bashrc
#set -o vi
if [ -e "$HOME/Sync/home/scripts/vm.sh" ]; then
    source $HOME/Sync/home/scripts/vm.sh
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# source completion
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# prompt
export PS1="\[$(tput setaf 7)\]\u \[$(tput setaf 2)\]\W\[$(tput setaf 7)\]>\[$(tput sgr0)\] "

if [ ! -z "$ITERM_PROFILE" ]; then
    export CLICOLOR=1
    if [ -f $(brew --prefix)/etc/bash_completion  ]; then
        source $(brew --prefix)/etc/bash_completion
    fi
else
    # set keyboard repeat rate
    if [ ! -z "$DISPLAY" ]; then
        xset r rate 200 40
        xrandr --dpi 150
    fi

    eval "`dircolors -b`"
    alias ls="ls --color=auto"
fi

export EDITOR=vim
export GOROOT=/usr/local/go
export GOPATH=~/dev/gocode
export PATH=~/bin:$PATH:~/dev/gocode/bin:/usr/local/go/bin

if [ -e "$HOME/.nvm" ]; then
    source $HOME/.nvm/nvm.sh
fi

function set_wifi() {
    if [ -z "$1" ]; then
        echo "Usage: $0 <name>"
        return
    fi

    sudo pkill wpa_supplicant
    sudo pkill dhclient
    sudo wpa_supplicant -B -iwlan0 -c ~/.wpa-$1.conf
    sudo dhclient wlan0
}

function switch_graphics() {
    echo "Activating..."
    updated="0"
    if [ "$1" = "nvidia" ]; then
        sudo mv /etc/modprobe.d/nvidia.disabled /etc/modprobe.d/nvidia.conf > /dev/null 2>&1
        sudo ln -sf /etc/X11/xorg.conf.nvidia /etc/X11/xorg.conf
        updated="1"
    fi

    if [ "$1" = "nouveau" ]; then
        sudo mv /etc/modprobe.d/nvidia.conf /etc/modprobe.d/nvidia.disabled > /dev/null 2>&1
        sudo ln -sf /etc/X11/xorg.conf.nouveau /etc/X11/xorg.conf
        updated="1"
    fi

    if [ $updated = "1" ]; then
        sudo update-initramfs -u > /dev/null
        echo "Updated.  Please reboot."
    fi
}

function randomstr() {
    LEN=${1:-32}
    echo `date +%s | sha256sum | base64 | head -c $LEN; echo`
}

if [ -e $HOME/google-cloud-sdk ]; then
    # The next line updates PATH for the Google Cloud SDK.
    source "$HOME/google-cloud-sdk/path.bash.inc"
    
    # The next line enables bash completion for gcloud.
    source "$HOME/google-cloud-sdk/completion.bash.inc"
fi

function rainbowstream() {
    docker run -ti --rm \
        -v $HOME/Sync/home/config/rainbowstream/.rainbow_oauth:/root/.rainbow_oauth \
        -v $HOME/Sync/home/config/rainbowstream/.rainbow_config.json:/root/.rainbow_config.json \
        --name rainbowstream \
        jess/rainbowstream
}
