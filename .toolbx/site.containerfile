FROM quay.io/fedora/fedora:latest
COPY ./host-runner /usr/local/bin/host-runner
RUN ln -s /usr/local/bin/host-runner /usr/local/bin/podman
RUN dnf -y install flatpak-spawn golang just