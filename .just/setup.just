# Build toolbox container for site
[private]
[group('Setup')]
[group('Toolbox')]
build-toolbox:
  #!/usr/bin/env bash

  set -euo pipefail

  # Build toolbox container for Site development
  pushd .toolbx > /dev/null
  podman build -t ghcr.io/cubt85iz/cubt85iz-dot-dev-site:latest -f site.containerfile .
  popd > /dev/null

# Create toolbox container for site
[private]
[group('Setup')]
[group('Toolbox')]
create-toolbox:
  #!/usr/bin/env bash

  set -euo pipefail

  # Check for container and stop and remove it if it exists.
  if podman container exists cubt85iz-dot-dev-site; then
    podman stop cubt85iz-dot-dev-site
    podman rm cubt85iz-dot-dev-site
  fi

  # Create a new container.
  toolbox create --image ghcr.io/cubt85iz/cubt85iz-dot-dev-site:latest cubt85iz-dot-dev-site

# Enter the toolbox container. Create toolbox if it doesn't exist.
[group('Setup')]
[group('Toolbox')]
enter-toolbox:
  #!/usr/bin/env bash

  set -euo pipefail

  # Create the container if it does not exist.
  if ! podman container exists cubt85iz-dot-dev-site; then
    just setup
  fi

  # Enter the container.
  toolbox enter cubt85iz-dot-dev-site

[group('Setup')]
install-hugo VERSION="0.146.2":
  #!/usr/bin/env bash

  set -euo pipefail

  # Set the URL for the specified version of Hugo Extended
  URL="https://github.com/gohugoio/hugo/releases/download/v{{VERSION}}/hugo_extended_{{VERSION}}_linux-amd64.tar.gz"

  # Ensure destination directory exists.
  mkdir -p ${HOME}/.local/bin

  # Download & install the tarball.
  curl -sSL -o ${HOME}/.local/bin/hugo_extended_{{VERSION}}_linux-amd64.tar.gz "$URL"
  tar xzf ${HOME}/.local/bin/hugo_extended_{{VERSION}}_linux-amd64.tar.gz -C ${HOME}/.local/bin/
  rm ${HOME}/.local/bin/hugo_extended_{{VERSION}}_linux-amd64.tar.gz

# Set up toolbox for development.
[group('Setup')]
setup: build-toolbox create-toolbox install-hugo
