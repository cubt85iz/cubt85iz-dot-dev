# Build toolbox container for hugo
[private]
[group('Setup')]
[group('Toolbox')]
build-toolbox:
  #!/usr/bin/env bash

  set -euo pipefail

  # Build toolbox container for Hugo development
  pushd .toolbx > /dev/null
  podman build -t ghcr.io/cubt85iz/cubt85iz-dot-dev-hugo:latest -f hugo.containerfile .
  popd > /dev/null

# Create toolbox container for hugo
[private]
[group('Setup')]
[group('Toolbox')]
create-toolbox:
  #!/usr/bin/env bash

  set -euo pipefail

  # Check for container and stop and remove it if it exists.
  if podman container exists cubt85iz-dot-dev-hugo; then
    podman stop cubt85iz-dot-dev-hugo
    podman rm cubt85iz-dot-dev-hugo
  fi

  # Create a new container.
  toolbox create --image ghcr.io/cubt85iz/cubt85iz-dot-dev-hugo:latest cubt85iz-dot-dev-hugo

# Enter the toolbox container. Create toolbox if it doesn't exist.
[group('Setup')]
[group('Toolbox')]
enter-toolbox:
  #!/usr/bin/env bash

  set -euox pipefail

  # Create the container if it does not exist.
  if ! podman container exists cubt85iz-dot-dev-hugo; then
    just setup
  fi

  # Enter the container.
  toolbox enter cubt85iz-dot-dev-hugo

# Set up toolbox for development.
[group('Setup')]
setup: build-toolbox create-toolbox