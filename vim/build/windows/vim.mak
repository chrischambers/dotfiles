#!/bin/sh

# Note: Ensure RUBY_LONG_VER=2.1.0 corresponds to
# %RUBY%/bin/msvcrt-ruby210.dll

make -B -f Make_cyg.mak \
LUA=/cygdrive/d/Lua5.1 \
PYTHON3=/cygdrive/d/Python34 \
PYTHON3_VER=34 DYNAMIC_PYTHON3=yes \
RUBY=/cygdrive/d/Ruby21 DYNAMIC_RUBY=yes \
RUBY_VER=21 RUBY_VER_LONG=2.1.0 \
FEATURES=HUGE \
GUI=no \
vim.exe 2>&1 | tee vim.log
