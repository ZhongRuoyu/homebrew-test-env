# syntax=docker/dockerfile:1

ARG BASE_IMAGE=homebrew/brew
FROM ${BASE_IMAGE}

ARG REMOTE
ARG REMOTE_URL
RUN <<-"EOF"
  set -e
  git -C .linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core remote add "${REMOTE}" "${REMOTE_URL}"
  git -C .linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core fetch origin master
  git -C .linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core fetch "${REMOTE}" master
  brew analytics off
  brew developer on
  brew update
  brew tap homebrew/homebrew-test-bot
  brew install-bundler-gems
  brew install \
    gcc \
    glibc \
    patchelf \
    vim
  brew cleanup
  rm -rf .cache
EOF
