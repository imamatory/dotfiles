FROM alpine:3.9.2

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk update && apk upgrade

RUN apk add --no-cache build-base git curl wget bash cmake sudo jq
RUN apk add --no-cache libxml2-dev libxslt-dev libgcrypt-dev
RUN apk add --no-cache libffi openssl-dev libffi-dev cargo

RUN cargo install exa

RUN apk add --no-cache python3 py-pip python2-dev python3-dev
RUN apk add --no-cache ruby ruby-dev ruby-bundler ruby-json ruby-irb ruby-rake ruby-bigdecimal
RUN apk add --no-cache inotify-tools elixir erlang erlang-inets erlang-ssl
RUN apk add --no-cache openjdk8-jre nodejs nodejs-npm
RUN apk add --no-cache neovim
RUN apk add --no-cache docker tmux zsh

RUN npm config set unsafe-perm true

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
      && ~/.fzf/install --key-bindings --update-rc --completion \
      && cp /root/.fzf/bin/fzf /usr/local/bin

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN curl -sL git.io/antibody | sh -s

RUN apk add --no-cache

COPY files/vimrc /root/.config/nvim/init.vim
COPY files/tmux.conf /root/tmux.conf
COPY files/zshrc /root/.zshrc

RUN nvim -i NONE -c PlugInstall -c quitall

ENV PATH="/usr/local/bin:${PATH}"
ENV VERSION 31032019

CMD ["zsh"]
