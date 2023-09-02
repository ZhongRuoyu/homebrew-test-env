# syntax=docker/dockerfile:1

ARG BASE_IMAGE=homebrew/brew
FROM "${BASE_IMAGE}"
WORKDIR /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core

ENV HOMEBREW_DEVELOPER=1
ENV HOMEBREW_NO_INSTALL_FROM_API=1

ARG REMOTE
ARG REMOTE_URL
RUN <<-"EOF"
  set -e

  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    vim
  sudo apt-get autoremove -y --purge
  sudo rm -rf /var/lib/apt/lists/*

  git remote add "${REMOTE}" "${REMOTE_URL}"
  git fetch origin master
  git fetch "${REMOTE}" master

  brew developer on
  brew update
  brew install-bundler-gems
  brew cleanup
  rm -rf "$(brew --cache)"
EOF
