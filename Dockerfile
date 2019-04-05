FROM ubuntu:18.10

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends locales ca-certificates \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
ENV HOME=/home
ENV TERM=xterm-kitty

WORKDIR /home

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y locales && locale-gen en_US.UTF-8 \
    && apt-get install -y --no-install-recommends \
      git curl wget make cmake sudo inotify-tools openssl openssh-client cargo

RUN curl -fsSL get.docker.com | sh

RUN cargo install exa

RUN apt-get install -y --no-install-recommends  \
      ripgrep \
      tig \
      ruby ruby-dev \
      nodejs \
      neovim \
      docker-compose \
      tmux \
      zsh \
      jq \
      xclip \
      kitty

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
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

COPY files/vimrc /home/.config/nvim/init.vim
COPY files/tmux.conf /home/.tmux.conf
COPY files/zshrc_common /home/.zshrc

RUN nvim -i NONE -c PlugInstall -c quitall

ARG GIT_USER
ARG GIT_EMAIL

RUN git config --global user.name $GIT_USER
RUN git config --global user.email $GIT_EMAIL

# ENV PATH="/usr/local/bin:${PATH}"
ENV VERSION 31032019

CMD ["zsh"]
