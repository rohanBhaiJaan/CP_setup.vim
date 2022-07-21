let s:cpExt = expand("%:e")
let s:cpFileHeadName = expand('%:t:r')
let s:cpFilePath = expand('%:p')

function! s:error(str) abort
    echohl ErrorMsg
    echomsg a:str
    echohl Normal
endfunction

function! s:exists(file)
    if bufnr(a:file)->win_findbuf()->len() != 0
        return 1
    endif
    return 0
endfunction

function! s:open(file, split) abort
    if ! s:exists(a:file)
        exec printf("silent keepalt %s %s", a:split, a:file)
    else
        call s:error(a:file . " is already open in this buffer")
    endif
endfunction

function! s:close(file)
    if s:exists(a:file)
        exec printf("bd! %s", a:file)
    else
        call s:error(a:file . " is not present in this buffer")
    endif
endfunction

function! s:closeSplit()
    call s:close('~/.compiled/input.in')
    call s:close('~/.compiled/output.in')
endfunction

function! s:createSplit()
    call s:open('~/.compiled/input.in', 'vs') | setlocal filetype=cp_setup
    vertical resize 24 
    call s:open('~/.compiled/output.in', 'sp') | setlocal filetype=cp_setup
endfunction

function! s:notify(str) abort
    if !has('nvim')
        call popup_notification(a:str, #{time: 1000, highlight: "WarningMsg", pos: "center"})
    else
        echo a:str
    endif
endfunction

function! s:executeSetup(compile) abort
    let l:cmd = printf("~/.compiled/%s<~/.compiled/input.in>~/.compiled/output.in", s:cpFileHeadName)
    if a:compile == 1
        let l:compiler = ""
        if s:cpExt == "cpp"
            let l:compiler = "clang++"
        elseif s:cpExt == "c"
            let l:compiler = "clang"
        else
            call s:error("please open c/c++ file")
            return
        endif
        let l:cmd = printf("%s %s -o ~/.compiled/%s 2> ~/.compiled/output.in && %s", l:compiler, s:cpFilePath, s:cpFileHeadName, l:cmd)
    endif
    call system(l:cmd)
    checktime
endfunction

function! setup#SplitSetupForCPP()
    if(! s:exists('~/.compiled/input.in') && ! s:exists('~/.compiled/output.in'))
        call s:createSplit()
    elseif(s:exists('~/.compiled/input.in') || s:exists('~/.compiled/output.in'))
        call s:closeSplit()
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
