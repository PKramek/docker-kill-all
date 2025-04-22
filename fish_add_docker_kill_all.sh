#!/usr/bin/env fish

# Docker Container Manager for Fish Shell
# Version 3.0 - 2025-04-22

set -l fish_config_dir "$HOME/.config/fish"
set -l fish_config "$fish_config_dir/config.fish"
set -l completion_dir "$fish_config_dir/completions"

# Create configuration structure
if not mkdir -p "$completion_dir"
    echo "Error: Configuration directory creation failed" >&2
    exit 1
end

# Define core function with warning handling
set -l function_code 'function docker-kill-all
    argparse -n docker-kill-all "f/force" "s/soft" "h/help" -- $argv || return 1

    if set -q _flag_help
        echo "Usage: docker-kill-all [-f|--force] [-s|--soft] [-h|--help]"
        return 0
    end

    # Docker connection check
    if not command docker info >/dev/null 2>&1
        echo "Error: Docker daemon unavailable" >&2
        return 1
    end

    # Get containers with warning filtering
    set -l container_data (command docker ps --format "{{.ID}}|{{.Names}}" 2>/dev/null | grep -v "WARNING")
    set -l containers (string split \n -- $container_data)

    if test -z "$containers[1]"
        echo "No running containers" >&2
        return 0
    end

    # Interactive confirmation
    if not set -q _flag_force
        echo "Targeting "(count $containers)" containers:"
        printf "  • %s\n" (string replace "|" " (" $containers | string append ")")
        read -P "Confirm termination? [y/N] " -l response
        if not string match -qi "y*" -- "$response"
            echo "Operation cancelled" >&2
            return 1
        end
    end

    # Execution logic
    set -l action (test -n "_flag_soft"; and echo "stop"; or echo "kill")
    set -l failed_count 0

    for container in $containers
        set -l id (string split "|" -- $container)[1]
        if not command docker $action $id >/dev/null 2>&1
            set failed_count (math $failed_count + 1)
        end
    end

    # Result reporting
    set -l success_count (math (count $containers) - $failed_count)
    echo "Terminated: $success_count | Failed: $failed_count" >&2
    test $failed_count -eq 0
end'

# Install function with version check
if not grep -q "Version 3.0" "$fish_config" 2>/dev/null
    echo "$function_code" >> "$fish_config"
end

# Install completions
set -l comp_path "$completion_dir/docker-kill-all.fish"
if not test -f "$comp_path"
    echo "complete -c docker-kill-all -s f -l force -d 'Bypass confirmation'
complete -c docker-kill-all -s s -l soft -d 'Graceful stop'
complete -c docker-kill-all -s h -l help -d 'Show help'" > "$comp_path"
end

echo "Install complete. Restart shell or run: source $fish_config"
