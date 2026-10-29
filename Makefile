OS_FAMILY := $(shell uname -s)

mac:
	mise bootstrap --only packages,files,tools,macos-defaults --yes

nvim-install:
	ansible-playbook nvim.yml -vv -i inventory -e curdir=$(pwd)

tmux-configure:
	ansible-playbook tmux.yml -vv -i inventory

kitty-configure:
	ansible-playbook kitty.yml -vv -i inventory

dotfiles:
	ansible-playbook -i inventory -vv dotfiles.yml

theme:
	ansible-playbook -i inventory -vv theme.yml


common:
	ansible-playbook -i inventory -vv common.yml

homebrew:
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | sudo -u $$USER bash
	echo 'eval "$$(/opt/homebrew/bin/brew shellenv)"' >> /Users/`whoami`/.zprofile
	eval "$$(/opt/homebrew/bin/brew shellenv)"

x-code:
	xcode-select --install || true

mac-install: x-code homebrew
	brew install ansible mise
	$(MAKE) dotfiles
	$(MAKE) mac
	$(MAKE) nvim-install
