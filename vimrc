" =============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
" -----------------------------------------------------------------------------
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif

" -----------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

" =============================================================================
"                          << 以下为软件默认配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set diffexpr=MyDiff()

    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

" -----------------------------------------------------------------------------
"  < Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if g:islinux
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        set mouse=a                    " 在任何模式下启用鼠标
        set t_Co=256                   " 在终端启用256色
        set backspace=2                " 设置退格键可用

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif


" =============================================================================
"                          << 以下为用户自定义配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Vundle 插件管理工具配置 >
" -----------------------------------------------------------------------------
" 用于更方便的管理vim插件，具体用法参考 :h vundle 帮助
" 安装方法为在终端输入如下命令
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" 如果想在 windows 安装就必需先安装 "git for window"，可查阅网上资料

set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测

if g:islinux
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
else
    set rtp+=$VIM/vimfiles/bundle/vundle/
    call vundle#rc('$VIM/vimfiles/bundle/')
endif

" Vundle
Plugin 'gmarik/vundle'

Plugin 'jiangmiao/auto-pairs'
Plugin 'Mark--Karkat'
Plugin 'godlygeek/tabular'
" Plugin 'scrooloose/syntastic'
" Plugin 'Shougo/neocomplete'               

Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'

Plugin 'a.vim'
Plugin 'c.vim'
Plugin 'cpp.vim'
Plugin 'OmniCppComplete'
Plugin 'std_c.zip'
Plugin 'Mizuchi/STL-Syntax'
Plugin 'xuqix/h2cppx'
Plugin 'DoxygenToolkit.vim'
" Plugin 'refactor'

Plugin 'ccvext.vim'
Plugin 'majutsushi/tagbar'

Plugin 'L9'
Plugin 'fuzzyfinder'
Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-markdown'
Plugin 'lua-support'

Plugin 'xolox/vim-misc'
" Plugin 'xolox/vim-lua-ftplugin'
" Plugin 'lua.vim'

Plugin 'bash-support.vim'

Plugin 'Lokaltog/vim-powerline'
Plugin 'rking/ag.vim'

Plugin 'winmanager'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'cctree'
Plugin 'powerman/vim-plugin-AnsiEsc'

Plugin 'kana/vim-operator-user'
Plugin 'rhysd/vim-clang-format'

if g:islinux
    Plugin 'Valloric/YouCompleteMe'           
    Plugin 'rdnetto/YCM-Generator'
endif

Plugin 'Lokaltog/vim-easymotion'
Plugin 'juneedahamed/svnj.vim'

let g:EasyMotion_smartcase = 1
"let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
map <Leader><leader>h <Plug>(easymotion-linebackward)
map <Leader><Leader>j <Plug>(easymotion-j)
map <Leader><Leader>k <Plug>(easymotion-k)
map <Leader><leader>l <Plug>(easymotion-lineforward)

"" 重复上一次操作, 类似repeat插件, 很强大
map <Leader><leader>. <Plug>(easymotion-repeat)

" -----------------------------------------------------------------------------
"  < 编码配置 >
" -----------------------------------------------------------------------------
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                                    "设置gvim内部编码
set fileencoding=utf-8                                "设置当前文件编码
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码

" 文件格式，默认 ffs=dos,unix
set fileformat=unix                                   "设置新文件的<EOL>格式
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型

if (g:iswindows && g:isGUI)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "解决consle输出乱码
    language messages zh_CN.utf-8
endif

" F快捷键映射
map <F2>    :NERDTreeToggle<CR>
map <F3>    :NERDTreeFind<cr>

function! FormatFile()
    let l:lines="all"
    pyf $VIM/vimfiles/plugin/clang-format.py
endfunction

map <S-F> :call FormatFile()<cr>
" map <S-F> :pyf $VIM/vimfiles/plugin/clang-format.py<cr>
" imap <S-F> <c-o>:pyf $VIM/vimfiles/plugin/clang-format.py<cr>

" < Tabularize 快捷键映射 >


" -----------------------------------------------------------------------------
"  < 编写文件时的配置 >
" -----------------------------------------------------------------------------
filetype on                                             "启用文件类型侦测
filetype plugin on                                      "针对不同的文件类型加载对应的插件
filetype plugin indent on                               "启用缩进
set smartindent                                         "启用智能对齐方式
set expandtab                                           "将Tab键转换为空格
set tabstop=4                                           "设置Tab键的宽度
set shiftwidth=4                                        "换行时自动缩进2个空格
set smarttab                                            "指定按一次backspace就删除shiftwidth宽度的空格
let mapleader=";"                                       " 设置快捷键前缀

" 设置代码折叠功能
" set foldlevel=100   " 默认不折叠
" set foldenable
" set foldmethod=indent
set foldmethod=syntax
set foldcolumn=1    " 设置折叠区域宽度
set nofoldenable    " 启动时关闭折叠代码
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>  " 用空格键来开关折叠

" 当文件在外部被修改，自动更新该文件
set autoread

" 常规模式下输入 cS 清除行尾空格
nmap cS :%s/\s\+$//g<CR>:noh<CR>

" 常规模式下输入 cM 清除行尾 ^M 符号
nmap cM :%s/\r$//g<CR>:noh<CR>

" set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
" set noincsearch                                       "在输入要搜索的文字时，取消实时匹配

" Ctrl + K 插入模式下光标向上移动
imap <c-k> <Up>

" Ctrl + J 插入模式下光标向下移动
imap <c-j> <Down>

" Ctrl + H 插入模式下光标向左移动
imap <c-h> <Left>

" Ctrl + L 插入模式下光标向右移动
imap <c-l> <Right>

" 标签页跳转
map <leader>tn :tabn<cr>
map <leader>tp :tabp<cr>
map <leader>tc :tabclose<cr>
map <leader>to :tabonly<cr>

" tag跳转
map <leader>tgp :tprevious<cr>
map <leader>tgn :tnext<cr>

" tabular
map <leader>t-  :Tab /--<cr>
map <leader>t/  :Tab /\/\/<cr>
map <leader>t#  :Tab /#<cr>
map <leader>t"  :Tab /"<cr>
map <leader>t;  :Tab /;<cr>
map <leader>t=  :Tab /=<cr>

" 启用每行超过80列的字符提示（字体变蓝并加下划线），不启用就注释掉
"au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 100 . 'v.\+', -1)
" au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

set colorcolumn=81
"------------------------------自定义操作-----------------------------------------------
"
" -----------------------------------------------------------------------------
"  < 界面配置 >
" -----------------------------------------------------------------------------
set number                                            "显示行号
set relativenumber                                    " 相对行号
set laststatus=2                                      "启用状态栏信息
set cmdheight=2                                       "设置命令行的高度为2，默认为1
set cursorline                                        "突出显示当前行
if g:iswindows
    set guifont=Consolas:h10
    " set guifont=Ubuntu_Mono:h13
else
    set guifont=Ubuntu\ Mono\ 13
endif
"set nowrap                                            "设置不自动换行
set shortmess=atI                                     "去掉欢迎界面
set gcr=a:block-blinkon0                              "禁止光标闪烁
"set gcr=a:block-blinkon500
set novisualbell                                        " 不要闪烁 
" 设置 gVim 窗口初始位置及大小
if g:isGUI
    au GUIEnter * simalt ~x                           "窗口启动时自动最大化
    winpos 100 10                                     "指定窗口出现的位置，坐标原点在屏幕左上角
    set lines=38 columns=120                          "指定窗口大小，lines为高度，columns为宽度
endif

" 设置代码配色方案
if g:isGUI
    colorscheme hybrid_material
    set background=dark
else
    " colorscheme hybrid_material
    colorscheme elflord
    set background=light
endif

" 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
if g:isGUI
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    map <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
        \set guioptions-=m <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=r <Bar>
        \set guioptions-=L <Bar>
    \else <Bar>
        \set guioptions+=m <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=r <Bar>
        \set guioptions+=L <Bar>
    \endif<CR>
endif

" C++中的public缩进
set cinoptions=g0

" -----------------------------------------------------------------------------
"  < 其它配置 >
" -----------------------------------------------------------------------------
set writebackup                             "保存文件前建立备份，保存成功后删除该备份
set nobackup                                "设置无备份文件
set noswapfile                              "设置无临时文件
set noundofile                              "设置无undo文件

" 设置txt后缀名文件类型为lua
" au BufNewFile,BufRead *.txt set filetype=lua

" 打开chrome预览Markdown文档
autocmd BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} map <Leader>c :!start "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "%:p"<CR>

" =============================================================================
"                          << 以下为常用插件配置 >>
" =============================================================================
" -----------------------------------------------------------------------------
"  < a.vim 插件配置 >
" -----------------------------------------------------------------------------
" 用于切换C/C++头文件
" :A     ---切换头文件并独占整个窗口
" :AV    ---切换头文件并垂直分割窗口
" :AS    ---切换头文件并水平分割窗口

" -----------------------------------------------------------------------------
"  < Align 插件配置 >
" -----------------------------------------------------------------------------
" 一个对齐的插件，用来——排版与对齐代码，功能强大，不过用到的机会不多

" -----------------------------------------------------------------------------
"  < auto-pairs 插件配置 >
" -----------------------------------------------------------------------------
" 用于括号与引号自动补全，不过会与函数原型提示插件echofunc冲突
" 所以我就没有加入echofunc插件

" -----------------------------------------------------------------------------
"  < ccvext.vim 插件配置 >
" -----------------------------------------------------------------------------
" 用于对指定文件自动生成tags与cscope文件并连接
" 如果是Windows系统, 则生成的文件在源文件所在盘符根目录的.symbs目录下(如: X:\.symbs\)
" 如果是Linux系统, 则生成的文件在~/.symbs/目录下
" 具体用法可参考www.vim.org中此插件的说明
" <Leader>sy 自动生成tags与cscope文件并连接
" <Leader>sc 连接已存在的tags与cscope文件

" UltiSnips
let g:UltiSnipsExpandTrigger=";s"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" -----------------------------------------------------------------------------
"  < ctrlp.vim 插件配置 >
" -----------------------------------------------------------------------------
" 一个全路径模糊文件，缓冲区，最近最多使用，... 检索插件；详细帮助见 :h ctrlp
" 常规模式下输入：Ctrl + p 调用插件
" -----------------------------------------------------------------------------
let g:ctrlp_map = '<leader>p'
let g:ctrlp_max_files=0
let g:ctrlp_by_filename = 1
let g:ctrlp_follow_symlinks=1
let g:ctrlp_open_new_file = 't'
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(exe|so|dll)$',
            \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
            \ }
" customize the mappings in CtrlP's prompt
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': ['<c-t>'],
  \ 'AcceptSelection("t")': ['<cr>']
  \ }

"  < indentLine 插件配置 >
" -----------------------------------------------------------------------------
" 用于显示对齐线，与 indent_guides 在显示方式上不同，根据自己喜好选择了
" 在终端上会有屏幕刷新的问题，这个问题能解决有更好了
" 开启/关闭对齐线
nmap <leader>il :IndentLinesToggle<CR>
let g:indentLine_enabled = 0

" 设置Gvim的对齐线样式
if g:isGUI
    let g:indentLine_char = "|"
    let g:indentLine_first_char = "|"
    " let g:indentLine_char = "┊"
    " let g:indentLine_first_char = "┊"
endif

" 设置终端对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
let g:indentLine_color_term = 239

" 设置 GUI 对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
let g:indentLine_color_gui = '#A4E57E'

" < ag.vim 插件设置 >
let g:ag_prg="ag --vimgrep"
let g:ag_working_path_mode="r"
nmap <leader>ag :Ag <C-R>=expand("<cword>")<CR><CR>

" < h2cppx 插件设置 >
let g:h2cppx_postfix = 'cpp'
let g:h2cppx_template = 'template4' 

" source %
map <F5>    :source %<ESC>

" -----------------------------------------------------------------------------
"  < Mark--Karkat（也就是 Mark） 插件配置 >
" -----------------------------------------------------------------------------
" 给不同的单词高亮，表明不同的变量时很有用，详细帮助见 :h mark.txt
let g:mwDefaultHighlightingPalette = 'extended' 
lef g:mwDefaultHighlightingNum = 20

"Default colors/groups
"You may define your own colors in you vimrc file, in the form as below:
"
hi MarkWord7  ctermbg=Blue     ctermfg=Black  guibg=#FF0000    guifg=Black
hi MarkWord8  ctermbg=Blue     ctermfg=Black  guibg=#00FF00    guifg=Black
hi MarkWord9  ctermbg=Blue     ctermfg=Black  guibg=#0000FF    guifg=Black
hi MarkWord10  ctermbg=Blue     ctermfg=Black  guibg=#F000F0    guifg=Black
hi MarkWord11  ctermbg=Blue     ctermfg=Black  guibg=#F0F00F    guifg=Black
hi MarkWord12  ctermbg=Blue     ctermfg=Black  guibg=#BAA00F    guifg=Black

" 在不使用 MiniBufExplorer 插件时也可用<C-k,j,h,l>切换到上下左右的窗口中去
noremap <c-k> <c-w>k
noremap <c-j> <c-w>j
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" -----------------------------------------------------------------------------
"  < BufExplorer 插件配置 >
" -----------------------------------------------------------------------------
let g:bufExplorerDefaultHelp=0       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitHorzSize=30    " New split window is n rows high.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Config Winmanager
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:winManagerWindowLayout="BufExplorer|Tagbar"
" let g:winManagerWidth=30

" nmap <C-m> :WMToggle<CR>

" function! NERDTree_Start()  
    " exec 'NERDTree'  
" endfunction

" function! NERDTree_IsValid()  
    " return 1  
" endfunction

" let g:NERDTree_title="[NERDTree]"
" noremap <f5> :NERDTreeFind<cr>

" let g:Tagbar_title = "[Tagbar]"
" let g:tagbar_vertical = 30
" function! Tagbar_Start()
    " exe 'q' "执行一个退出命令，关闭自动出现的窗口"
    " exe 'TagbarOpen'
" endfunction
 
" function! Tagbar_IsValid()
    " return 1
" endfunction

" -----------------------------------------------------------------------------
"  < nerdcommenter 插件配置 >
" -----------------------------------------------------------------------------
" 我主要用于C/C++代码注释(其它的也行)
" 以下为插件默认快捷键，其中的说明是以C/C++为例的，其它语言类似
" <Leader>ci 以每行一个 /* */ 注释选中行(选中区域所在行)，再输入则取消注释
" <Leader>cm 以一个 /* */ 注释选中行(选中区域所在行)，再输入则称重复注释
" <Leader>cc 以每行一个 /* */ 注释选中行或区域，再输入则称重复注释
" <Leader>cu 取消选中区域(行)的注释，选中区域(行)内至少有一个 /* */
" <Leader>ca 在/*...*/与//这两种注释方式中切换（其它语言可能不一样了）
" <Leader>cA 行尾注释
let NERDSpaceDelims = 1                     "在左注释符之后，右注释符之前留有空格

" -----------------------------------------------------------------------------
"  < nerdtree 插件配置 >
" -----------------------------------------------------------------------------
" 有目录村结构的文件浏览插件
" NerdTree use <F2>
let NERDTreeWinPos='left'
let NERDTreeWinSize=35
let NERDTreeChDirMode=1

nmap <leader>f :NERDTreeFind<CR>    " reveal file in tree
nmap <leader>tt :NERDTreeToggle<CR> " Toggle NERDTree

" -----------------------------------------------------------------------------
"  < omnicppcomplete 插件配置 >
" -----------------------------------------------------------------------------
" 用于C/C++代码补全，这种补全主要针对命名空间、类、结构、共同体等进行补全，详细
" 说明可以参考帮助或网络教程等
" 使用前先执行如下 ctags 命令（本配置中可以直接使用 ccvext 插件来执行以下命令）
" ctags -R --c++-kinds=+p --fields=+iaS --extra=+q
" 我使用上面的参数生成标签后，对函数使用跳转时会出现多个选择
" 所以我就将--c++-kinds=+p参数给去掉了，如果大侠有什么其它解决方法希望不要保留呀
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
set completeopt=menu                        "关闭预览窗口
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["_GLIBCXX_STD"]

" vim-lua-ftplugin
let g:lua_complete_omni = 1

" -----------------------------------------------------------------------------
"  < powerline 插件配置 >
" -----------------------------------------------------------------------------
" 状态栏插件，更好的状态栏效果

" -----------------------------------------------------------------------------
"  < repeat 插件配置 >
" -----------------------------------------------------------------------------
" 主要用"."命令来重复上次插件使用的命令

" -----------------------------------------------------------------------------
"  < snipMate 插件配置 >
" -----------------------------------------------------------------------------
" 用于各种代码补全，这种补全是一种对代码中的词与代码块的缩写补全，详细用法可以参
" 考使用说明或网络教程等。不过有时候也会与 supertab 插件在补全时产生冲突，如果大
" 侠有什么其它解决方法希望不要保留呀

" -----------------------------------------------------------------------------
"  < std_c 插件配置 >
" -----------------------------------------------------------------------------
" 用于增强C语法高亮

" 启用 // 注释风格
let c_cpp_comments = 0

" -----------------------------------------------------------------------------
"  < surround 插件配置 >
" -----------------------------------------------------------------------------
" 快速给单词/句子两边增加符号（包括html标签），缺点是不能用"."来重复命令
" 不过 repeat 插件可以解决这个问题，详细帮助见 :h surround.txt

" -----------------------------------------------------------------------------
"  < Syntastic 插件配置 >
" -----------------------------------------------------------------------------
" 用于保存文件时查检语法

" -----------------------------------------------------------------------------
"  < Tagbar 插件配置 >
" -----------------------------------------------------------------------------
" 相对 TagList 能更好的支持面向对象

" 常规模式下输入 tb 调用插件，如果有打开 TagList 窗口则先将其关闭
nmap tb :TagbarToggle<CR>

let g:tagbar_left = 0
let g:tagbar_width=25                       "设置窗口宽度
let g:tagbar_autoclose=0                    "自动折叠

" -----------------------------------------------------------------------------
"  < txtbrowser 插件配置 >
" -----------------------------------------------------------------------------
" 用于文本文件生成标签与与语法高亮（调用TagList插件生成标签，如果可以）
"au BufRead,BufNewFile *.txt setlocal ft=txt

"-------------------------------------------------------------
" < YouCompleteMe补全插件 >
"-------------------------------------------------------------
" set runtimepath+=H:/Program\ Files/gvim/vimfiles/bundle/YouCompleteMe

if (has('win32'))
    let g:ycm_global_ycm_extra_conf = '$VIM/vimfiles/bundle/YouCompleteMe/python/ycm/.ycm_extra_conf.py'
else
    let g:ycm_global_ycm_extra_conf = '$VIM/bundle/YouCompleteMe/python/ycm/.ycm_extra_conf.py'
endif

let g:ycm_complete_in_comments=1                    " 补全功能在注释中同样有效
let g:ycm_complete_in_strings=1
let g:ycm_confirm_extra_conf=0                      " 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
let g:ycm_collect_identifiers_from_tags_files=1     " 开启 YCM 基于标签引擎
let g:ycm_filetype_whitelist = { 'c' : 1, 'cpp': 1, 'lua' : 1, 'python' : 1 }
let g:ycm_min_num_of_chars_for_completion=1         " 从第一个键入字符就开始罗列匹配项
let g:ycm_cache_omnifunc=0                          " 禁止缓存匹配项，每次都重新生成匹配项
let g:ycm_register_as_syntastic_checker = 1         " default 1， 设置为1后无法使用语法检查插件syntastic
let g:Show_diagnostics_ui = 1                       " default 1
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1         " default 0
let g:ycm_open_loclist_on_ycm_diags = 1             " default 1
let g:ycm_seed_identifiers_with_syntax=1            " 语法关键字补全            
let g:ycm_key_invoke_completion = '<M-;>'           " 修改对C函数的补全快捷键为ALT + ;
let g:ycm_error_symbol = '>>'                       " 语法错误提示符
let g:ycm_warning_symbol = '>*'                     " 语法警告提示符
set tags+=stdcpp.tags " 引入 C++ 标准库tags
set completeopt-=preview                            " 补全内容不以分割子窗口形式出现，只显示补全列表
inoremap <leader>; <C-x><C-o>                       " OmniCppComplete 快捷键

" 设置快捷键前缀为ALT
nmap <M-d> :YcmShowDetailedDiagnostic<cr>           
nmap <M-g> :YcmCompleter GoToDefinitionElseDeclaration <C-R>=expand("<cword>")<CR><CR>
nmap <M-l> :YcmCompleter GoToDeclaration <C-R>=expand("<cword>")<CR><CR>
nmap <M-f> :YcmCompleter GoToDefinition <C-R>=expand("<cword>")<CR><CR>

let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11"}

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>

" =============================================================================
"                          << 以下为常用工具配置 >>
" =============================================================================

" Quickfix配置
nmap <silent> <C-N> :cn<CR>zv
nmap <silent> <C-P> :cp<CR>zv

" -----------------------------------------------------------------------------
"  < cscope 工具配置 >
" -----------------------------------------------------------------------------
" 用Cscope自己的话说 - "你可以把它当做是超过频的ctags"
if has("cscope")
    " set csprg=gtags-cscope               " 使用gtags-cscope
set csprg=cscope                     " 使用cscope
    set cscopequickfix=s-,c-,d-,i-,t-,e- " 设定可以使用 quickfix 窗口来查看 cscope 结果
    set cscopetag                        " 使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳转
    set csto=0                           " 如果你想反向搜索顺序设置为1
    set cscopeverbose

    " 在当前目录中添加任何数据库
    if filereadable("cscope.out")
        silent! execute "cs add cscope.out"
    elseif $CSCOPE_DB != ""              " 否则添加数据库环境中所指出的
        silent exe "cs add $CSCOPE_DB"
    endif

    " 快捷键设置
    " 0 or s: Find this C symbol
    " 1 or g: Find this definition
    " 2 or d: Find functions called by this function
    " 3 or c: Find functions calling this function
    " 4 or t: Find this text string
" 6 or e: Find this egrep pattern
    " 7 or f: Find this file
    " 8 or i: Find files #including this file
    nmap <leader><leader>gs :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <leader><leader>gg :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader><leader>gc :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <leader><leader>gt :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <leader><leader>ge :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <leader><leader>gf :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <leader><leader>gi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <leader><leader>gd :cs find d <C-R>=expand("<cword>")<CR><CR>

    nmap <leader><leader>cs :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <leader><leader>cg :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader><leader>cc :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <leader><leader>ct :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <leader><leader>ce :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <leader><leader>cf :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <leader><leader>ci :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <leader><leader>cd :scs find d <C-R>=expand("<cword>")<CR><CR>
endif

func! CscopeBuild()
    if(has('win32'))
        silent! execute "!dir /b *.c,*.cpp,*.cc,*.h,*.java,*.cs,*.lua,*.txt,*.py > cscope.files"
    else
        silent! execute "!find . -name \"*.[hcm]\" -o -name \".hpp\" -o -name \"*.cpp\" -o -name \"*.cc\" -o -name \"*.mm\" -o -name \"*.java\" -o -name \"*.py\" -o -name \"*.lua\" > cscope.files"
    endif

    silent! exe "!cscope -Rbkq"
    if filereadable("cscope.out")
        silent! execute "cs kill cscope.out"
        silent! execute "cs add cscope.out"
    endif
endfunc

map <S-C> <Esc>:call CscopeBuild()<CR>

" -----------------------------------------------------------------------------
"  < ctags 工具配置 >
" -----------------------------------------------------------------------------
" 对浏览代码非常的方便,可以在函数,变量之间跳转等
set tags+=tags;                            "向上级目录递归查找tags文件（好像只有在Windows下才有用）
"set tags+=./addtags/qt5_h
"set tags+=./addtags/cpp_stl
"set tags+=./addtags/qt5_cpp

" =============================================================================
"                          << 以下为常用自动命令配置 >>
" =============================================================================

" 自动切换目录为当前编辑文件所在目录
"au BufRead,BufNewFile,BufEnter * cd %:p:h

" =============================================================================
"                     << windows 下解决 Quickfix 乱码问题 >>
" =============================================================================
" windows 默认编码为 cp936，而 Gvim(Vim) 内部编码为 utf-8，所以常常输出为乱码
" 以下代码可以将编码为 cp936 的输出信息转换为 utf-8 编码，以解决输出乱码问题
" 但好像只对输出信息全部为中文才有满意的效果，如果输出信息是中英混合的，那可能
" 不成功，会造成其中一种语言乱码，输出信息全部为英文的好像不会乱码
" 如果输出信息为乱码的可以试一下下面的代码，如果不行就还是给它注释掉

if g:iswindows
    function! QfMakeConv()
        let qflist = getqflist()
        for i in qflist
           let i.text = iconv(i.text, "cp936", "utf-8")
        endfor
        call setqflist(qflist)
     endfunction
     au QuickfixCmdPost make call QfMakeConv()
endif

" =============================================================================
"                          << 其它 >>
" =============================================================================

" 注：上面配置中的"<Leader>"在本软件中设置为"\"键（引号里的反斜杠），如<Leader>t
" 指在常规模式下按"\"键加"t"键，这里不是同时按，而是先按"\"键后按"t"键，间隔在一
" 秒内，而<Leader>cs是先按"\"键再按"c"又再按"s"键
