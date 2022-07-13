if exists("g:CP_setup")
    finish
endif

let g:CP_setup = 1
set autoread

set autoread

if ! exists("g:setup_change_to_current_file")
    let g:setup_change_to_current_file = 0
endif

augroup CP_SETUP
    autocmd!
    autocmd FILETYPE c,h,cpp,cp_setup nnoremap <buffer> <leader>s :call setup#SplitSetupForCPP()<CR>
    autocmd FILETYPE c,h,cpp,cp_setup nnoremap <buffer> <leader>r :call setup#RunCode()<CR>
    autocmd FILETYPE c,h,cpp,cp_setup nnoremap <buffer> <leader>cr :call setup#CompileAndRun()<CR>
    autocmd FILETYPE c,h,cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufEnter *.cpp,*.c call setup#swapCompileAndRunFile()
augroup END
