# DOTFILES

All my dotfiles used at work or at home

## Configuration of dotfiles

https://harfangk.github.io/2016/09/18/manage-dotfiles-with-a-git-bare-repository.html

## Set upstrean branches

Add this to the section `[remote "origin"]`:

```
fetch = +refs/heads/*:refs/remotes/origin/*
```

Then, fetch all data

```sh
dotfiles fetch --tags origin
```

## Requirements

### Mandatory

- [i3-gaps](https://github.com/Airblader/i3)
- [polybar](https://github.com/polybar/polybar)
- [nerd-fonts](https://github.com/ryanoasis/nerd-fonts#option-3-install-script)
- [zsh](https://github.com/zsh-users/zsh)
- [oh-my-zsh](https://ohmyz.sh/)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [feh](https://github.com/derf/feh)
- [compton](https://github.com/chjj/compton)
- [dunst](https://github.com/dunst-project/dunst)

### Suggested

- [scrot](https://github.com/dreamer/scrot)
