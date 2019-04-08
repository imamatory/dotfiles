ANSIBLE_PREFIX := docker run --rm -e "HOST_USER=$(USER)" -v $(HOME):/host/home -v $(CURDIR):/dotfiles -w /dotfiles williamyeh/ansible:ubuntu18.04 ansible-playbook -i local -vv

run-playbook:
	ansible-playbook main.yml -i local -vvv -K

vim-configure:
	ansible-playbook vim.yml -vv -i local -e curdir=$(pwd) -K
	nvim +PlugInstall +q +q

zsh-configure:
	ansible-playbook zsh.yml -vv -i local -e curdir=$(pwd) -K

tmux-configure:
	ansible-playbook tmux.yml -vv -i local

kitty-configure:
	ansible-playbook kitty.yml -vv -i local

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

ubuntu-install:
	$(ANSIBLE_PREFIX) -K ubuntu.yml
