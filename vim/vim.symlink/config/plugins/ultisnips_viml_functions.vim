" Utility Functions, Python, Snippets: {{{
" --------------------------------------------------------------------------
function! GetPythonObjectDefinitionInfo (prefix)
    let pattern = '\s*' . a:prefix . ' \([A-Za-z_]\+[0-9A-Za-z_]\+\)(\([^)]*\))'
    let line_num = search(pattern, 'bnW')
    let line = getline(line_num)
    let results = matchlist(line, pattern)
    let [name, signature] = [get(results, 1, ''), get(results, 2, '')]
    return [name, signature]
endfunction

function! GetPythonClassName ()
    return GetPythonObjectDefinitionInfo('class')[0]
endfunction

function! GetPythonFunctionName ()
    return GetPythonObjectDefinitionInfo('def')[0]
endfunction

function! GetPythonClassSignature ()
    return GetPythonObjectDefinitionInfo('class')[1]
endfunction

function! GetPythonFunctionSignature ()
    return GetPythonObjectDefinitionInfo('def')[1]
endfunction
" }}}
" --------------------------------------------------------------------------
