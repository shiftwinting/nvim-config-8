set hidden
set linebreak
set shortmess=cfilnxtToOIF
set modelines=5
set updatetime=300
set wildmode=longest,list
set wildmenu
set completeopt=menu,noinsert,noselect,preview
set complete=.,w,b,u
set signcolumn=yes
set nobackup
set nowritebackup
set expandtab
set shiftwidth=4
set softtabstop=4
set number
set wildignore=node_modules/**,elm-stuff/**,.git/**,build/**,dist/**,*.temp,obj/**,bin/**
set undofile
set history=400
set lazyredraw
set magic
set noerrorbells
set novisualbell
set ignorecase
set smartcase
set inccommand="nosplit"
let &undodir = g:configDir . "/undo/"
let &directory = g:configDir . "/swap/"

" Leader
let mapleader = ' '

" Enable filetype plugin
filetype plugin indent on

" Workspace
autocmd VimEnter * set noshowmode
autocmd VimEnter * set formatoptions+=or
autocmd VimEnter * set hidden " fix hacky netrw

" Terminal
autocmd TermClose * if &ft != 'fzf' | call feedkeys('<cr>')

" ----------------------------- "
"             grep              "
"------------------------------ "

if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --hidden
endif

" ----------------------------- "
"         text objects          "
"------------------------------ "

if g:IsLoaded('vim-textobj-user')
    " FIXME: I want ['at, 'ad'] to match a time or a date (not just datetime)
    " (\d{2,4}-\d{1,2}-\d{1,2}[ |T]\d{1,2}:\d{1,2}:\d{1,2}|\d{2,4}-\d{1,2}-\d{1,2}|\d{1,2}:\d{1,2}:\d{1,2})
    call textobj#user#plugin('datetime', {
    \   'datetime': {
    \       'pattern': '\<\(\d\d\d\d-\d\d-\d\d[ |T]\d\d:\d\d:\d\d\)\>',
    \       'select': ['ad', 'at'],
    \   },
    \   'date': {
    \     'pattern': '\<\d\d\d\d-\d\d-\d\d\>',
    \     'select': ['id'],
    \   },
    \   'time': {
    \     'pattern': '\<\d\d:\d\d:\d\d\>',
    \     'select': ['it'],
    \   },
    \ })
endif

" ----------------------------- "
"          delimitmate          "
"------------------------------ "

if g:IsLoaded('delimitmate')
    let g:delimitMate_expand_cr = 2
    let g:delimitMate_expand_space = 1
endif

" ----------------------------- "
"              ale              "
"------------------------------ "

if g:IsLoaded('ale')
    let g:ale_sign_error = '???'
    let g:ale_sign_warning = '???'
    let g:ale_disable_lsp = 1
    let g:ale_linters_explicit = 1
    let g:ale_virtualtext_cursor = 0
    let g:ale_echo_cursor = 1
    let g:ale_set_loclist = 0
    let g:ale_linters = {}
endif

" ----------------------------- "
"             emmet             "
"------------------------------ "

" to prevent emmet conflicting w/ completion
let g:user_emmet_leader_key = '<C-l>'

" ----------------------------- "
"            polyglot           "
"------------------------------ "

if g:IsLoaded('vim-polyglot')
    let g:polyglot_disabled = [
    \ 'elm',
    \ ]
endif

" ----------------------------- "
"          editorconfig         "
"------------------------------ "

let g:EditorConfig_max_line_indicator = 'none'
" These rules cause another save...
let g:EditorConfig_disable_rules = ['insert_final_newline', 'trim_trailing_whitespace']

" ----------------------------- "
"              coc              "
"------------------------------ "

if g:IsLoaded('coc.nvim')
    let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-json',
    \ 'coc-snippets',
    \ 'coc-rls',
    \ 'coc-yaml',
    \ 'coc-html',
    \ 'coc-python',
    \ 'coc-css',
    \ ]

    autocmd CursorMoved,CursorMovedI * call coc#util#float_hide()

    let g:coc_snippet_next = '<tab>'

    autocmd CursorHold * silent call CocActionAsync('highlight')

    command! -nargs=0 Format :call CocAction('format')

    command! -nargs=? Fold :call CocAction('fold', <f-args>)

    augroup cocformat
        autocmd!
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end
endif

" ----------------------------- "
"           omnisharp           "
"------------------------------ "

if g:IsLoaded('omnisharp-vim')
    let g:OmniSharp_server_stdio = 1
    let g:OmniSharp_open_quickfix = 1
    let g:OmniSharp_highlight_types = 2
    let g:OmniSharp_diagnostic_overrides = {
    \ 'CsharpStyleUnusedValueExpressionStatementPreference': {'type': 'None'}
    \}
    if g:IsLoaded('fzf')
        let g:OmniSharp_selector_ui = 'fzf'
    endif
    if g:DetectOS() == 'wsl'
        let g:OmniSharp_translate_cygwin_wsl = 1
        let g:OmniSharp_server_path = '/mnt/c/OmniSharp/omnisharp-win-x64/OmniSharp.exe'
    endif
endif

" ----------------------------- "
"            status             "
"------------------------------ "

if g:IsLoaded('vim-airline')
    " general
    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif
    if g:IsLoaded('vim-devicons')
        let g:airline_powerline_fonts = 1
        let g:airline_symbols_ascii = 0
    else
        let g:airline_symbols_ascii = 1
        let g:airline_powerline_fonts = 0
    endif
    let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
    let g:airline_exclude_preview = 1
    let g:airline_skip_empty_sections = 1
    let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'z', 'warning', 'error']]
    
    let g:airline_right_sep = '???'
    let g:airline_left_sep = '???'
    let g:airline_symbols.crypt = '????'

    let g:airline_symbols.paste = '??'
    let g:airline_symbols.spell = '???'
    let g:airline_symbols.notexists = ' ??'
    let g:airline_symbols.branch = '???'
    let g:airline_symbols.dirty = '*'

    function! AirlineInit()
        call airline#parts#define_raw('modified', '%{&modified ? "???" : ""}')
        " let g:airline_section_c = airline#section#create(['%f', 'modified'])
        " FIXME: prevent section c taking up full width
        let g:airline_section_c = '%<%f%{&modified ? " ??? " : ""} %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
        "
        let g:airline_section_z = airline#section#create(['linenr'])
    endfunction
    autocmd User AirlineAfterInit call AirlineInit()

    " extensions
    let g:airline_extensions = [
    \ 'branch',
    \ 'ale',
    \ 'tabline',
    \ ]

    " tabline
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#right_sep = '???'
    let g:airline#extensions#tabline#left_sep = '???'
    let g:airline#extensions#tabline#show_buffers = 0
    let g:airline#extensions#tabline#show_splits = 1
    let g:airline#extensions#tabline#show_tabs = 1
    let g:airline#extensions#tabline#show_tab_count = 0
    let g:airline#extensions#tabline#show_tab_nr = 0
    let g:airline#extensions#tabline#show_tab_type = 0
    let g:airline#extensions#tabline#show_close_button = 0
    let g:airline#extensions#tabline#formatter = 'unique_tail'
    let airline#extensions#coc#error_symbol = '???:'
    let airline#extensions#coc#warning_symbol = '???:'
endif

" ----------------------------- "
"              fzf              "
"------------------------------ "

if g:IsLoaded('fzf-preview.vim')
    let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages -g \!"* *"'
endif

if g:IsLoaded('fzf')
    let $FZF_DEFAULT_OPTS='--layout=reverse'
    let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.6, 'yoffset': 0 } }
    if executable('rg')
        let $FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git"'
    endif
endif


" ----------------------------- "
"            echodoc            "
"------------------------------ "

let g:echodoc#enable_at_startup = 0
let g:echodoc#type = 'floating'

" ----------------------------- "
"              nvr              "
"------------------------------ "

if has('nvim')
    let $VISUAL = 'nvr -cc vsplit --remote-wait'
endif

" ----------------------------- "
"            macros             "
"------------------------------ "

" Macro trick https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
    echo '@'.getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
endfunction

" ----------------------------- "
"            themes             "
"------------------------------ "

function! s:ThemeOneDark()
    let g:onedark_terminal_italics = 1
    let g:airline_theme = 'onedark'
    syntax on
    colorscheme onedark
endfunction

function! s:ThemeGruvbox()
    set termguicolors
    let g:airline_theme = 'gruvbox'
    let g:gruvbox_contrast_dark = 'medium'
    " re-evaluate when cascadia releases italicized/bolded fonts
    let g:gruvbox_italic = 0
    let g:gruvbox_bold = 0
    let g:gruvbox_underline = 0
    let g:gruvbox_italicize_comments = 1
    let g:gruvbox_italicize_strings = 1
    set background=dark
    syntax on
    colorscheme gruvbox
endfunction

function! s:SetupTheme()
    if has('termguicolors') && g:IsLoaded('gruvbox')
        call s:ThemeGruvbox()
    elseif g:IsLoaded('onedark.vim')
        call s:ThemeOneDark()
    endif
    if g:IsLoaded('coc.nvim')
        hi CocErrorFloat ctermfg=LightRed guifg=#fa8072
    endif
endfunction

call s:SetupTheme()
