# Build website
[group('Development')]
build:
  @hugo --gc --minify

# Create article
[group('Development')]
create *files:
  #!/usr/bin/env bash

  set -euo pipefail

  # Organize files so they are sorted by year

  for file in $files; do
    # Create new content file for Hugo

    # Add file to _index.md file

  done

# Lint content
[group('Development')]
lint:
  #!/usr/bin/env bash

  set -euo pipefail

  podman run -v ./content:/workdir:z,ro --rm ghcr.io/igorshubovych/markdownlint-cli:latest "**/*.md"

# Publish article
[group('Development')]
publish *files:
  #!/usr/bin/env bash

  set -euo pipefail

  # Analyze front matter for yaml files for invalid data.
  if verify-file-links "$file"; then
    if verify-file-taxonomies "$file"; then
      for file in $files; do
        sed -i "s|draft: true|draft: false|" "$file"
      done
    fi
  fi

  exit $overall_status

# Serve website
[group('Development')]
serve:
  @hugo serve --watch -D

# Verify all links in file
[private]
[group('Development')]
verify-file-links file:
  #!/usr/bin/env bash

  set -euo pipefail

  podman run -v {{ file }}:/tmp/file:z,ro --rm ghcr.io/tcort/markdown-link-check:stable --quiet "/tmp/file"

# Verify all links in content
[private]
[group('Development')]
verify-links:
  #!/usr/bin/env bash

  set -euo pipefail

  overall_status=0
  for file in ./content/**/*.md; do
    if ! verify-file-links "$file"; then
      overall_status=1
    fi
  done

  exit $overall_status

# Verify taxonomies for provided file.
[private]
[group('Development')]
verify-file-taxonomies file:
  #!/usr/bin/env bash

  set -euo pipefail

  overall_status=0
  contents = $(cat {{ file }} | mdfmt)

  # Check categories for invalid data.
  if ! grep -q 'categories: []' <<< "$contents" && ! grep -q 'categories: \[.*todo\]' <<< "$contents"; then
    just stderr "The file ($file) contains invalid data for the `categories` field. Specify an empty list or a list of valid categories."
    overall_status=1
  fi

  # Check series for invalid data.
  if ! grep -q 'series: []' <<< "$contents" && ! grep -q 'series: \[.*todo\]' <<< "$contents"; then
    just stderr "The file ($file) contains invalid data for the `series` field. Specify an empty list or a list of valid series."
    overall_status=1
  fi

  # Check tags for invalid data.
  if ! grep -q 'tags: []' <<< "$contents" && ! grep -q 'tags: \[.*todo\]' <<< "$contents"; then
    just stderr "The file ($file) contains invalid data for the `tags` field. Specify an empty list or a list of valid tags."
    overall_status=1
  fi

  exit $overall_status

# Verify taxonomies provided in front matter
[private]
[group('Development')]
verify-taxonomies:
  #!/usr/bin/env bash

  set -euo pipefail

  # Enable extended globbing feature to match directory structure
  shopt -s globstar

  overall_status=0
  for file in ./content/**/*.md; do
    if ! verify-file-taxonomies "$file"; then
      overall_status=1
    fi
  done

  exit $overall_status

# Verify content
[group('Development')]
verify: verify-links verify-taxonomies