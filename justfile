# Settings
set ignore-comments := true

# Imports
import ".just/development.just"
import ".just/setup.just"

[private]
get-colors:
  #!/usr/bin/env bash

  set -euo pipefail

  cat <<EOF
  BLACK=30
  RED=31
  GREEN=32
  BROWN=33
  BLUE=34
  PURPLE=35
  CYAN=36
  GRAY=37
  BGBLACK=40
  BGRED=41
  BGGREEN=42
  BGBROWN=43
  BGBLUE=44
  BGPURPLE=45
  BGCYAN=46
  BGGRAY=47
  EOF

[private]
stderr message level="ERROR":
  #!/usr/bin/env bash

  set -euo pipefail

  MESSAGE="{{ message }}"
  LEVEL="{{ level }}"

  # Source colors and styles
  source <(just get-colors)
  source <(just get-styles)

  # Get styles for error message
  RED_BOLD=$(just stylize RED BOLD)
  BOLD=$(just stylize BOLD)
  NF=$(just stylize)

  >&2 echo -e "${RED_BOLD}[$LEVEL] ${NF}${BOLD}${MESSAGE}${NF}"
