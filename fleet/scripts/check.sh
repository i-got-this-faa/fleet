#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly FLEET_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
readonly SKILLS_DIR="$FLEET_DIR/skills"
readonly CODEX_DIR="${CODEX_HOME:-${HOME:?}/.codex}"
readonly OMP_AGENT_DIR="${PI_CODING_AGENT_DIR:-${HOME:?}/.omp/agent}"
readonly CODEX_VALIDATOR="$CODEX_DIR/skills/.system/skill-creator/scripts/quick_validate.py"

failures=0
check_installed=false

if [[ "${1:-}" == "--installed" ]]; then
  check_installed=true
elif (($# > 0)); then
  printf 'Usage: %s [--installed]\n' "${0##*/}" >&2
  exit 2
fi

report_failure() {
  printf 'FAIL: %s\n' "$*" >&2
  failures=$((failures + 1))
}

is_strict_skill() {
  case "$1" in
    install-anti-slop | wizard | grill-me | grilling)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

is_local_skill() {
  case "$1" in
    anti-slop-code | babysit-pr | file-a-pr | finish-the-work | hit-every-surface | publish-qckpage | share-with-fbs | verify-real-behavior)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

check_skill() {
  local skill_dir="$1"
  local skill_name="${skill_dir##*/}"
  local skill_file="$skill_dir/SKILL.md"

  [[ -f "$skill_file" ]] || {
    report_failure "$skill_name has no SKILL.md"
    return
  }

  grep -Eq '^name: .+' "$skill_file" ||
    report_failure "$skill_name has no name"
  grep -Eq '^description: .+' "$skill_file" ||
    report_failure "$skill_name has no description"

  if is_local_skill "$skill_name"; then
    grep -Fqx "name: $skill_name" "$skill_file" ||
      report_failure "$skill_name has an incorrect name"
    if rg -n 'TODO|PLACEHOLDER' "$skill_dir" >/dev/null; then
      report_failure "$skill_name contains template text"
    else
      local scan_status=$?
      if ((scan_status != 1)); then
        report_failure "$skill_name could not be scanned for template text"
      fi
    fi

  fi

  if is_strict_skill "$skill_name"; then
    python3 "$CODEX_VALIDATOR" "$skill_dir" >/dev/null ||
      report_failure "$skill_name failed the Codex validator"
  fi
}

check_link() {
  local source_path="$1"
  local target_path="$2"

  if [[ ! -L "$target_path" ]]; then
    report_failure "$target_path is not an installed link"
    return
  fi

  if [[ "$(readlink -f -- "$target_path")" != "$(readlink -f -- "$source_path")" ]]; then
    report_failure "$target_path does not point to Fleet"
  fi
}

main() {
  local skill_dir
  local credential_pattern
  local scan_status

  [[ -d "$SKILLS_DIR" ]] || report_failure "The skills directory does not exist"
  [[ -f "$CODEX_VALIDATOR" ]] ||
    report_failure "The Codex skill validator is not available"

  for skill_dir in "$SKILLS_DIR"/*; do
    [[ -d "$skill_dir" ]] || continue
    check_skill "$skill_dir"
  done

  bash -n "$FLEET_DIR/scripts/install.sh" ||
    report_failure "install.sh has invalid Bash syntax"
  bash -n "$FLEET_DIR/skills/wizard/template.sh" ||
    report_failure "The wizard template has invalid Bash syntax"

  credential_pattern="(password|passwd|token|secret|api[_-]?key)[[:space:]]*[:=][[:space:]]*['\"]?[A-Za-z0-9_./+-]{8,}"
  if rg -n -i --hidden \
    --glob '!scripts/check.sh' \
    --glob '!notes/session-audit.md' \
    --glob '!skills/**/node_modules/**' \
    "$credential_pattern" \
    "$FLEET_DIR" >/dev/null; then
    report_failure "Fleet can contain a credential value"
  else
    scan_status=$?
    if ((scan_status != 1)); then
      report_failure "Fleet could not be scanned for credential values"
    fi
  fi

  if [[ "$check_installed" == true ]]; then
    for skill_dir in "$SKILLS_DIR"/*; do
      [[ -d "$skill_dir" ]] || continue
      check_link "$skill_dir" "$CODEX_DIR/skills/${skill_dir##*/}"
      check_link "$skill_dir" "$OMP_AGENT_DIR/skills/${skill_dir##*/}"
    done

    check_link "$FLEET_DIR/AGENTS.md" "$CODEX_DIR/AGENTS.md"
    check_link "$FLEET_DIR/AGENTS.md" "$OMP_AGENT_DIR/AGENTS.md"
    check_link "$FLEET_DIR/RULES.md" "$OMP_AGENT_DIR/RULES.md"
  fi

  if ((failures > 0)); then
    printf '%d check(s) failed.\n' "$failures" >&2
    exit 1
  fi

  if [[ "$check_installed" == true ]]; then
    printf 'All Fleet source and installed-link checks passed.\n'
  else
    printf 'All Fleet source checks passed.\n'
  fi
}

main "$@"
