vim-pudb
========

simple plugin allowing you to manage pudb breakpoint directly into vim.

This plugin need vim to be compiled with +python

Installation
============

The recommended way of installing is to use `vim-pathogen`_


How to use
==========
To add/remove a breakpoint, you just need to call the command ``:TogglePudbBreakPoint``

For easy access, you can bind it to the F8 key.


    ``nnoremap <F8> :TogglePudbBreakPoint<CR>``

    ``inoremap <F8> <ESC>:TogglePudbBreakPoint<CR>a``

    ``nmap <S-F8> <ESC>:!pudb %<CR>a``

.. _vim-pathogen: https://github.com/tpope/vim-pathogen#readme

Know problems
=============
Currently, the list of breakpoints is not reloaded automatically. 

There is also room for speed optimisations.
