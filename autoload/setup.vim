let s:cpExt = expand("%:e")
let s:cpFileHeadName = expand('%:t:r')
let s:cpFilePath = expand('%:p')

function! s:notify(str) abort
    if !has('nvim')
        call popup_notification(a:str, #{time: 1000, highlight: "WarningMsg", pos: "center"})
    else
        echo a:str
    endif
endfunction

function! s:executeSetup(compile) abort
    let l:cmd = '~/.compiled/'. s:cpFileHeadName .'<~/.compiled/input.in>~/.compiled/output.in'
    if a:compile == 1
        if s:cpExt == "cpp"
            let l:cmd = 'clang++ '.s:cpFilePath.' -o ~/.compiled/'. s:cpFileHeadName .' 2> ~/.compiled/output.in && ' . l:cmd
        elseif s:cpExt == "c"
            let l:cmd = 'clang '.s:cpFilePath.' -o ~/.compiled/'. s:cpFileHeadName .' 2> ~/.compiled/output.in && ' . l:cmd
        endif
    endif
    call system(l:cmd)
    checktime
endfunction

function! s:closeSplitSetupForCP()
    bdelete ~/.compiled/input.in
    bdelete ~/.compiled/output.in
endfunction

function! s:createSplit()
    silent keepalt vs ~/.compiled/input.in | setlocal filetype=cp_setup
    vertical resize 24 
    silent keepalt split ~/.compiled/output.in | setlocal filetype=cp_setup
endfunction

function! setup#SplitSetupForCPP()
    if(winnr('$') <= 2)
        call s:createSplit()
    elseif(bufexists(s:cpFilePath) && (bufnr('~/.compiled/input.in') > 0 || bufnr('~/.compiled/output.in') > 0))
        call s:closeSplitSetupForCP()
    else
        echo "PLESE OPEN CPP FILE "
    endif
endfunction

function! setup#RunCode() abort
    call s:executeSetup(0)
    call s:notify("program terminated")
endfunction

function! setup#CompileAndRun() abort
    call s:executeSetup(1)
    call s:notify("compiled and run completed")
endfunction

function! setup#swapCompileAndRunFile()
    if g:setup_change_to_current_file == 1
        let s:cpFilePath = expand('%:p')
        let s:cpExt = expand('%:e')
        let s:cpFileHeadName = expand("%:t:r")
    endif
endfunction
