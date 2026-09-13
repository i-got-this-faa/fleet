#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly FLEET_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
readonly SOURCE_DIR="$FLEET_DIR/skills"
readonly CODEX_DIR="${CODEX_HOME:-${HOME:?}/.codex}"
readonly CODEX_SKILLS_DIR="$CODEX_DIR/skills"
readonly OMP_AGENT_DIR="${PI_CODING_AGENT_DIR:-${HOME:?}/.omp/agent}"
readonly OMP_SKILLS_DIR="$OMP_AGENT_DIR/skills"

apply=false

if [[ "${1:-}" == "--apply" ]]; then
  apply=true
elif (($# > 0)); then
  printf 'Usage: %s [--apply]\n' "${0##*/}" >&2
  exit 2
fi

target_is_safe() {
  local source_path="$1"
  local target_path="$2"

  if [[ -L "$target_path" ]]; then
    if [[ "$(readlink -f -- "$target_path")" == "$(readlink -f -- "$source_path")" ]]; then
      return 0
    fi
    printf 'CONFLICT: %s is a link to a different source.\n' "$target_path" >&2
    return 1
  fi

  if [[ -e "$target_path" ]]; then
    printf 'CONFLICT: %s already exists.\n' "$target_path" >&2
    return 1
  fi
}

make_link() {
  local source_path="$1"
  local target_path="$2"

  if [[ -L "$target_path" ]]; then
    printf 'OK: %s already points to Fleet.\n' "$target_path"
  elif [[ "$apply" == true ]]; then
    mkdir -p -- "$(dirname -- "$target_path")"
    ln -s -- "$source_path" "$target_path"
    printf 'LINKED: %s -> %s\n' "$target_path" "$source_path"
  else
    printf 'WOULD LINK: %s -> %s\n' "$target_path" "$source_path"
  fi
}

main() {
  local source_path
  local skill_name
  local conflicts=0

  [[ -d "$SOURCE_DIR" ]] || {
    printf 'ERROR: %s does not exist.\n' "$SOURCE_DIR" >&2
    exit 1
  }

  for source_path in "$SOURCE_DIR"/*; do
    [[ -d "$source_path" ]] || continue
    skill_name="${source_path##*/}"
    target_is_safe "$source_path" "$CODEX_SKILLS_DIR/$skill_name" ||
      conflicts=$((conflicts + 1))
    target_is_safe "$source_path" "$OMP_SKILLS_DIR/$skill_name" ||
      conflicts=$((conflicts + 1))
  done

  target_is_safe "$FLEET_DIR/AGENTS.md" "$CODEX_DIR/AGENTS.md" ||
    conflicts=$((conflicts + 1))
  target_is_safe "$FLEET_DIR/AGENTS.md" "$OMP_AGENT_DIR/AGENTS.md" ||
    conflicts=$((conflicts + 1))
  target_is_safe "$FLEET_DIR/RULES.md" "$OMP_AGENT_DIR/RULES.md" ||
    conflicts=$((conflicts + 1))

  if ((conflicts > 0)); then
    printf '%d conflict(s) need manual review. No link was created.\n' "$conflicts" >&2
    exit 1
  fi

  for source_path in "$SOURCE_DIR"/*; do
    [[ -d "$source_path" ]] || continue
    skill_name="${source_path##*/}"
    make_link "$source_path" "$CODEX_SKILLS_DIR/$skill_name"
    make_link "$source_path" "$OMP_SKILLS_DIR/$skill_name"
  done

  make_link "$FLEET_DIR/AGENTS.md" "$CODEX_DIR/AGENTS.md"
  make_link "$FLEET_DIR/AGENTS.md" "$OMP_AGENT_DIR/AGENTS.md"
  make_link "$FLEET_DIR/RULES.md" "$OMP_AGENT_DIR/RULES.md"

  if [[ "$apply" == false ]]; then
    printf 'Preview only. Run %s --apply to create the links.\n' "$0"
  else
    "$FLEET_DIR/scripts/check.sh" --installed
  fi
}

main "$@"
