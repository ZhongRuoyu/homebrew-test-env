# syntax=docker/dockerfile:1

ARG BASE_IMAGE=homebrew/brew
FROM "${BASE_IMAGE}"
WORKDIR /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core

ENV HOMEBREW_NO_INSTALL_FROM_API=1

ARG REMOTE
ARG REMOTE_URL
RUN <<-"EOF"
  set -e
  git remote add "${REMOTE}" "${REMOTE_URL}"
  git fetch origin master
  git fetch "${REMOTE}" master
  brew analytics off
  brew developer on
  brew update
  brew install-bundler-gems
  brew install \
    patchelf \
    vim
  brew cleanup
  rm -rf "$(brew --cache)"
EOF
