scriptencoding utf-8

set clipboard=unnamed

if has("gui_win32")
	set shell=C:\WINDOWS\system32\cmd.exe
endif


let $VIM_NEOBUNDLE_PLUGIN_DIR = "~/.vim/bundle"

if has("win32")
	let $VIM_CPP_STDLIB = "C:/MinGW/lib/gcc/mingw32/4.8.2/include/c++"
endif

let $VIM_CPP_INCLUDE_DIR = ""


setlocal tabstop=4
setlocal shiftwidth=4

setlocal noexpandtab

setlocal nocindent
set nocompatible
set nobackup
set noswapfile
set nowritebackup
set number
set virtualedit=all
set ignorecase
set smartcase
set incsearch
set hlsearch
set infercase
set hidden
set switchbuf=useopen
set showmatch
set matchtime=3
set t_vb= 
set novisualbell
set mouse=a
set matchpairs& matchpairs+=<:>
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~
set matchtime=0
set updatetime=1000
set noundofile
"for key maps functions

"key maps
nnoremap <buffer><silent> <Space>ii :execute "?".&include<CR> :noh<CR> o
nnoremap j gj
nnoremap k gk

if !exists('g:quickrun_config')
	let g:quickrun_config = {}
endif

let g:quickrun_config.runner = "wandbox"

function! s:cpp()
	let &l:path = join(filter(split($VIM_CPP_STDLIB . "," . $VIM_CPP_INCLUDE_DIR,"[,;]"i,"isdirectory(v:val)"),",")
	setlocal matchpairs+=<:>

	let b:quickrun_config = {
		"hook/add_include_option/enable":1
	}
endfunction

let s:neobundle_plugins_dir = expand(exists("$VIM_NEOBUNDLE_PLUGIN_DIR") ? $VIM_NEOBUNDLE_PLUGIN_DIR : "~/.vim/bundle")


let s:cpp_include_dirs = expand(exists("$VIM_CPP_INCLUDE_DIR") ? $VIM_CPP_INCLUDE_DIR : '')


 " shell の設定
if has('win95') || has('win16') || has('win32')
	set shell=C:\WINDOWS\system32\cmd.exe
endif

 " プラグインの読み込み
if !executable("git")
	echo "Please install git."
	finish
endif
 
 
if !isdirectory(s:neobundle_plugins_dir . "/neobundle.vim")
	echo "Please install neobundle.vim."
	function! s:install_neobundle()
		if input("Install neobundle.vim? [Y/N] : ") =="Y"
			if !isdirectory(s:neobundle_plugins_dir)
				call mkdir(s:neobundle_plugins_dir, "p")
			endif

			execute "!git clone git://github.com/Shougo/neobundle.vim "
			\ . s:neobundle_plugins_dir . "/neobundle.vim"
			echo "neobundle installed. Please restart vim."
		else
			echo "Canceled."
		endif
	endfunction
	augroup install-neobundle
		autocmd!
		autocmd VimEnter * call s:install_neobundle()
	augroup END
	finish
endif

if has('vim_starting')
	execute "set runtimepath+=" . s:neobundle_plugins_dir . "/neobundle.vim"
endif

call neobundle#begin(s:neobundle_plugins_dir)
  

NeoBundleFetch "Shougo/neobundle.vim"
NeoBundle "tyru/caw.vim"
NeoBundle "Shogo/neocomplete.vim"
NeoBundle "Shougo/neosnippet.vim"
NeoBundle "Shougo/neosnippet-snippets"
NeoBundle "Shougo/unite-outline"
NeoBundle "vim-jp/cpp-vim"
NeoBundle "rhysd/wandbox-vim"
NeoBundle "osyo-manga/vim-marching"
NeoBundle "thinca/vim-quickrun"
NeoBundle "jceb/vim-hier"
NeoBundle "dannyob/quickfixstatus"
NeoBundle "osyo-manga/vim-watchdogs"
NeoBundle "osyo-manga/shabadou.vim"
NeoBundle "t9md/vim-quickhl"
if !has("kaoriya")
	NeoBundle 'Shougo/vimproc.vim', {
	\ 'build' : {
	\     'windows' : 'make -f make_mingw32.mak',
	\     'cygwin' : 'make -f make_cygwin.mak',
	\     'mac' : 'make -f make_mac.mak',
	\     'unix' : 'make -f make_unix.mak',
	\    },
	\ }
endif

call neobundle#end() 

filetype plugin indent on
syntax enable

NeoBundleCheck

 
" caw.vim
let s:hooks = neobundle#get_hooks("caw.vim")
function! s:hooks.on_source(bundle)
	" コメントアウトを切り替えるマッピング
	" <leader>c でカーソル行をコメントアウト
	" 再度 <leader>c でコメントアウトを解除
	" 選択してから複数行の <leader>c も可能
	nmap <leader>c <Plug>(caw:I:toggle)
	vmap <leader>c <Plug>(caw:I:toggle)

	" <leader>C でコメントアウトを解除
	nmap <Leader>C <Plug>(caw:I:uncomment)
	vmap <Leader>C <Plug>(caw:I:uncomment)

endfunction
unlet s:hooks
 
 " neocomplet.vim
let s:hooks = neobundle#get_hooks("neocomplete.vim")
function! s:hooks.on_source(bundle)
	" 補完を有効にする
	let g:neocomplete#enable_at_startup = 1

	" 補完に時間がかかってもスキップしない
	let g:neocomplete#skip_auto_completion_time = ""
endfunction
unlet s:hooks


" neocomplcache
let s:hooks = neobundle#get_hooks("neocomplcache")
function! s:hooks.on_source(bundle)
	" 補完を有効にする
	let g:neocomplcache_enable_at_startup=1
endfunction
unlet s:hooks


" quickfixstatus
let s:hooks = neobundle#get_hooks("quickfixstatus")
function! s:hooks.on_post_source(bundle)
	QuickfixStatusEnable
endfunction
unlet s:hooks


" vim-quickhl
let s:hooks = neobundle#get_hooks("vim-quickhl")
function! s:hooks.on_source(bundle)
	" <Space>m でカーソル下の単語、もしくは選択した範囲のハイライトを行う
	" 再度 <Space>m を行うとカーソル下のハイライトを解除する
	" これは複数の単語のハイライトを行う事もできる
	" <Space>M で全てのハイライトを解除する
	nmap <Space>m <Plug>(quickhl-manual-this)
	xmap <Space>m <Plug>(quickhl-manual-this)
	nmap <Space>M <Plug>(quickhl-manual-reset)
	xmap <Space>M <Plug>(quickhl-manual-reset)
endfunction
unlet s:hooks


" neosnippet.vim
let s:hooks = neobundle#get_hooks("neosnippet.vim")
function! s:hooks.on_source(bundle)
	" スニペットを展開するキーマッピング
	" <Tab> で選択されているスニペットの展開を行う
	" 選択されている候補がスニペットであれば展開し、
	" それ以外であれば次の候補を選択する
	" また、既にスニペットが展開されている場合は次のマークへと移動する
	imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)"
	\: pumvisible() ? "\<C-n>" : "\<TAB>"
	smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)"
	\: "\<TAB>"

	let g:neosnippet#snippets_directory = "~/.neosnippet"

	" 現在の filetype のスニペットを編集する為のキーマッピング
	" こうしておくことでサッと編集や追加などを行うことができる
	" 以下の設定では新しいタブでスニペットファイルを開く
	nnoremap <Space>ns :execute "tabnew\|:NeoSnippetEdit ".&filetype<CR>
endfunction
unlet s:hooks


" marching.vim
let s:hooks = neobundle#get_hooks("vim-marching")
function! s:hooks.on_post_source(bundle)
	if !empty(g:marching_clang_command) && executable(g:marching_clang_command)
		" 非同期ではなくて同期処理で補完する
		let g:marching_backend = "sync_clang_command"
	else
		" clang コマンドが実行できなければ wandbox を使用する
		let g:marching_backend = "wandbox"
		let g:marching_clang_command = ""
	endif

	" オプションの設定
	" これは clang のコマンドに渡される
	let g:marching#clang_command#options = {
	\	"cpp" : "-std=gnu++1y"
	\}


	if !neobundle#is_sourced("neocomplete.vim")
		return
	endif

	" neocomplete.vim と併用して使用する場合
	" neocomplete.vim を使用すれば自動補完になる
	let g:marching_enable_neocomplete = 1

	if !exists('g:neocomplete#force_omni_input_patterns')
		let g:neocomplete#force_omni_input_patterns = {}
	endif

	let g:neocomplete#force_omni_input_patterns.cpp =
		\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
	endfunction
unlet s:hooks


" quickrun.vim
let s:hooks = neobundle#get_hooks("vim-quickrun")
function! s:hooks.on_source(bundle)
	let g:quickrun_config = {
\		"_" : {
\			"runner" : "vimproc",
\			"runner/vimproc/sleep" : 10,
\			"runner/vimproc/updatetime" : 500,
\			"outputter" : "error",
\			"outputter/error/success" : "buffer",
\			"outputter/error/error"   : "quickfix",
\			"outputter/quickfix/open_cmd" : "copen",
\			"outputter/buffer/split" : ":botright 8sp",
\		},
\
\		"cpp/wandbox" : {
\			"runner" : "wandbox",
\			"runner/wandbox/compiler" : "clang-head",
\			"runner/wandbox/options" : "warning,c++1y,boost-1.55",
\		},
\
\		"cpp/g++" : {
\			"cmdopt" : "-std=c++0x -Wall",
\		},
\
\		"cpp/clang++" : {
\			"cmdopt" : "-std=c++0x -Wall",
\		},
\
\		"cpp/watchdogs_checker" : {
\			"type" : "watchdogs_checker/clang++",
\		},
\	
\		"watchdogs_checker/_" : {
\			"outputter/quickfix/open_cmd" : "",
\		},
\	
\		"watchdogs_checker/g++" : {
\			"cmdopt" : "-Wall",
\		},
\	
\		"watchdogs_checker/clang++" : {
\			"cmdopt" : "-Wall",
\		},
\	}

	let s:hook = {
	\	"name" : "add_include_option",
	\	"kind" : "hook",
	\	"config" : {
	\		"option_format" : "-I%s"
	\	},
	\}

	function! s:hook.on_normalized(session, context)
		" filetype==cpp 以外は設定しない
		if &filetype !=# "cpp"
			return
		endif
		let paths = filter(split(&path, ","), "len(v:val) && v:val !='.' && v:val !~ $VIM_CPP_STDLIB")
		
		if len(paths)
			let a:session.config.cmdopt .= " " . join(map(paths, "printf(self.config.option_format, v:val)")) . " "
		endif
	endfunction

	call quickrun#module#register(s:hook, 1)
	unlet s:hook


	let s:hook = {
	\	"name" : "clear_quickfix",
	\	"kind" : "hook",
	\}

	function! s:hook.on_normalized(session, context)
		call setqflist([])
	endfunction

	call quickrun#module#register(s:hook, 1)
	unlet s:hook

endfunction
unlet s:hooks


" vim-watchdogs
let s:hooks = neobundle#get_hooks("vim-watchdogs")
function! s:hooks.on_source(bundle)
	let g:watchdogs_check_BufWritePost_enable = 1
endfunction
unlet s:hooks
 

call neobundle#call_hook('on_source')

augroup vimrc-cpp
	autocmd!
	" filetype=cpp が設定された場合に関数を呼ぶ
	autocmd FileType cpp call s:cpp()
augroup END
 

" vimrc の読み込み
"source <sfile>:h/../external-vimrc/cpp-vimrc/vimrc
