syntax on       	"this is needed to see syntax
"set background=dark  "makes it easier to read with black background
"colorscheme ir_black "set theme in ./vim/colors folder
set ls=2            " allways show status line
set hlsearch        " highlight searches
set incsearch       " do incremental searching
set ruler           " show the cursor position all the time
set visualbell t_vb=    " turn off error beep/flash
set ignorecase        "ignore case while searching
"set number            "put numbers on side
set tabstop=4
set shiftwidth=4
set expandtab
set backspace=indent,eol,start

"augroup JsonAutoFormat
"    autocmd!
"    " auto format the json file after load, and before save
"    autocmd BufReadPost,BufWritePre *.json silent %!python -m json.tool
"augroup END
