# syntax=docker/dockerfile:1

ARG BASE_IMAGE=homebrew/brew
FROM "${BASE_IMAGE}"
WORKDIR /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core

ENV HOMEBREW_DEVELOPER=1
ENV HOMEBREW_NO_AUTOREMOVE=1
ENV HOMEBREW_NO_INSTALL_FROM_API=1
ENV HOMEBREW_DOWNLOAD_CONCURRENCY=auto

ARG REMOTE
ARG REMOTE_URL
RUN <<-"EOF"
  set -e

  brew update
  brew install-bundler-gems --groups=all
  brew tap zhongruoyu/test-env
  brew cleanup
  rm -rf "$(brew --cache)"

  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    bash-completion \
    bat \
    fd-find \
    fzf \
    ripgrep \
    vim
  sudo apt-get autoremove -y --purge
  sudo rm -rf /var/lib/apt/lists/*
  sudo ln -s /usr/bin/batcat /usr/local/bin/bat
  sudo ln -s /usr/bin/fdfind /usr/local/bin/fd

  git clone https://github.com/ZhongRuoyu/dotfiles.git ~/.local/share/dotfiles
  ~/.local/share/dotfiles/install.sh
EOF

CMD [ "bash", "-il" ]
