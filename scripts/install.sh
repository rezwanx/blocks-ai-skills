#!/usr/bin/env bash
# Install or update Blocks AI Skills into a project's .claude/skills/ directory
# Usage:
#   bash /path/to/blocks-ai-skills/scripts/install.sh [target-dir]
#   bash /path/to/blocks-ai-skills/scripts/install.sh --update [target-dir]
#   bash /path/to/blocks-ai-skills/scripts/install.sh --check [target-dir]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
VERSION="1.0.3"
VERSION_FILE=".blocks-skills-version"

# Parse flags
MODE="install"
if [[ "${1:-}" == "--update" ]]; then
  MODE="update"
  shift
elif [[ "${1:-}" == "--check" ]]; then
  MODE="check"
  shift
fi

TARGET_DIR="${1:-.}"

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
SKILLS_TARGET="$TARGET_DIR/.claude/skills"

DOMAINS=(identity-access communication data-management localization ai-services lmt)

# Check mode — just report version status
if [[ "$MODE" == "check" ]]; then
  if [[ -f "$SKILLS_TARGET/$VERSION_FILE" ]]; then
    INSTALLED=$(cat "$SKILLS_TARGET/$VERSION_FILE")
    echo "Installed: v$INSTALLED"
    echo "Available: v$VERSION"
    if [[ "$INSTALLED" == "$VERSION" ]]; then
      echo "Up to date."
    else
      echo "Update available. Run: bash $SCRIPT_DIR/install.sh --update $TARGET_DIR"
    fi
  else
    echo "Not installed. Run: bash $SCRIPT_DIR/install.sh $TARGET_DIR"
  fi
  exit 0
fi

# Update mode — check if already installed, compare versions
if [[ "$MODE" == "update" ]]; then
  if [[ ! -d "$SKILLS_TARGET" ]]; then
    echo "Skills not installed yet. Running fresh install..."
    MODE="install"
  elif [[ -f "$SKILLS_TARGET/$VERSION_FILE" ]]; then
    INSTALLED=$(cat "$SKILLS_TARGET/$VERSION_FILE")
    if [[ "$INSTALLED" == "$VERSION" ]]; then
      echo "Already at v$VERSION. Nothing to update."
      exit 0
    fi
    echo "Updating from v$INSTALLED to v$VERSION..."
  else
    echo "Updating skills (no version file found)..."
  fi
fi

if [[ "$MODE" == "install" ]]; then
  echo "Installing Blocks AI Skills v$VERSION..."
else
  echo "Updating Blocks AI Skills to v$VERSION..."
fi
echo "  Source: $REPO_DIR/skills"
echo "  Target: $SKILLS_TARGET"
echo ""

# Create .claude/skills/ if needed
mkdir -p "$SKILLS_TARGET"

# Copy domain skill folders
for domain in "${DOMAINS[@]}"; do
  if [[ -d "$REPO_DIR/skills/$domain" ]]; then
    echo "  Copying $domain..."
    rm -rf "${SKILLS_TARGET:?}/$domain"
    cp -r "$REPO_DIR/skills/$domain" "$SKILLS_TARGET/$domain"
  else
    echo "  Skipping $domain (not found in source)"
  fi
done

# Copy core (routing, conventions, runtime)
if [[ -d "$REPO_DIR/skills/core" ]]; then
  echo "  Copying core..."
  rm -rf "${SKILLS_TARGET:?}/core"
  cp -r "$REPO_DIR/skills/core" "$SKILLS_TARGET/core"
fi

# Copy template if present
if [[ -d "$REPO_DIR/skills/_template" ]]; then
  echo "  Copying _template..."
  rm -rf "${SKILLS_TARGET:?}/_template"
  cp -r "$REPO_DIR/skills/_template" "$SKILLS_TARGET/_template"
fi

# Write version file
echo "$VERSION" > "$SKILLS_TARGET/$VERSION_FILE"

# Copy CLAUDE.md — on install only, never overwrite
if [[ "$MODE" == "install" ]]; then
  if [[ ! -f "$TARGET_DIR/CLAUDE.md" ]]; then
    echo "  Copying CLAUDE.md..."
    cp "$REPO_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
  else
    echo "  CLAUDE.md already exists — skipping (review manually if needed)"
  fi
fi

# Copy .env.example if no .env exists
if [[ ! -f "$TARGET_DIR/.env" && -f "$REPO_DIR/.env.example" ]]; then
  echo "  Copying .env.example..."
  cp "$REPO_DIR/.env.example" "$TARGET_DIR/.env.example"
fi

# Add .claude/ to .gitignore if not already there
if [[ -f "$TARGET_DIR/.gitignore" ]]; then
  if ! grep -q "^\.claude/" "$TARGET_DIR/.gitignore" 2>/dev/null; then
    echo "" >> "$TARGET_DIR/.gitignore"
    echo "# Claude Code skills (installed from blocks-ai-skills)" >> "$TARGET_DIR/.gitignore"
    echo ".claude/" >> "$TARGET_DIR/.gitignore"
    echo "  Added .claude/ to .gitignore"
  fi
fi

echo ""
echo "Done! Blocks AI Skills v$VERSION installed to $SKILLS_TARGET"
echo ""
if [[ "$MODE" == "install" ]]; then
  echo "Next steps:"
  echo "  1. Copy .env.example to .env and fill in your Cloud Portal credentials"
  echo "  2. Run 'claude' to start a session"
  echo "  3. Claude will auto-discover all installed skills"
else
  echo "Skills updated. Restart your Claude Code session to pick up changes."
fi
