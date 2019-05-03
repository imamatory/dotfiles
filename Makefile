ANSIBLE_PREFIX := docker run --rm \
  -e HOST_USER=$(USER) \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -v $(SSH_AUTH_SOCK):/ssh-agent \
  -v $(HOME):/host/home \
  -v $(CURDIR):/dotfiles \
  -w /dotfiles \
  williamyeh/ansible:ubuntu18.04 \
  ansible-playbook -i inventory -vv

run-playbook:
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

install: run-playbook

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

ubuntu-install:
	ansible-playbook -i inventory -vv ubuntu.yml
