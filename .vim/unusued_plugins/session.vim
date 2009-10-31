" Filename: session.vim
" Description: A simple, automatic, no-nonsense, out of your way session manager
" Author: Nathan Lawrence
"

function! WriteSession()
	if !exists("g:vim_session_mask")
		silent exe "mksession! " . v:this_session
	endif
endfunction

command! -nargs=* Sdelete :let g:vim_session_mask = 0

if !exists("g:session_blacklist")
	let g:session_blacklist = ['\.swp$','\.tmp$','^\.']	
endif

if !exists("g:session_whitelist")
	let g:session_whitelist = ['^\.vimrc$']	
endif

python << EOF

import vim
import os
import hashlib
import re

def SetupSession():
	if vim.eval('argc()') == '0':
		dir_part = os.getcwd()
		file_part = ''

	elif vim.eval('argc()') == '1':
		save = True
		(dir_part, foobar, file_part) = \
			os.path.realpath(vim.eval('argv(0)')).strip('/').rpartition('/')

		blacklist = vim.eval('g:session_blacklist')
		for r in blacklist:
			if re.compile(r).match(file_part):
				save = False

		whitelist = vim.eval('g:session_whitelist')
		for r in whitelist:
			if re.compile(r).match(file_part):
				save = True
		
		if not save: return

	else:
		return
	
	session_dir = os.path.join(os.environ['HOME'],'.vim_plugins','vim_session',
		hashlib.md5(dir_part).hexdigest())

	if os.path.exists(session_dir):
		if not os.path.isdir(session_dir):
			print "Vim Session Error: " + session_dir + " should be a directory"
	else:
		os.mkdir(session_dir)

	this_session = os.path.join(session_dir, file_part + '.vim_session')

	vim.command('let v:this_session = "' + this_session + '"')
	
	if os.path.isfile(this_session):
		vim.command('silent exe "source " . v:this_session')
		f = open(this_session, "w")
		f.write('let session_mask = 0')
		f.close()

	if not vim.eval('exists("session_mask")'):
		return

	vim.command('au VimLeave * silent call WriteSession()')

SetupSession()

