{ pkgs, config, ... }:

{
    # Install all the packages
    environment.systemPackages = with pkgs; [

        # Rice/desktop
        dwm dmenu feh zsh dunst st

        # Command-line tools
        fzf ripgrep newsboat ffmpeg tealdeer exa 
        pass gnupg slop bat tmux
        libnotify sct update-nix-fetchgit 
       
        # GUI applications
        firefox mpv anki

        # Development
        git gcc gnumake python3 

        # Language servers for neovim; change these to whatever languages you code in
        # Please note: if you remove any of these, make sure to also remove them from nvim/config/nvim/lua/lsp.lua!!
        rnix-lsp
        sumneko-lua-language-server
    ];
}
