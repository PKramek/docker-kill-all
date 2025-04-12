#!/usr/bin/env bash

# Check if ~/.zshrc exists
if [ ! -f "$HOME/.zshrc" ]; then
  echo "Error: ~/.zshrc file not found. Please ensure Zsh is installed and configured."
  exit 1
fi

# Define the docker-kill-all function
function_content='
docker-kill-all() {
  zparseopts -D -E -- f=force s=soft h=help

  if [[ -n $help ]]; then
    echo "Usage: docker-kill-all [-f] [-s] [-h]"
    echo "  -f  Force kill without confirmation"
    echo "  -s  Use '"'"'docker stop'"'"' instead of '"'"'docker kill'"'"'"
    echo "  -h  Show this help message"
    return 0
  fi

  if ! docker info &>/dev/null; then
    echo "Error: Cannot connect to Docker daemon. Is Docker running?"
    return 1
  fi

  local container_data=$(docker ps --format "{{.ID}}|{{.Names}}")
  local containers=(${(f)container_data})

  if [[ -z $containers ]]; then
    echo "No running containers found."
    return 0
  fi

  echo "Found ${#containers} running containers:"
  for container in $containers; do
    local id=${container%%|*}
    local name=${container##*|}
    echo "  • $id \($name\)"
  done

  if [[ -z $force ]]; then
    echo "This will kill ALL running Docker containers listed above."
    echo -n "Are you sure you want to continue? (y/n) "
    read -q response
    echo
    [[ $response =~ ^[Yy]$ ]] || { echo "Operation cancelled."; return 1; }
  fi

  local succeeded=()
  local failed=()

  if [[ -n $soft ]]; then
    echo "Stopping all containers gracefully..."
    for container in $containers; do
      local id=${container%%|*}
      local name=${container##*|}
      if docker stop $id &>/dev/null; then
        succeeded+=("$id \($name\)")
      else
        failed+=("$id \($name\)")
      fi
    done
  else
    echo "Killing all containers..."
    for container in $containers; do
      local id=${container%%|*}
      local name=${container##*|}
      if docker kill $id &>/dev/null; then
        succeeded+=("$id \($name\)")
      else
        failed+=("$id \($name\)")
      fi
    done
  fi

  echo "\nResults:"

  if [[ ${#succeeded} -gt 0 ]]; then
    echo "Successfully terminated containers:"
    for container in $succeeded; do
      echo "  ✓ $container"
    done
  fi

  if [[ ${#failed} -gt 0 ]]; then
    echo "Failed to terminate containers:"
    for container in $failed; do
      echo "  ✗ $container"
    done
    return 1
  else
    echo "All containers have been terminated successfully."
    return 0
  fi
}

# Add completion support for docker-kill-all
compdef _docker docker-kill-all
'

# Append the function to ~/.zshrc
if grep -q "docker-kill-all" "$HOME/.zshrc"; then
  echo "docker-kill-all function already exists in ~/.zshrc."
else
  echo "$function_content" >> "$HOME/.zshrc"
  echo "docker-kill-all function added to ~/.zshrc."
fi

# Reload Zsh configuration
echo "Function installed successfully."
echo "To activate, run: source ~/.zshrc"
