let s:cpExt = expand("%:e")

let s:cpFileHeadName = expand('%:t:r')
let s:cpFilePath = expand('%:p')

function! s:closeSplitSetupForCP()
    bdelete ~/.compiled/input.in
    bdelete ~/.compiled/output.in
endfunction

function! setup#SplitSetupForCPP()
    if(winnr('$') <= 2)
        execute 'silent keepalt vs ~/.compiled/input.in | vertical resize 24 | silent keepalt split ~/.compiled/output.in'
    elseif(bufexists(s:cpFilePath) && (bufnr('~/.compiled/input.in') > 0 || bufnr('~/.compiled/output.in') > 0))
        call s:closeSplitSetupForCP()
    else
        echo "PLESE OPEN CPP FILE "
    endif
endfunction

function! setup#RunCode()
    let l:cmd = '~/.compiled/'. s:cpFileHeadName .'<~/.compiled/input.in> ~/.compiled/output.in'
    call system(l:cmd)
    if !has('nvim')
        let notificationWinId = popup_notification("program terminated", #{time: 1000, highlight: "WarningMsg", pos: "center"})
    else
        echo "program terminated "
    endif
endfunction

function! setup#CompileAndRun()
    let l:cmd = ""
    if s:cpExt == "cpp"
        let l:cmd = 'clang++ '.s:cpFilePath.' -o ~/.compiled/'. s:cpFileHeadName .' 2> ~/.compiled/output.in && ~/.compiled/'. s:cpFileHeadName .'<~/.compiled/input.in>~/.compiled/output.in'
    elseif s:cpExt == "c"
        let l:cmd = 'clang '.s:cpFilePath.' -o ~/.compiled/'. s:cpFileHeadName .' 2> ~/.compiled/output.in && ~/.compiled/'. s:cpFileHeadName .'<~/.compiled/input.in>~/.compiled/output.in'
    endif
    call system(l:cmd)
    if !has('nvim')
        let notificationWinId = popup_notification("compiled", #{time: 1000, highlight: "WarningMsg", pos: "center"})
    else
        echo "compiled and run completed"
    endif
    checktime
endfunction

function! setup#swapCompileAndRunFile()
    let s:cpFilePath = expand('%:p') | let s:cpExt = expand('%:e') | let s:cpFileHeadName = expand("%:t:r")
endfunction
