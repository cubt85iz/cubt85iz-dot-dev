# Settings
set ignore-comments := true

# Imports
import ".just/development.just"
import ".just/setup.just"

[private]
stderr message level="ERROR":
  #!/usr/bin/env bash

  set -euo pipefail

  MESSAGE="{{ message }}"
  LEVEL="{{ level }}"

  >&2 echo -e "{{ RED + BOLD }}[$LEVEL] {{ NORMAL + BOLD }}${MESSAGE}{{ NORMAL }}"
