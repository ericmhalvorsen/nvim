# Eric's NVIM setup

I use this stuff, you don't have to. If you want to though do something like this:

```bash
# install stuff
brew install neovim

# clone things
git clone git@github.com:ericmhalvorsen/nvim.git ~/.config/nvim

# Add alias and EDITOR, or don't, uses zsh replace with whatever, or skip
echo 'export EDITOR=vi' >> ~/.zshrc
echo 'alias vi=nvim' >> ~/.zshrc

# do the deed
vi

``` 

Lazy should initialize and it'll look like the gif below. I'm probably not
going to update the gif so if it's really out of date my bad.

# TODO gif

Don't do any of this if you're already using nvim, but you probably already
know that. Plugins in lua/eric/plugins if you want to take any config.

