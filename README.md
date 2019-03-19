# config

Contents:
 * my `dotfiles`
 * my `nixcfg` containing my user/machine configurations

Uses:

 * `stow` to manage symlinks
 * `git-crypt` to manage encryption of our secretive files
 * `zplug` to manage zsh plugins <- I don't even use zsh right now
 * `tpm` to manage tpm plugins <- I don't think I use tpm or any tmux plugins (anymore|rightnow)

Ideas:
 - turn this into `monohome` repo with `password-store`, `dotfiles` and our `nixcfg` ?

Maybe:
 - `bootstrap.sh` will bootstrap a new NixOS/NixOps machine.
   - probably needs to be tested
