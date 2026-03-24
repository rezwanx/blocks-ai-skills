#!/usr/bin/env bash
# Validates that all skill domains follow the expected structure
set -euo pipefail

SKILLS_DIR="skills"
ERRORS=0

echo "Validating skill structure..."
echo ""

for domain_dir in "$SKILLS_DIR"/*/; do
  domain=$(basename "$domain_dir")

  # Skip _template and core
  if [[ "$domain" == "_template" || "$domain" == "core" ]]; then
    continue
  fi

  echo "Checking $domain..."

  # Check SKILL.md exists
  if [[ ! -f "$domain_dir/SKILL.md" ]]; then
    echo "  ❌ Missing SKILL.md"
    ERRORS=$((ERRORS + 1))
  else
    # Check frontmatter
    if ! head -1 "$domain_dir/SKILL.md" | grep -q "^---"; then
      echo "  ❌ SKILL.md missing YAML frontmatter"
      ERRORS=$((ERRORS + 1))
    else
      echo "  ✅ SKILL.md with frontmatter"
    fi
  fi

  # Check contracts.md
  if [[ ! -f "$domain_dir/contracts.md" ]]; then
    echo "  ❌ Missing contracts.md"
    ERRORS=$((ERRORS + 1))
  else
    echo "  ✅ contracts.md"
  fi

  # Check frontend.md
  if [[ ! -f "$domain_dir/frontend.md" ]]; then
    echo "  ❌ Missing frontend.md"
    ERRORS=$((ERRORS + 1))
  else
    echo "  ✅ frontend.md"
  fi

  # Check flows/ directory
  if [[ ! -d "$domain_dir/flows" ]]; then
    echo "  ❌ Missing flows/ directory"
    ERRORS=$((ERRORS + 1))
  else
    flow_count=$(find "$domain_dir/flows" -name "*.md" | wc -l | tr -d ' ')
    echo "  ✅ flows/ ($flow_count flows)"
  fi

  # Check actions/ directory
  if [[ ! -d "$domain_dir/actions" ]]; then
    echo "  ❌ Missing actions/ directory"
    ERRORS=$((ERRORS + 1))
  else
    action_count=$(find "$domain_dir/actions" -name "*.md" | wc -l | tr -d ' ')
    echo "  ✅ actions/ ($action_count actions)"
  fi

  # Check for old skill.md (should be SKILL.md)
  # Use git ls-files for case-sensitive check (macOS filesystem is case-insensitive)
  if git ls-files --error-unmatch "$domain_dir/skill.md" &>/dev/null; then
    echo "  ⚠️  Found lowercase skill.md in git — should be SKILL.md"
    ERRORS=$((ERRORS + 1))
  fi

  echo ""
done

if [[ $ERRORS -gt 0 ]]; then
  echo "Found $ERRORS issue(s). Please fix before committing."
  exit 1
else
  echo "All skill domains are valid! ✅"
  exit 0
fi
