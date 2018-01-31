run-playbook:
	ansible-playbook main.yml -i local -vv -K

configure-vim:
	ansible-playbook vim.yml -vv -i local -e curdir=$(pwd)

install: run-playbook

