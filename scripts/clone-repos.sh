#!/bin/bash
# Clone all Code repos to mirror the directory structure
# Run this on a new machine after setting up SSH keys

set -e

CODE_DIR="$HOME/Code"

# Create directory structure
mkdir -p "$CODE_DIR"/{learning,lms-dev,mcps,notebooks,orion,tools,utils}

# Function to clone if not exists
clone_repo() {
  local dir="$1"
  local url="$2"
  if [ -d "$CODE_DIR/$dir" ]; then
    echo "Skipping $dir (already exists)"
  else
    echo "Cloning $dir..."
    git clone "$url" "$CODE_DIR/$dir"
  fi
}

# Learning
clone_repo "learning/learn-react" "git@github.com:UXCXNZ/learn-react.git"

# LMS Dev
clone_repo "lms-dev/orion-lms" "git@github.com:UXCXNZ/orion-lms.git"
clone_repo "lms-dev/leadership-assessment" "git@github.com:UXCXNZ/Leadership-Assessment.git"
clone_repo "lms-dev/orion-blog" "git@github.com:UXCXNZ/orion-blog.git"

# MCPs
clone_repo "mcps/py-mcp-youtube-toolbox" "git@github.com:jikime/py-mcp-youtube-toolbox.git"
clone_repo "mcps/figma-mcp" "git@github.com:JayZeeDesign/figma-mcp.git"

# Notebooks
clone_repo "notebooks/obsidian-tasks-vault" "git@github.com:UXCXNZ/obsidian-tasks-vault.git"
clone_repo "notebooks/obsidian-git-sync" "git@github.com:UXCXNZ/obsidian-git-sync.git"

# Orion (your repos)
clone_repo "orion/orion-microsites" "git@github.com:UXCXNZ/orion-microsites.git"
clone_repo "orion/leadership-launchpad-vercel" "git@github.com:UXCXNZ/leadership-launchpad-vercel.git"
clone_repo "orion/orion-leadership-os" "git@github.com:UXCXNZ/orion-leadership-os.git"
clone_repo "orion/workshop-catalog" "git@github.com:UXCXNZ/workshop-catalog.git"
clone_repo "orion/orion-roa" "git@github.com:UXCXNZ/orion-roa.git"
clone_repo "orion/orion-future-of-work" "git@github.com:UXCXNZ/orion-future-of-work.git"
clone_repo "orion/leadlabs" "git@github.com:UXCXNZ/leadlabs.git"
clone_repo "orion/orion-led" "git@github.com:UXCXNZ/orion-led.git"

# Tools (third-party)
clone_repo "tools/chrome-devtools-mcp" "https://github.com/benjaminr/chrome-devtools-mcp.git"
clone_repo "tools/gpt-crawler" "git@github.com:BuilderIO/gpt-crawler.git"

# Utils (third-party)
clone_repo "utils/agent-browser" "https://github.com/vercel-labs/agent-browser.git"
clone_repo "utils/LibreChat" "https://github.com/danny-avila/LibreChat.git"
clone_repo "utils/meilisearch" "git@github.com:meilisearch/meilisearch.git"
clone_repo "utils/prisma-to-drizzle" "https://github.com/typytypytypy/prisma-to-drizzle.git"

echo ""
echo "Done! Cloned repos to $CODE_DIR"
echo ""
echo "Note: The following repos have no remote and weren't cloned:"
echo "  - tools/claude-code"
echo "  - tools/remotion-videos"
echo "  - orion/orion-the-coaching-playbook"
echo "  - orion/orion-cursor-rules"
echo "  - orion/orion-requirements-by-feature"
echo "  - orion/orion-agents-node"
echo "  - orion/orion-feedback-app-convex"
echo "  - orion/orion-pdf-generator"
echo "  - utils/composio"
