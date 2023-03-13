{ vim_configurable, vimUtils, vimPlugins, stdenv, fetchgit }:

let
  customPlugins = {
    # generated by https://gist.github.com/jagajaga/3c7ba009ee6756e12978
    vim-openscad = vimUtils.buildVimPlugin {
      name = "openscad-git-2015-07-21";
      src = fetchgit {
        url = "https://github.com/sirtaj/vim-openscad.git";
        rev = "2ac407dcc73176862524e0cf18c00d85146fac57";
        sha256 = "0x3g9h0cnk7hfpqx8x92xy7mhvq2piwy3mhwds8nnn2rsa5jj0cf";
      };
      meta = {
        homepage = "https://github.com/sirtaj/vim-openscad";
        maintainers = [ stdenv.lib.maintainers.jagajaga ];
      };
    };
    rust-syntax-ext = vimUtils.buildVimPlugin {
      name = "rust-syntax-ext-git-2020-04-17";
      src = fetchgit {
        url = "https://github.com/arzg/vim-rust-syntax-ext.git";
        rev = "b32ae796adaf7f104cc31b96e38b24535ba8294d";
        sha256 = "0dfniczcmhmspxhbmsizdf7g3rjh85ffpxfc24vliy23bfy1ziz1";
      };
      meta = {
        homepage = "https://github.com/arzg/vim-rust-syntax-ext";
        maintainers = [ stdenv.lib.maintainers.jagajaga ];
      };
    };
  };
in vim_configurable.customize {
  name = "vim";

  # add imy custom .vimrc
  vimrcConfig.customRC = ''
    " airline :
    let g:airline_powerline_fonts = 1
    au VimEnter * exec 'AirlineTheme hybrid'
    set encoding=utf-8
    set background=light
    set termguicolors
    colo PaperColor
    set number
    " replace tabs
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
    set expandtab
    " highlight trailing whitespace
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+\%#\@<!$/
    let g:rustfmt_autosave = 1
    let g:rust_conceal = 1
    set hidden
    au BufEnter,BufNewFile,BufRead *.rs syntax match rustEquality "==\ze[^>]" conceal cchar=≟
    au BufEnter,BufNewFile,BufRead *.rs syntax match rustInequality "!=\ze[^>]" conceal cchar=≠

    let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
    let g:ale_fix_on_save = 1
    let g:ale_completion_enabled = 1
    let g:ale_sign_error = "✗"
    let g:ale_sign_warning = "⚠"
    let g:ale_linters = { 'rust': ['analyzer'], 'python': ['pylint', 'pylsp'], 'c': ['ccls'], 'javascript': ['flow'] }
    let g:airline#extensions#ale#enabled = 1

    nmap K :ALEHover<CR>
    nmap gd :ALEGoToDefinition<CR>
  '';

  # store your plugins in Vim packages
  vimrcConfig.vam.knownPlugins = vimPlugins // customPlugins;
  vimrcConfig.vam.pluginDictionaries = [{
    names = [
      "vim-sensible" # sane defaults
      "vim-airline" # fancy status line
      "vim-airline-themes" # themes for status line
      # "vim-devicons" # icons for coding
      "webapi-vim" # needed for RustPlay
      "nerdtree" # file system explorer
      "rust-vim" # rust syntax, formatting, rustplay...
      "vim-addon-nix" # nix syntax
      "vim-openscad" # openscad syntax
      "ale" # interface to languageserver
      "rust-syntax-ext" # more syntax for rust
      "awesome-vim-colorschemes" # a ton of colorschemes
    ];
  }];
}
