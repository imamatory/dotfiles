run-playbook:
	ansible-playbook main.yml -i local -vv -K

configure-vim:
	ansible-playbook vim.yml -vvv -i local -e curdir=$(pwd) -K
	nvim +PlugInstall +q +q

install: run-playbook
