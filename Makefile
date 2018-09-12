run-playbook:
	ansible-playbook main.yml -i local -vvv -K

vim-configure:
	ansible-playbook vim.yml -vv -i local -e curdir=$(pwd) -K
	$(brew --prefix)/opt/fzf/install
	nvim +PlugInstall +q +q

tmux-configure:
	ansible-playbook tmux.yml -vv -i local

kitty-configure:
	ansible-playbook kitty.yml -vv -i local

install: run-playbook
