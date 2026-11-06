# Dotfiles

macOS only. Brew packages and interpreters are managed by [mise](https://mise.jdx.dev/bootstrap.html) (`mise.toml`), which also holds symlinks, git clones and the login shell.

### Setup

```sh
make mac-install
```

### Agent skills

`.claude/skills/` holds the skills (from `mattpocock/skills`, `vercel-labs/skills`) and `skills-lock.json` pins them by content hash. They are the source of truth; the working copies are installed by hand, globally, from this folder:

```sh
npx skills add ~/dotfiles/.claude/skills -l                      # list only, installs nothing
npx skills add ~/dotfiles/.claude/skills -g -a claude-code -y -s tdd grilling   # install only the named skills
npx skills add ~/dotfiles/.claude/skills -g -a claude-code -y -s '*'            # install everything (all skills in the folder)
```

They land in `~/.agents/skills` (symlinked from `~/.claude/skills`). The global lock `~/.agents/.skill-lock.json` records this local path as the source, so `skills update -g` does not fetch upstream.

Update flow: change the folder and lock here (`npx skills add <package> -a claude-code -y -s <name>` or `npx skills update -p`), review the `SKILL.md` diff (the hash says nothing about behaviour), commit, then reinstall globally with the command above. Do not use `skills experimental_install`: it restores from GitHub into the project's `.agents/skills` and ignores `-g`.

Methodology skills (grilling, tdd, diagnosing-bugs, research...) suit global install; skills that write repo artifacts (`pr`, `to-spec`, `triage`...) should follow each repo's own formats. In foreign repos never commit skills; use `.git/info/exclude`.
