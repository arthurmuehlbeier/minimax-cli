#!/usr/bin/env bash
# MiniMax API CLI - Web search and image analysis
# Usage:
#   minimax.sh search "<query>"
#   minimax.sh image "<prompt>" "<source>"

set -euo pipefail

API_KEY="${MINIMAX_API_KEY:-}"
API_HOST="${MINIMAX_API_HOST:-https://api.minimax.io}"

# Color output
RED='\033[0;31m'
NC='\033[0m'

die() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Validate API key
[[ -n "$API_KEY" ]] || die "MINIMAX_API_KEY environment variable is not set"

ACTION="${1:-}"
[[ -n "$ACTION" ]] || die "Usage: minimax.sh <command> [args]"

case "$ACTION" in
    search)
        QUERY="${2:-}"
        [[ -n "$QUERY" ]] || die "Usage: minimax.sh search \"<query>\""

        RESPONSE=$(
            curl -s -X POST \
                "${API_HOST}/v1/coding_plan/search" \
                -H "Authorization: Bearer ${API_KEY}" \
                -H "Content-Type: application/json" \
                -H "MM-API-Source: minimax-cli" \
                -d "$(jq -n --arg q "$QUERY" '{q: $q}')"
        )

        echo "$RESPONSE" | jq .
        ;;

    image)
        PROMPT="${2:-}"
        IMAGE_SOURCE="${3:-}"

        [[ -n "$PROMPT" ]] || die "Usage: minimax.sh image \"<prompt>\" \"<source>\""
        [[ -n "$IMAGE_SOURCE" ]] || die "Usage: minimax.sh image \"<prompt>\" \"<source>\""

        # Remove leading @ if present
        IMAGE_SOURCE="${IMAGE_SOURCE#@}"

        # Convert image to base64 data URL
        case "$IMAGE_SOURCE" in
            data:*)
                IMAGE_URL="$IMAGE_SOURCE"
                ;;
            http://*|https://*)
                CONTENT_TYPE=$(curl -sI "$IMAGE_SOURCE" | grep -i content-type | awk '{print $2}' | tr -d '\r')
                FORMAT="jpeg"
                [[ "$CONTENT_TYPE" == *"png"* ]] && FORMAT="png"
                [[ "$CONTENT_TYPE" == *"webp"* ]] && FORMAT="webp"

                IMAGE_DATA=$(curl -s "$IMAGE_SOURCE" | base64 -w 0)
                IMAGE_URL="data:image/${FORMAT};base64,${IMAGE_DATA}"
                ;;
            *)
                [[ -f "$IMAGE_SOURCE" ]] || die "File not found: $IMAGE_SOURCE"

                FORMAT="jpeg"
                [[ "$IMAGE_SOURCE" == *.png ]] && FORMAT="png"
                [[ "$IMAGE_SOURCE" == *.webp ]] && FORMAT="webp"

                IMAGE_DATA=$(base64 -w 0 "$IMAGE_SOURCE")
                IMAGE_URL="data:image/${FORMAT};base64,${IMAGE_DATA}"
                ;;
        esac

        RESPONSE=$(
            curl -s -X POST \
                "${API_HOST}/v1/coding_plan/vlm" \
                -H "Authorization: Bearer ${API_KEY}" \
                -H "Content-Type: application/json" \
                -H "MM-API-Source: minimax-cli" \
                -d "$(jq -n --arg p "$PROMPT" --arg u "$IMAGE_URL" '{prompt: $p, image_url: $u}')"
        )

        # Extract content if available, otherwise show full JSON
        CONTENT=$(echo "$RESPONSE" | jq -r '.content // empty')
        if [[ -n "$CONTENT" ]]; then
            echo "$CONTENT"
        else
            echo "$RESPONSE" | jq .
        fi
        ;;

    -h|--help|help)
        echo "Usage: minimax.sh <command> [arguments]"
        echo ""
        echo "Commands:"
        echo "  search <query>           Search the web"
        echo "  image <prompt> <source>  Analyze an image"
        echo ""
        echo "Examples:"
        echo "  minimax.sh search \"Node.js 2025\""
        echo "  minimax.sh image \"Describe\" \"https://example.com/img.jpg\""
        echo "  minimax.sh image \"What\" \"/path/to/image.png\""
        exit 0
        ;;

    *)
        die "Unknown command: $ACTION"
        ;;
esac
