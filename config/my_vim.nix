{vim_configurable, vimPlugins}:

vim_configurable.customize {
  name = "myvim";

  # add imy custom .vimrc
  vimrcConfig.customRC = ''
      filetype plugin indent on

      " configure maralla/completor to use tab
      " other configurations are possible (see website)
      inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
      inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

      " ultisnips default bindings compete with completor's tab
      " so we need to remap them
      let g:UltiSnipsExpandTrigger="<c-t>"
      let g:UltiSnipsJumpForwardTrigger="<c-b>"
      let g:UltiSnipsJumpBackwardTrigger="<c-z>"

      " airline :
      " for terminology you will need either to export TERM='xterm-256color'
      " or run it with '-2' option
      let g:airline_powerline_fonts = 1
      set laststatus=2
      au VimEnter * exec 'AirlineTheme hybrid'

      set encoding=utf-8

      syntax on

      colo gruvbox
      set background=dark
      " colo PaperColor
      " set background=light
      set number

      let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

      " replace tabs
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set expandtab

      " highlight trailing whitespace
      highlight ExtraWhitespace ctermbg=red guibg=red
      match ExtraWhitespace /\s\+\%#\@<!$/

      " some more rust
      let g:LanguageClient_loadSettings = 1 " this enables you to have per-projects languageserver settings in .vim/settings.json
      let g:rustfmt_autosave = 1
      let g:rust_conceal = 1
      set hidden
      au BufEnter,BufNewFile,BufRead *.rs syntax match rustEquality "==\ze[^>]" conceal cchar=≟
      au BufEnter,BufNewFile,BufRead *.rs syntax match rustInequality "!=\ze[^>]" conceal cchar=≠

      " let's autoindent c files
      au BufWrite *.c call LanguageClient#textDocument_formatting()

      " run language server for python, rust and c
      let g:LanguageClient_autoStart = 1
      let g:LanguageClient_serverCommands = {
      \ 'python': ['pyls'],
      \ 'rust': ['rustup', 'run', 'stable', 'rls'],
      \ 'javascript': ['javascript-typescript-stdio'],
      \ 'go': ['go-langserver'],
      \ 'c' : ['clangd'] }

  '';

    # store your plugins in Vim packages
    vimrcConfig.packages.myVimPackage = with vimPlugins; {
      # loaded on launch
      start = [
        vim-sensible
        vim-airline
        vim-airline-themes
        gruvbox
        vim-devicons
        webapi-vim
        vim-fugitive
        nerdtree
        ultisnips
        vim-snippets
        LanguageClient-neovim
        # completor
        # "papercolor-theme"
        rust-vim
        vim-nix
      ];
      opt = [ Syntastic ];
    };
  }
