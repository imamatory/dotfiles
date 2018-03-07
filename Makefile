run-playbook:
	ansible-playbook main.yml -i local -vvv -K

configure-vim:
	ansible-playbook vim.yml -vvv -i local -e curdir=$(pwd) -K
	$(brew --prefix)/opt/fzf/install
	nvim +PlugInstall +q +q

install: run-playbook
