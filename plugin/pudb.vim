" File: pudb.vim
" Author: Christophe Simonis
" Description: Manage pudb breakpoints directly into vim
" Last Modified: December 03, 2012
"

if exists('g:loaded_pudb_plugin') || &cp
    finish
endif
let g:loaded_pudb_plugin = 1

if !has("python")
    echo "Error: Required vim compiled with +python"
    finish
endif

sign define PudbBreakPoint text=Ø) texthl=error

let s:first_sign_id = 10000
let s:next_sign_id = s:first_sign_id

augroup pudb
    autocmd BufReadPost *.py call s:UpdateBreakPoints()
augroup end

command! TogglePudbBreakPoint call s:ToggleBreakPoint()

function! s:UpdateBreakPoints()

" first remove existing signs
if !exists("b:pudb_sign_ids")
    let b:pudb_sign_ids = []
endif

for i in b:pudb_sign_ids
    exec "sign unplace " . i
endfor
let b:pudb_sign_ids = []


python << EOF
import vim
from pudb.settings import load_breakpoints
from pudb import NUM_VERSION

filename = vim.eval('expand("%:p")')

args = () if NUM_VERSION >= (2013, 1) else (None,)
bps = load_breakpoints(*args)

for bp in bps:
    if bp[0] != filename:
        continue

    sign_id = vim.eval("s:next_sign_id")
    vim.command("sign place %s line=%s name=PudbBreakPoint file=%s" % (sign_id, bp[1], filename))
    vim.eval("add(b:pudb_sign_ids, s:next_sign_id)")
    vim.command("let s:next_sign_id += 1")
EOF

endfunction

function! s:ToggleBreakPoint()
python << EOF
import vim
from pudb.settings import load_breakpoints, save_breakpoints
from pudb import NUM_VERSION

args = () if NUM_VERSION >= (2013, 1) else (None,)
bps = [bp[:2] for bp in load_breakpoints(*args)]

filename = vim.eval('expand("%:p")')
row, col = vim.current.window.cursor

bp = (filename, row)
if bp in bps:
    bps.pop(bps.index(bp))
else:
    bps.append(bp)

class BP(object):
    def __init__(self, fn, ln, cond=None):
        self.file = fn
        self.line = ln
        self.cond = cond

bp_list = [BP(bp[0], bp[1]) for bp in bps]

save_breakpoints(bp_list)

vim.command('call s:UpdateBreakPoints()')
EOF
endfunction

