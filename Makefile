ANSIBLE_PREFIX := docker run --rm \
  -e HOST_USER=$(USER) \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -v $(SSH_AUTH_SOCK):/ssh-agent \
  -v $(HOME):/host/home \
  -v $(CURDIR):/dotfiles \
  -w /dotfiles \
  williamyeh/ansible:ubuntu18.04 \
  ansible-playbook -i inventory -vv

prepare-setup:
	sudo pacman -S --needed ansible


install:
	ansible-playbook main.yml -i inventory -vvv -K

# ansible:
# 	docker run --rm -it \
# 	-e HOST_USER=$(USER) \
# 	-e SSH_AUTH_SOCK=/ssh-agent \
# 	-v $(SSH_AUTH_SOCK):/ssh-agent \
# 	-v $(HOME):/host/home \
# 	-v $(CURDIR):/dotfiles \
# 	-w /dotfiles \
# 	williamyeh/ansible:ubuntu18.04 bash

editors:
	ansible-playbook editors.yml -vv -i inventory -e curdir=$(pwd) -K

zsh-configure:
	ansible-playbook zsh.yml -vv -i inventory -e curdir=$(pwd) -K

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

ubuntu:
	ansible-playbook -i inventory -vv ubuntu.yml -K

arch-packages:
	ansible-playbook -i inventory -vvv arch.yml -K

setup-arch: prepare-setup arch-packages asdf
	ansible-playbook -i inventory -vvv setup-arch.yml

asdf:
	yay -S --needed asdf-vm
	sh -c "source /opt/asdf-vm/asdf.sh"
	asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
	asdf plugin-add ruby || true
	asdf plugin-add golang || true
	asdf plugin-add python || true
	asdf plugin-add java || true
	asdf install nodejs latest
	asdf global nodejs latest

common:
	ansible-playbook -i inventory -vvv common.yml -K
