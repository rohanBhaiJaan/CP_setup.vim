if exists("g:CP_setup")
    finish
endif

let g:CP_setup = 1

set autoread

if ! exists("g:setup_change_to_current_file")
    let g:setup_change_to_current_file = 0
endif

augroup CP
    autocmd!
    autocmd FILETYPE c,h,cpp nnoremap <leader>s :call setup#SplitSetupForCPP()<CR>
    autocmd FILETYPE c,h,cpp nnoremap <leader>r :call setup#RunCode()<CR>
    autocmd FILETYPE c,h,cpp nnoremap <leader>cr :call setup#CompileAndRun()<CR>
    autocmd BufEnter *.c,*.h,*.cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufEnter *.cpp,*.c if g:setup_change_to_current_file == 1 | call setup#swapCompileAndRunFile() | endif
augroup END

