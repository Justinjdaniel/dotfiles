#!/usr/bin/env zsh

function installDependencies() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k;
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions;
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting;

  echo "👌 dependencies installed";
}

function configureZsh() {
  cp ./.zshrc ~/.zshrc;

  echo "👌 zsh configured successfully";
}

function configureGit() {
  cp ./.gitconfig ~/.gitconfig;
  cp ./.gitignore_global ~/.gitignore_global;

  echo "👌 git configured successfully";
}

function configureVim() {
  cp ./.vimrc ~/.vimrc;

  echo "👌 vim configured successfully";

}

function doIt() {
  if [ "$1" != "-u" ]; then
      installDependencies;
  fi
  
  configureZsh;
  configureGit;
  configureVim;
  echo "✅ Done";
}

trap 'echo "❌ an error occured" && exit' ERR

doIt $1;

unset installDependencies doIt configureZsh configureGit configureVim;