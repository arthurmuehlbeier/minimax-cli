---
name: minimax
description: >-
  Web search and image analysis via MiniMax API. Use when user needs real-time information,
  current news, technical documentation lookup, fact-checking, or image understanding
  (describing, extracting text, analyzing screenshots). Triggers: "search the web", 
  "look up", "find current", "latest", "recent news", "what's new", "image analysis",
  "describe this image", "extract text from image", "analyze screenshot".
  Don't use for general coding tasks, file operations, or non-internet research.
keywords:
  - web search
  - online search
  - internet search
  - image analysis
  - image understanding
  - VLM
  - image to text
  - screenshot analysis
  - search the web
  - find current information
  - look up news
---

# MiniMax Search & Image Analysis

Use MiniMax API for web search and image analysis.

## Capabilities

1. **Web Search** — Real-time information, current news, technical docs, fact-checking
2. **Image Analysis** — Describe images, extract text, analyze screenshots (JPEG, PNG, WebP)

## Setup

**Required environment variables:**
- `MINIMAX_API_KEY` — API key from https://platform.minimax.io

```bash
export MINIMAX_API_KEY=your_api_key_here
```

## Usage

### Web Search

```bash
scripts/minimax.sh search "latest Node.js news"
```

**Tips for better results:**
- Use 3-5 keywords
- Include current year for time-sensitive topics
- Rephrase if no useful results

**Response format:**
```json
{
  "organic": [{ "title": "...", "link": "...", "snippet": "...", "date": "..." }],
  "related_searches": [...]
}
```

### Image Analysis

```bash
# From URL
scripts/minimax.sh image "Describe this image" "https://example.com/photo.jpg"

# From local file
scripts/minimax.sh image "What objects are shown?" "/path/to/screenshot.png"
```

**Supported formats:** JPEG, PNG, WebP

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| `MINIMAX_API_KEY environment variable is not set` | No API key | Set MINIMAX_API_KEY |
| `File not found` | Invalid path | Check file exists |
| `Failed to fetch image` | Invalid URL | Verify URL is accessible |

## API Reference

For detailed endpoint documentation, see `references/api.md`.