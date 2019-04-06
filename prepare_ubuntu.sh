sudo apt-get install -y libfontconfig sudo
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

sudo locale-gen en_US.UTF-8

sudo bash -c "cat >> ~/.bashrc" << EOM

if [ -n "$SSH_AUTH_SOCK" ]; then
    if [ "$SSH_AUTH_SOCK" != "$HOME/.ssh_auth_sock" ]; then
        ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh_auth_sock"
        export SSH_AUTH_SOCK="$HOME/.ssh_auth_sock"
    fi
fi

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=C
export LANGUAGE=en_US:en

\$TERMINFO=~/.local/kitty.app/share/terminfo/x/xterm-kitty bash -i
EOM
