# Eric's NVIM setup

I use this stuff, you don't have to. If you want to though do something like this:

```bash
# Install NeoVim
brew install neovim

# clone things
git clone git@github.com:ericmhalvorsen/nvim.git ~/.config/nvim

# Add alias and EDITOR, or don't, uses zsh replace with whatever, or skip
echo 'export EDITOR=vi' >> ~/.zshrc
echo 'alias vi=nvim' >> ~/.zshrc

# do the deed
vi

``` 

Don't do any of this if you're already using nvim, you'll probably run into
an error saying nvim dir is not empty. Merge into existing config is a whole
thing. Feel free to steal whatever, plugins are all in lua/eric/plugins

Lazy should initialize and it'll look like the gif below. I'm probably not
going to update the gif so if it's really out of date my bad.



