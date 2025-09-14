function! YankToRegister()
  let contents = getline(".")
  call setreg(b:registername, v:lua.vim.api.nvim_replace_termcodes(contents, 1, 0, 1))
endfunction

function! OpenMacroEditorWindow(registername)
  let name = 'MacroEditor'
  if bufexists(name)
    echohl WarningMsg
    echom "One macro at a time:)"
    echohl None
    let win = bufwinnr(name)
    exe printf('%d . wincmd w', win)
    return
  endif
  let height = 3
  execute height 'new ' name
  let b:registername = a:registername
  setlocal bufhidden=wipe noswapfile nobuflisted
  let contents = keytrans(getreg(b:registername))
  exe setline(".", contents)
  set nomodified
  augroup MacroEditor
    au!
    au BufWriteCmd <buffer> call YankToRegister()
    au BufWriteCmd <buffer> set nomodified
  augroup END
endfunction
command! -nargs=1 MacroEdit call OpenMacroEditorWindow("<args>")
