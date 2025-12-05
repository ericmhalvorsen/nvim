# LazyVim config

https://www.lazyvim.org/installation

I use this stuff, you don't have to. If you want:

```bash
# install stuff
brew install neovim

# backup
mv ~/.config/nvim{,.bak}

# clone things
git clone git@github.com:ericmhalvorsen/nvim.git ~/.config/nvim

# Add alias and EDITOR, or don't, uses zsh replace with whatever, or skip
echo 'export EDITOR=vi' >> ~/.zshrc
echo 'alias vi=nvim' >> ~/.zshrc

source ~/.zshrc

# do it
vi

``` 

