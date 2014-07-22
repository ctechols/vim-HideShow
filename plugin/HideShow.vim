command! -bang -nargs=1 Hide call <SID>Hide('<bang>', <q-args>)
command! -bang -nargs=1 Show call <SID>Show('<bang>', <q-args>)
command! -nargs=0 ShowAll call <SID>DisableHideShow()

function! s:Show(bang, ...)
   if(!exists("b:patterns") || (a:bang == "!"))
      let b:patterns = []
   endif
   if(!exists("b:defaultAction") || (a:bang == "!"))
      let b:defaultAction = "hide"
   endif
   let pattern = {"pattern": a:1, "action": "show"}
   let b:patterns = add(b:patterns, pattern)
   call s:EnableHideShow()
endfunction

function! s:Hide(bang, ...)
   if(!exists("b:patterns") || (a:bang == "!"))
      let b:patterns = []
   endif
   if(!exists("b:defaultAction") || (a:bang == "!"))
      let b:defaultAction = "show"
   endif
   let pattern = {"pattern": a:1, "action": "hide"}
   let b:patterns = add(b:patterns, pattern)
   call s:EnableHideShow()
endfunction

function! s:DisableHideShow()
   if(exists("b:localFoldMethod"))
      let &l:foldmethod = b:localFoldMethod
   endif
   if(exists("b:localFoldExpr"))
      let &l:foldexpr = b:localFoldExpr
   endif
   if(exists("b:localFoldLevel"))
      let &l:foldlevel = b:localFoldLevel
   endif
   if(exists("b:localFoldMinLines"))
      let &l:foldminlines = b:localFoldMinLines
   endif
   if(exists("b:localFoldnestMax"))
      let &l:foldnestmax = b:localFoldnestMax
   endif
   if(exists("b:localFoldEnable"))
      let &l:foldenable = b:localFoldEnable
   endif
   if(exists("b:defaultAction"))
      unlet b:defaultAction
   endif
   if(exists("b:patterns"))
      unlet b:patterns
   endif
   silent! normal zE
endfunction

function! s:EnableHideShow()

   "Make copies of the global & local options that will be changed.
   if(!exists("b:localFoldMethod"))
      let b:localFoldMethod = &l:foldmethod
   endif
   if(!exists("b:localFoldExpr"))
      let b:localFoldExpr = &l:foldexpr
   endif
   if(!exists("b:localFoldLevel"))
      let b:localFoldLevel = &l:foldlevel
   endif
   if(!exists("b:localFoldMinLines"))
      let b:localFoldMinLines = &l:foldminlines
   endif
   if(!exists("b:localFoldnestMax"))
      let b:localFoldnestMax = &l:foldnestmax
   endif
   if(!exists("b:localFoldEnable"))
      let b:localFoldEnable = &l:foldenable
   endif

   setlocal foldmethod=expr
   setlocal foldexpr=HideShowFoldExpr(getline(v:lnum))
   setlocal foldlevel=0
   setlocal foldminlines=1
   setlocal foldnestmax=20
   setlocal foldenable

   if(&l:foldmethod == 'manual')
      normal zE
   endif
endfunction

function! HideShowFoldExpr(text)
   if((!exists("b:patterns")) || (!exists("b:defaultAction")))
      return 0
   endif
   let action = b:defaultAction
   for pattern in b:patterns
      if a:text =~ pattern["pattern"]
         let action = pattern["action"]
      endif
   endfor
   if( action == "hide" )
      return 1
   else
      return 0
   endif
endfunction

