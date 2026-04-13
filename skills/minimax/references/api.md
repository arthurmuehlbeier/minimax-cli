# MiniMax API Reference

## Endpoints

### Search (`POST /v1/coding_plan/search`)

Search for real-time or current information.

**Request:**
```json
{
  "q": "search query"
}
```

**Response:**
```json
{
  "organic": [
    {
      "title": "Result Title",
      "link": "https://example.com",
      "snippet": "Brief description...",
      "date": "2025-01-15"
    }
  ],
  "related_searches": ["query1", "query2"]
}
```

---

### Image Analysis (`POST /v1/coding_plan/vlm`)

Analyze images from URLs or local files (converts to base64 data URL).

**Request:**
```json
{
  "prompt": "your question",
  "image_url": "data:image/...;base64,..."
}
```

**Response:**
```json
{
  "content": "analysis text"
}
```

**Supported formats:** JPEG, PNG, WebP

---

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MINIMAX_API_KEY` | Yes | — | API key from MiniMax dashboard |
| `MINIMAX_API_HOST` | No | `https://api.minimax.io` | API endpoint base URL |

---

## Getting an API Key

1. Sign up at https://platform.minimax.io
2. Navigate to API Keys section
3. Create a new API key
4. Export it: `export MINIMAX_API_KEY=your_key_here`

**Security:** Never commit API keys to git. Use `.env` files (add to `.gitignore`).

---

## Rate Limits

Check the MiniMax dashboard for current rate limits.

---

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| `MINIMAX_API_KEY environment variable is not set` | No API key configured | Set the environment variable |
| `File not found: /path/to/file` | Invalid file path | Verify the file exists |
| `Failed to fetch image` | Invalid or inaccessible URL | Verify URL is accessible |
| `API request failed: 4xx/5xx` | Request rejected by server | Check API key and quotas |

---

## CLI Usage

```bash
# Search
scripts/minimax.sh search "latest news"

# Image analysis
scripts/minimax.sh image "Describe this" "https://example.com/img.jpg"
scripts/minimax.sh image "Extract text" "/path/to/screenshot.png"
```

Exit code: `0` on success, `1` on error.