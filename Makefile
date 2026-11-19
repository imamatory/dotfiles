mac: dotfiles
	mise bootstrap --only packages,files,tools,macos-defaults,repos,dotfiles,user,task --yes

# Links mise.toml as the global mise config (bootstrap packages/tools), then deploys [dotfiles].
dotfiles:
	mkdir -p ~/.config/mise
	ln -sfn $(CURDIR)/mise.toml ~/.config/mise/config.toml
	mise trust
	mise dot apply

# Installs the skills from .claude/skills globally (-> ~/.agents/skills, symlinked from ~/.claude/skills).
# Run `make skills` after changing the folder or skills-lock.json. Do not also enable the
# mattpocock-skills plugin: it duplicates these as `mattpocock-skills:*`.
skills:
	npx --yes skills add $(CURDIR)/.claude/skills -g -a claude-code -y -s '*'

homebrew:
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | sudo -u $$USER bash
	echo 'eval "$$(/opt/homebrew/bin/brew shellenv)"' >> /Users/`whoami`/.zprofile
	eval "$$(/opt/homebrew/bin/brew shellenv)"

x-code:
	xcode-select --install || true

mac-install: x-code homebrew
	brew install mise
	$(MAKE) mac
