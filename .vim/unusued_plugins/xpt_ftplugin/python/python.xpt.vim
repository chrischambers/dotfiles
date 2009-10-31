if exists("b:__PYTHON_PYTHON_XPT_VIM__")
  finish
endif
let b:__PYTHON_PYTHON_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef
XPT if hint=if\ ..:\ ..\ else...
if `cond^:
    `then^`...^
elif `cond2^:
    `todo^`...^
`else...^else:
    \`cursor\^^^


XPT for hint=for\ ..\ in\ ..:\ ...
for `vars^ in `range^0)^:
    `cursor^


XPT def hint=def\ ..(\ ..\ ):\ ...
def `fun_name^( `params^^ ):
    `cursor^


XPT lambda hint=(labmda\ ..\ :\ ..)
(lambda `args^ : `expr^)


XPT try hint=try:\ ..\ except:\ ...
try:
    `what^
except `except^:
    `handler^`...^
except `exc^:
    `handle^`...^
`else...^else:
    \`\^^^
`finally...^finally:
   \`\^^^


XPT class hint=class\ ..\ :\ def\ __init__\ ...
class `className^ `inherit^^:
    def __init__( self `args^^):
        `cursor^


XPT ifmain hint=if\ __name__\ ==\ __main__
if __name__ == "__main__" :
  `cursor^

XPT formview
def `form view^(request, *args, **kwargs):
    if request.method == 'POST':
        form = `FormClass^(`^request.POST)
        if form.is_valid():
            `^`# Do Stuff^
            return HttpResponseRedirect(reverse("`url name^"))
    else:
        form = `FormClass^(`^)
    
    data = { 'form': form, }
    
    return render_to_response("`path to template^.html", data,
                    context_instance=RequestContext(request))
`cursor^

