#!/usr/bin/env bash
# Forwarder so ./docker.sh works from src/ too; the real script is at
# the repository root.
exec "$(dirname "$0")/../docker.sh" "$@"
