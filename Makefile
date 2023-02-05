ANSIBLE_PREFIX := docker run --rm \
  -e HOST_USER=$(USER) \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -v $(SSH_AUTH_SOCK):/ssh-agent \
  -v $(HOME):/host/home \
  -v $(CURDIR):/dotfiles \
  -w /dotfiles \
  williamyeh/ansible:ubuntu18.04 \
  ansible-playbook -i inventory -vv

OS_FAMILY := $(shell uname -s)

prepare-setup:
	sudo pacman -S --needed ansible


mac-install: mac dotfiles nvim-install

mac:
	ansible-playbook mac.yml -i inventory -vvv -K

# ansible:
# 	docker run --rm -it \
# 	-e HOST_USER=$(USER) \
# 	-e SSH_AUTH_SOCK=/ssh-agent \
# 	-v $(SSH_AUTH_SOCK):/ssh-agent \
# 	-v $(HOME):/host/home \
# 	-v $(CURDIR):/dotfiles \
# 	-w /dotfiles \
# 	williamyeh/ansible:ubuntu18.04 bash

nvim-install:
	ansible-playbook nvim.yml -vv -i inventory -e curdir=$(pwd)

tmux-configure:
	ansible-playbook tmux.yml -vv -i inventory

kitty-configure:
	ansible-playbook kitty.yml -vv -i inventory

docker-build:
	docker build . -t imamatory/dotfiles \
	  --build-arg GIT_USER="Vadim Safonov" \
	  --build-arg GIT_EMAIL="imamatory@gmail.com"

docker-push:
	docker push imamatory/dotfiles

docker-bash:
	docker run -it imamatory/dotfiles

myzsh-install:
	$(ANSIBLE_PREFIX) myzsh.yml

dotfiles:
	ansible-playbook -i inventory -vv dotfiles.yml

theme:
	ansible-playbook -i inventory -vv theme.yml

ubuntu:
	ansible-playbook -i inventory -vv ubuntu.yml -K

arch-packages:
	ansible-playbook -i inventory -vvv arch.yml -K

setup-arch: prepare-setup gnome-settings arch-packages asdf
	ansible-playbook -i inventory -vvv setup-arch.yml

asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1 || true
	. $(HOME)/.asdf/asdf.sh
	asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
	asdf plugin-add ruby || true
	asdf plugin-add golang || true
	asdf plugin-add python || true
	asdf plugin-add java || true
	asdf install nodejs latest
	asdf global nodejs latest

gnome-settings:
	gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 14
	gsettings set org.gnome.desktop.peripherals.keyboard delay 190

mac-settings:
	defaults write -g InitialKeyRepeat -int 11 # normal minimum is 15 (225 ms)
	defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false  # vscode enable key repeat on hold

common:
	ansible-playbook -i inventory -vv common.yml

homebrew:
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | sudo -u $$USER bash
	echo 'eval "$$(/opt/homebrew/bin/brew shellenv)"' >> /Users/`whoami`/.zprofile
	eval "$$(/opt/homebrew/bin/brew shellenv)"

x-code:
	xcode-select --install || true

mac-install: x-code homebrew
	brew install ansible
