#!/usr/bin/env vim -S

""" Flaw in algorithm:
""" class Foo(object):
"""     def bar(self):
"""         pass
"""
"""     class Bing(object):
"""         pass
""" Calling NameOfCurrentFunction in Bing results in 'bar'

function! NameOfCurrentClassOrFunction(type)
  """ Utility function, used for NameOfCurrentFunction and NameOfCurrentClass
  """ functions.
  """ Algorithm:
  """ 1) Get current indentation level of cursor's line
  """ 2) Get indentation of 'one level up' (the above, - vim shift-width)
  """ 3) Find the class/function definition at that level, looking backwards,
  """    including the current line, without wrapping around or moving the
  """    cursor
  """ 4) If extant, parse the class/function name out from that definition.
  execute "normal ^"
  let l:indent_level = col('.') - 1
  let l:shift_width = eval('&sw')
  let l:current_line_not_definition = stridx(getline('.'), a:type + ' ') == -1
  if !l:indent_level && l:current_line_not_definition
      return
  endif
  let l:parent_indent = l:shift_width > l:indent_level ? 0 :
              \         l:indent_level - l:shift_width
  let l:regex = '^ \{' . l:parent_indent . '\}' . a:type . ' \([^(]*\)(.*'
  let l:parent =  search(l:regex, 'bcnW')
  if l:parent
    let l:definition_line = getline(l:parent)
    return substitute(l:definition_line, l:regex, '\1', "")
  endif
endfunction

function! NameOfCurrentFunction()
    """ Determines the name of the function enclosing the cursor's line, if
    """ any.
    return NameOfCurrentClassOrFunction('def')
endfunction

function! NameOfCurrentClass()
    """ Determines the name of the class enclosing the cursor's line, if
    """ any.
    return NameOfCurrentClassOrFunction('class')
endfunction



