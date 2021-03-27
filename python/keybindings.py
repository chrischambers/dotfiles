"""
Symlink to:
~/.ipython/profile_default/startup/keybindings.py

Inspiration:
https://stackoverflow.com/questions/38443907/how-does-one-set-specific-vim-bindings-in-ipython-5-0-0
"""
from IPython import get_ipython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.filters import HasFocus, ViInsertMode, ViNavigationMode
from prompt_toolkit.key_binding.bindings.named_commands import get_by_name

ip = get_ipython()
registry = ip.pt_app.key_bindings


ph = get_by_name('previous-history')
registry.add_binding('K',
                     filter=(HasFocus(DEFAULT_BUFFER) &
                             ViNavigationMode()))(ph)
nh = get_by_name('next-history')
registry.add_binding('J',
                     filter=(HasFocus(DEFAULT_BUFFER) &
                             ViNavigationMode()))(nh)

# Add classic Emacs-style shell keybindings to insert mode:
registry.add_binding("c-a",
                     filter=(HasFocus(DEFAULT_BUFFER) &
                             ViInsertMode()))(get_by_name("beginning-of-line"))
registry.add_binding("c-e",
                     filter=(HasFocus(DEFAULT_BUFFER) &
                             ViInsertMode()))(get_by_name("end-of-line"))
registry.add_binding("c-w",
                     filter=(HasFocus(DEFAULT_BUFFER) &
                             ViInsertMode()))(get_by_name("backward-kill-word"))
registry.add_binding("c-k",
                     filter=(HasFocus(DEFAULT_BUFFER) &
                             ViInsertMode()))(get_by_name("kill-line"))
