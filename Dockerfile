FROM ubuntu:18.10

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends locales ca-certificates \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
ENV HOME=/home
ENV TERM=xterm-256color

WORKDIR /home

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y locales && locale-gen en_US.UTF-8 \
    && apt-get install -y --no-install-recommends \
      git \
      curl wget \
      make cmake \
      sudo \
      inotify-tools \
      openssl openssh-client \
      cargo \
      xz-utils \
      libfontconfig \
      python

RUN curl -fsSL get.docker.com | sh

RUN cargo install exa

RUN apt-get install -y --no-install-recommends ripgrep
RUN apt-get install -y --no-install-recommends tig
RUN apt-get install -y --no-install-recommends ruby ruby-dev
RUN apt-get install -y --no-install-recommends nodejs
RUN apt-get install -y --no-install-recommends neovim
RUN apt-get install -y --no-install-recommends docker-compose
RUN apt-get install -y --no-install-recommends tmux
RUN apt-get install -y --no-install-recommends zsh
RUN apt-get install -y --no-install-recommends jq
RUN apt-get install -y --no-install-recommends xclip
RUN apt-get install -y --no-install-recommends kitty-terminfo


RUN curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
    && mkdir -p ~/.local/bin/ \
    && ln -s ~/.local/kitty.app/bin/kitty /usr/local/bin

RUN curl -sSL git.io/antibody | bash -s

ENV BAT_VERSION 0.10.0
ENV BAT_URL https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb
RUN curl -sSL ${BAT_URL} -o bat.deb; dpkg -i bat.deb; \
    rm -rf bat.deb;

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install --key-bindings --update-rc --completion \
    && cp ~/.fzf/bin/fzf /usr/local/bin

RUN curl -sSLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

COPY files/vimrc /home/.config/nvim/init.vim
COPY files/tmux.conf /home/.tmux.conf
COPY files/zshrc_common /home/.zshrc

RUN nvim -i NONE -c PlugInstall -c quitall

ARG GIT_USER
ARG GIT_EMAIL

RUN git config --global user.name $GIT_USER
RUN git config --global user.email $GIT_EMAIL
RUN git config --global credential.helper cache

# ENV PATH="/usr/local/bin:${PATH}"
ENV VERSION 07042019

CMD ["zsh"]
