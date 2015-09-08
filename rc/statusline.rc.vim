"---------------------------------------------------------------------------
" StatusLine:
"

if HasPlugin('lightline') | finish | endif

let g:hi_insert = 'highlight StatusLine ctermfg=red ctermbg=yellow cterm=NONE guifg=red guibg=yellow'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''

function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

" See: http://qiita.com/kotashiratsuka/items/dcd1f4231385dc9c78e7
" ステータスラインにコマンドを表示
set showcmd
" ステータスラインを常に表示
set laststatus=2
" ファイルナンバー表示
set statusline=[%n]
" ファイル名表示
set statusline+=%<%t:
" 検索ヒット数
set statusline+=%{anzu#search_status()}
" git branch
if HasPlugin('fugitive')
  set statusline+=%{fugitive#statusline()}
endif
" 構文チェック
if HasPlugin('syntastic')
  set statusline+=%{SyntasticStatuslineFlag()}
endif
" 変更のチェック表示
set statusline+=%m
" 読み込み専用かどうか表示
set statusline+=%r
" プレビューウインドウなら[Prevew]と表示
set statusline+=%w
" ここからツールバー右側
set statusline+=%=
" ファイルタイプ表示
set statusline+=%y
" 文字バイト数/カラム番号
" set statusline+=[ASCII=%B]
" 現在文字列/全体列表示
set statusline+=[C=%c/%{col('$')-1}]
" 現在文字行/全体行表示
set statusline+=[L=%l/%L]
" 現在行が全体行の何%目か表示
set statusline+=[%p%%]
