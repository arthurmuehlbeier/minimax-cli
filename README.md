# minimax-cli

Web search and image analysis via MiniMax API. A skill for Claude Code, OpenCode, Pi, and other AI coding agents.

## Install

### Claude Code
```bash
git clone https://github.com/arthurmuehlbeier/minimax-cli.git
cp -r minimax-cli/skills/minimax ~/.claude/skills/minimax
```

### OpenCode
```bash
mkdir -p ~/.opencode/skills
curl -o ~/.opencode/skills/minimax.md \
  https://raw.githubusercontent.com/arthurmuehlbeier/minimax-cli/main/skills/minimax/SKILL.md
```

### Pi
```bash
pi install git:github.com/arthurmuehlbeier/minimax-cli
```

## Configure

Create a `.env` file in your project root or home directory:

```bash
MINIMAX_API_KEY=your_api_key_here
```

**Where to put it:**
- **Skill directory**: `.env` next to the skill (e.g., `~/.claude/skills/minimax/.env`)
- **Home-directory**: `~/.minimax-cli.env` or `~/.config/minimax-cli/.env`

The script checks all these locations automatically. Alternatively, export it:

```bash
# .bashrc, .zshrc, or .profile
export MINIMAX_API_KEY=your_api_key_here
```

**Get an API key at https://platform.minimax.io**

## Use

**Search the web:**
```bash
~/.claude/skills/minimax/scripts/minimax.sh search "Node.js 2025"
```

**Analyze images:**
```bash
~/.claude/skills/minimax/scripts/minimax.sh image "Describe this" "https://example.com/photo.jpg"
~/.claude/skills/minimax/scripts/minimax.sh image "What objects?" "/path/to/screenshot.png"
```

## Requirements

- `curl`, `jq`, `base64` (usually pre-installed)

## Structure

```
minimax-cli/
├── package.json              # pi distribution metadata
├── README.md
└── skills/minimax/
    ├── SKILL.md              # Skill definition
    ├── scripts/minimax.sh    # Standalone bash CLI
    └── references/api.md     # API docs
```

## License

MIT
