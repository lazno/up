# up

Jump to ancestor directories by name, without repeated `cd ..`.

Example:

`/home/user/dev/repos/mycoolrepo` + `up dev` => `/home/user/dev`

## Features

- Ancestor-only navigation (no global directory index).
- Case-insensitive fuzzy matching:
  - exact, prefix, substring, and subsequence (`dv` -> `dev`)
- Optional interactive disambiguation with `fzf`.
- Shell completion and integration via `up completion zsh|bash`.

## Install

### 1. Put `up` on your `PATH`

From this repository:

```bash
chmod +x bin/up
mkdir -p ~/.local/bin
ln -sf "$PWD/bin/up" ~/.local/bin/up
```

Or install directly:

```bash
make install
```

Ensure `~/.local/bin` is in your `PATH` (for zsh, add to `~/.zshrc`):

```zsh
export PATH="$HOME/.local/bin:$PATH"
```

### 2. Enable shell integration (required for direct `cd`)

zsh (`~/.zshrc`):

```zsh
eval "$(up completion zsh)"
```

bash (`~/.bashrc`):

```bash
eval "$(up completion bash)"
```

Reload your shell (`source ~/.zshrc` or `source ~/.bashrc`).

## Usage

After shell integration:

```bash
up dev        # cd to matching ancestor
up            # cd to parent
up dv         # fuzzy match (subsequence)
```

Without shell integration, `up` only prints a path:

```bash
cd "$(up dev)"
```

This is normal: a child process cannot change its parent shell's directory.

## Ambiguous Matches

When multiple ancestors match:

- If interactive and `fzf` is installed: selection UI opens.
- Otherwise: candidates are printed and `up` exits `3`.

If no ancestor matches, `up` exits `2`.

## Exit Codes

- `0`: success
- `1`: usage / unsupported command
- `2`: no matches
- `3`: multiple matches without selection
- `130`: interactive selection canceled

## Development

Run tests:

```bash
tests/up_test.sh
```

Or:

```bash
make test
```

## License

MIT. See `LICENSE`.
