" Copyright (c) 2014-2016, Boucher, Antoni <bouanto@gmail.com>
" All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"     * Redistributions of source code must retain the above copyright
"       notice, this list of conditions and the following disclaimer.
"     * Redistributions in binary form must reproduce the above copyright
"       notice, this list of conditions and the following disclaimer in the
"       documentation and/or other materials provided with the distribution.
"     * Neither the name of the <organization> nor the
"       names of its contributors may be used to endorse or promote products
"       derived from this software without specific prior written permission.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
" ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
" DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
" (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
" LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
" ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
" (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
" SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

let s:tc = unittest#testcase#new('Insert License')

let s:year = strftime('%Y')

" Set a license author name and save the current one.
function! s:tc.SETUP()
    let s:old_licenses_copyright_holders_name = g:licenses_copyright_holders_name
    let g:licenses_copyright_holders_name = 'Last Name, First Name <my@email.com>'
    let s:name = g:licenses_copyright_holders_name
endfunction

" Restore the license author name.
function! s:tc.TEARDOWN()
    let g:licenses_copyright_holders_name = s:old_licenses_copyright_holders_name
endfunction

" Clear the content of the window.
function! s:clearWindow()
    normal! gg
    normal! dG
endfunction

" Insert the specified text.
function! s:insertText(text)
    let lines = split(a:text, '\n')
    for line in reverse(lines)
        call append(0, line)
    endfor
    normal! Gdd
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "asm".
function! s:tc.test_asm()
    new test.asm
    call s:clearWindow()
    set filetype=nasm
    Gpl
    call self.assert_equal('; Copyright (C) ' . s:year . '  ' . s:name, getline(1))
    call self.assert_equal(';', getline(2))
    call self.assert_equal('; This program is free software: you can redistribute it and/or modify', getline(3))
    call self.assert_equal('; along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(14))
    call self.assert_equal('', getline(15))
    call self.assert_equal('', getline(16))
    call self.assert_equal(16, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "cmake".
function! s:tc.test_cmake()
    new CMakeLists.txt
    call s:clearWindow()
    Gpl
    call self.assert_equal('# Copyright (C) ' . s:year . '  ' . s:name, getline(1))
    call self.assert_equal('#', getline(2))
    call self.assert_equal('# This program is free software: you can redistribute it and/or modify', getline(3))
    call self.assert_equal('# along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(14))
    call self.assert_equal('', getline(15))
    call self.assert_equal('', getline(16))
    call self.assert_equal(16, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "c".
function! s:tc.test_c()
    new test.c
    call s:clearWindow()
    Gpl
    call self.assert_equal('/*', getline(1))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(2))
    call self.assert_equal(' *', getline(3))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(4))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(15))
    call self.assert_equal(' */', getline(16))
    call self.assert_equal('', getline(17))
    call self.assert_equal('', getline(18))
    call self.assert_equal(18, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "cpp".
function! s:tc.test_cpp()
    new test.cpp
    call s:clearWindow()
    Gpl
    call self.assert_equal('/*', getline(1))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(2))
    call self.assert_equal(' *', getline(3))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(4))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(15))
    call self.assert_equal(' */', getline(16))
    call self.assert_equal('', getline(17))
    call self.assert_equal('', getline(18))
    call self.assert_equal(18, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "cs".
function! s:tc.test_cs()
    new test.cs
    call s:clearWindow()
    Gpl
    call self.assert_equal('/*', getline(1))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(2))
    call self.assert_equal(' *', getline(3))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(4))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(15))
    call self.assert_equal(' */', getline(16))
    call self.assert_equal('', getline(17))
    call self.assert_equal('', getline(18))
    call self.assert_equal(18, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "css".
function! s:tc.test_css()
    new test.css
    call s:clearWindow()
    Gpl
    call self.assert_equal('/*', getline(1))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(2))
    call self.assert_equal(' *', getline(3))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(4))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(15))
    call self.assert_equal(' */', getline(16))
    call self.assert_equal('', getline(17))
    call self.assert_equal('', getline(18))
    call self.assert_equal(18, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "haskell".
function! s:tc.test_haskell()
    new test.hs
    call s:clearWindow()
    Gpl
    call self.assert_equal('{-', getline(1))
    call self.assert_equal(' - Copyright (C) ' . s:year . '  ' . s:name, getline(2))
    call self.assert_equal(' -', getline(3))
    call self.assert_equal(' - This program is free software: you can redistribute it and/or modify', getline(4))
    call self.assert_equal(' - along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(15))
    call self.assert_equal(' -}', getline(16))
    call self.assert_equal('', getline(17))
    call self.assert_equal('', getline(18))
    call self.assert_equal(18, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "html".
function! s:tc.test_html()
    new test.html
    call s:clearWindow()
    Gpl
    call self.assert_equal('<!--', getline(1))
    call self.assert_equal('      Copyright (C) ' . s:year . '  ' . s:name, getline(2))
    call self.assert_equal('', getline(3))
    call self.assert_equal('      This program is free software: you can redistribute it and/or modify', getline(4))
    call self.assert_equal('      along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(15))
    call self.assert_equal(' -->', getline(16))
    call self.assert_equal('', getline(17))
    call self.assert_equal('', getline(18))
    call self.assert_equal(18, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "java".
function! s:tc.test_java()
    new test.java
    call s:clearWindow()
    Gpl
    call self.assert_equal('/*', getline(1))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(2))
    call self.assert_equal(' *', getline(3))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(4))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(15))
    call self.assert_equal(' */', getline(16))
    call self.assert_equal('', getline(17))
    call self.assert_equal('', getline(18))
    call self.assert_equal(18, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "js".
function! s:tc.test_js()
    new test.js
    call s:clearWindow()
    Gpl
    call self.assert_equal('/*', getline(1))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(2))
    call self.assert_equal(' *', getline(3))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(4))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(15))
    call self.assert_equal(' */', getline(16))
    call self.assert_equal('', getline(17))
    call self.assert_equal('', getline(18))
    call self.assert_equal(18, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "Objective-c".
function! s:tc.test_objective_c()
    new test.m
    set filetype=objc
    call s:clearWindow()
    Gpl
    call self.assert_equal('/*', getline(1))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(2))
    call self.assert_equal(' *', getline(3))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(4))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(15))
    call self.assert_equal(' */', getline(16))
    call self.assert_equal('', getline(17))
    call self.assert_equal('', getline(18))
    call self.assert_equal(18, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "perl".
function! s:tc.test_perl()
    new test.pl
    call s:clearWindow()
    Gpl
    call self.assert_equal('# Copyright (C) ' . s:year . '  ' . s:name, getline(1))
    call self.assert_equal('#', getline(2))
    call self.assert_equal('# This program is free software: you can redistribute it and/or modify', getline(3))
    call self.assert_equal('# along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(14))
    call self.assert_equal('', getline(15))
    call self.assert_equal('', getline(16))
    call self.assert_equal(16, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "php".
function! s:tc.test_php_empty()
    new test.php
    call s:clearWindow()
    Gpl
    call self.assert_equal('<?php', getline(1))
    call self.assert_equal('/*', getline(3))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(4))
    call self.assert_equal(' *', getline(5))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(6))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(17))
    call self.assert_equal(' */', getline(18))
    call self.assert_equal('', getline(19))
    call self.assert_equal('?>', getline(20))
    call self.assert_equal('', getline(21))
    call self.assert_equal('', getline(22))
    call self.assert_equal(22, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in a not empty buffer with filetype
" "php".
function! s:tc.test_php_not_empty()
    new test.php
    call s:clearWindow()
    call s:insertText("<?php\necho 'Hello World';\n?>")
    Gpl
    call self.assert_equal('<?php', getline(1))
    call self.assert_equal('', getline(2))
    call self.assert_equal('/*', getline(3))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(4))
    call self.assert_equal(' *', getline(5))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(6))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(17))
    call self.assert_equal(' */', getline(18))
    call self.assert_equal('', getline(19))
    call self.assert_equal("echo 'Hello World';", getline(20))
    call self.assert_equal('?>', getline(21))
    call self.assert_equal(21, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in a not empty buffer starting with
" HTML with filetype
" "php".
function! s:tc.test_php_not_empty_html()
    new test.php
    call s:clearWindow()
    call s:insertText("<!DOCTYPE html>\n\n<?php\necho 'Hello World';\n?>")
    Gpl
    call self.assert_equal('<?php', getline(1))
    call self.assert_equal('', getline(2))
    call self.assert_equal('/*', getline(3))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(4))
    call self.assert_equal(' *', getline(5))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(6))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(17))
    call self.assert_equal(' */', getline(18))
    call self.assert_equal('', getline(19))
    call self.assert_equal('?>', getline(20))
    call self.assert_equal('', getline(21))
    call self.assert_equal('<!DOCTYPE html>', getline(22))
    call self.assert_equal('', getline(23))
    call self.assert_equal('<?php', getline(24))
    call self.assert_equal("echo 'Hello World';", getline(25))
    call self.assert_equal('?>', getline(26))
    call self.assert_equal(26, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in a not empty buffer with spaces with
" filetype "php".
function! s:tc.test_php_not_empty_spaced()
    new test.php
    call s:clearWindow()
    call s:insertText("<?php\n\necho 'Hello World';\n\n?>")
    Gpl
    call self.assert_equal('<?php', getline(1))
    call self.assert_equal('', getline(2))
    call self.assert_equal('/*', getline(3))
    call self.assert_equal(' * Copyright (C) ' . s:year . '  ' . s:name, getline(4))
    call self.assert_equal(' *', getline(5))
    call self.assert_equal(' * This program is free software: you can redistribute it and/or modify', getline(6))
    call self.assert_equal(' * along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(17))
    call self.assert_equal(' */', getline(18))
    call self.assert_equal('', getline(19))
    call self.assert_equal("echo 'Hello World';", getline(20))
    call self.assert_equal('', getline(21))
    call self.assert_equal('?>', getline(22))
    call self.assert_equal(22, line('$'))
    bdelete!
endfunction

" Test the insertion of the Bsd 2-clause license in an empty buffer with filetype
" "python".
function! s:tc.test_python_empty()
    new test.py
    call s:clearWindow()
    Bsd2
    call self.assert_equal('# Copyright (c) ' . s:year . ', ' . s:name, getline(1))
    call self.assert_equal('#', getline(2))
    call self.assert_equal('# All rights reserved.', getline(3))
    call self.assert_equal('#', getline(4))
    call self.assert_equal('# either expressed or implied, of the FreeBSD Project.', getline(27))
    call self.assert_equal('', getline(28))
    call self.assert_equal('', getline(29))
    call self.assert_equal(29, line('$'))
    bdelete!
endfunction

" Test the insertion of the Bsd 3-clause license in a not empty buffer with
" filetype "python".
function! s:tc.test_python_not_empty()
    new test.py
    call s:clearWindow()
    call s:insertText('print("Hello World")')
    Bsd3
    call self.assert_equal('# Copyright (c) ' . s:year . ', ' . s:name, getline(1))
    call self.assert_equal('# All rights reserved.', getline(3))
    call self.assert_equal('#', getline(4))
    call self.assert_equal('# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.', getline(25))
    call self.assert_equal('', getline(26))
    call self.assert_equal('print("Hello World")', getline(27))
    call self.assert_equal(27, line('$'))
    bdelete!
endfunction

" Test the insertion of the MPL license in a buffer starting with a comment
" with filetype "python".
function! s:tc.test_python_start_with_comment()
    new test.py
    call s:clearWindow()
    call s:insertText('#print("Hello World")')
    Mpl
    call self.assert_equal('# This Source Code Form is subject to the terms of the Mozilla Public License,', getline(1))
    call self.assert_equal('# obtain one at http://mozilla.org/MPL/2.0/.', getline(3))
    call self.assert_equal('', getline(4))
    call self.assert_equal('#print("Hello World")', getline(5))
    call self.assert_equal(5, line('$'))
    bdelete!
endfunction

" Test the insertion of the EPL license in a buffer starting with a shebang
" with filetype "python".
function! s:tc.test_python_start_with_shebang()
    new test.py
    call s:clearWindow()
    call s:insertText('#!/usr/bin/env python')
    Epl
    call self.assert_equal('#!/usr/bin/env python', getline(1))
    call self.assert_equal('', getline(2))
    call self.assert_equal('# Copyright (c) ' . s:year . '  ' . s:name, getline(3))
    call self.assert_equal('# http://www.eclipse.org/legal/epl-v10.html', getline(8))
    call self.assert_equal('', getline(9))
    call self.assert_equal('', getline(10))
    call self.assert_equal(10, line('$'))
    bdelete!
endfunction

" Test the insertion of the EPL license in a three line buffer starting with a
" shebang with filetype "python".
function! s:tc.test_python_start_with_shebang_three_lines()
    new test.py
    call s:clearWindow()
    call s:insertText("#!/usr/bin/env python\n\nprint('Hello World')")
    Epl
    call self.assert_equal('#!/usr/bin/env python', getline(1))
    call self.assert_equal('', getline(2))
    call self.assert_equal('# Copyright (c) ' . s:year . '  ' . s:name, getline(3))
    call self.assert_equal('# http://www.eclipse.org/legal/epl-v10.html', getline(8))
    call self.assert_equal('', getline(9))
    call self.assert_equal("print('Hello World')", getline(10))
    call self.assert_equal(10, line('$'))
    bdelete!
endfunction

" Test the insertion of the EPL license in a two line buffer starting with a
" shebang with filetype "python".
function! s:tc.test_python_start_with_shebang_two_lines()
    new test.py
    call s:clearWindow()
    call s:insertText("#!/usr/bin/env python\n")
    Epl
    call self.assert_equal('#!/usr/bin/env python', getline(1))
    call self.assert_equal('', getline(2))
    call self.assert_equal('# Copyright (c) ' . s:year . '  ' . s:name, getline(3))
    call self.assert_equal('# http://www.eclipse.org/legal/epl-v10.html', getline(8))
    call self.assert_equal('', getline(9))
    call self.assert_equal('', getline(10))
    call self.assert_equal(10, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "ruby".
function! s:tc.test_ruby()
    new test.rb
    call s:clearWindow()
    Gpl
    call self.assert_equal('# Copyright (C) ' . s:year . '  ' . s:name, getline(1))
    call self.assert_equal('#', getline(2))
    call self.assert_equal('# This program is free software: you can redistribute it and/or modify', getline(3))
    call self.assert_equal('# along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(14))
    call self.assert_equal('', getline(15))
    call self.assert_equal('', getline(16))
    call self.assert_equal(16, line('$'))
    bdelete!
endfunction

" Test the insertion of the Apache license in an empty buffer with filetype
" "sh".
function! s:tc.test_sh_empty()
    new test.sh
    call s:clearWindow()
    Apache
    call self.assert_equal('# Copyright ' . s:year . ' ' . s:name, getline(1))
    call self.assert_equal('#', getline(2))
    call self.assert_equal('# Licensed under the Apache License, Version 2.0 (the "License");', getline(3))
    call self.assert_equal('# limitations under the License.', getline(13))
    call self.assert_equal('', getline(14))
    call self.assert_equal('', getline(15))
    call self.assert_equal(15, line('$'))
    bdelete!
endfunction

" Test the insertion of the GNU Affero license in a not empty buffer with
" filetype "sh".
function! s:tc.test_sh_not_empty()
    new test.sh
    call s:clearWindow()
    call s:insertText('echo "Hello World"')
    Affero
    call self.assert_equal('# Copyright (C) ' . s:year . ' ' . s:name, getline(1))
    call self.assert_equal('#', getline(2))
    call self.assert_equal('# This program is free software: you can redistribute it and/or modify', getline(3))
    call self.assert_equal('# along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(14))
    call self.assert_equal('', getline(15))
    call self.assert_equal('echo "Hello World"', getline(16))
    call self.assert_equal(16, line('$'))
    bdelete!
endfunction

" Test the insertion of the MPL license in a buffer starting with a comment
" with filetype "sh".
function! s:tc.test_sh_start_with_comment()
    new test.sh
    call s:clearWindow()
    call s:insertText('#echo "Hello World"')
    Mpl
    call self.assert_equal('# This Source Code Form is subject to the terms of the Mozilla Public License,', getline(1))
    call self.assert_equal('# obtain one at http://mozilla.org/MPL/2.0/.', getline(3))
    call self.assert_equal('', getline(4))
    call self.assert_equal('#echo "Hello World"', getline(5))
    call self.assert_equal(5, line('$'))
    bdelete!
endfunction

" Test the insertion of the EPL license in a buffer starting with a shebang
" with filetype "sh".
function! s:tc.test_sh_start_with_shebang()
    new test.sh
    call s:clearWindow()
    call s:insertText('#!/usr/bin/env bash')
    Epl
    call self.assert_equal('#!/usr/bin/env bash', getline(1))
    call self.assert_equal('', getline(2))
    call self.assert_equal('# Copyright (c) ' . s:year . '  ' . s:name, getline(3))
    call self.assert_equal('# http://www.eclipse.org/legal/epl-v10.html', getline(8))
    call self.assert_equal('', getline(9))
    call self.assert_equal('', getline(10))
    call self.assert_equal(10, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license in an empty buffer with filetype
" "vim".
function! s:tc.test_vim_empty()
    new test.vim
    call s:clearWindow()
    Gpl
    call self.assert_equal('" Copyright (C) ' . s:year . '  ' . s:name, getline(1))
    call self.assert_equal('"', getline(2))
    call self.assert_equal('" This program is free software: you can redistribute it and/or modify', getline(3))
    call self.assert_equal('" along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(14))
    call self.assert_equal('', getline(15))
    call self.assert_equal('', getline(16))
    call self.assert_equal(16, line('$'))
    bdelete!
endfunction

" Test the insertion of the GPL license twice in an empty buffer with filetype
" "vim".
function! s:tc.test_vim_insert_twice()
    new test.vim
    call s:clearWindow()
    Gpl
    Gpl
    call self.assert_equal('" Copyright (C) ' . s:year . '  ' . s:name, getline(1))
    call self.assert_equal('"', getline(2))
    call self.assert_equal('" This program is free software: you can redistribute it and/or modify', getline(3))
    call self.assert_equal('" along with this program.  If not, see <http://www.gnu.org/licenses/>.', getline(14))
    call self.assert_equal('', getline(15))
    call self.assert_equal('', getline(16))
    call self.assert_equal(16, line('$'))
    bdelete!
endfunction

" Test the insertion of the LGPL license in a not empty buffer with filetype
" "vim".
function! s:tc.test_vim_not_empty()
    new test.vim
    call s:clearWindow()
    call s:insertText("echo 'Hello World'")
    Lgpl
    call self.assert_equal('" Copyright (C) ' . s:year . '  ' . s:name, getline(1))
    call self.assert_equal('"', getline(2))
    call self.assert_equal('" This program is free software: you can redistribute it and/or', getline(3))
    call self.assert_equal('" License along with this program.  If not, see', getline(14))
    call self.assert_equal('', getline(16))
    call self.assert_equal("echo 'Hello World'", getline(17))
    call self.assert_equal(17, line('$'))
    bdelete!
endfunction

" Test the insertion of the MIT license in a buffer starting with a comment
" with filetype "vim".
function! s:tc.test_vim_start_with_comment()
    new test.vim
    call s:clearWindow()
    call s:insertText("\"echo 'Hello World'")
    Mit
    call self.assert_equal('" Copyright (c) ' . s:year . ' ' . s:name, getline(1))
    call self.assert_equal('"', getline(2))
    call self.assert_equal('" Permission is hereby granted, free of charge, to any person obtaining a copy of', getline(3))
    call self.assert_equal('" CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.', getline(18))
    call self.assert_equal('', getline(19))
    call self.assert_equal("\"echo 'Hello World'", getline(20))
    call self.assert_equal(20, line('$'))
    bdelete!
endfunction

" Test the insertion of the MIT license in a buffer without a copyright holder
" name with filetype "vim".
function! s:tc.test_vim_without_copyright_holder_name()
    let g:licenses_copyright_holders_name = ''

    new test.vim
    call s:clearWindow()
    call s:insertText("\"echo 'Hello World'")
    Mit
    call self.assert_equal('" Copyright (c) ' . s:year . ' <name of copyright holder>', getline(1))
    call self.assert_equal('"', getline(2))
    call self.assert_equal('" Permission is hereby granted, free of charge, to any person obtaining a copy of', getline(3))
    call self.assert_equal('" CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.', getline(18))
    call self.assert_equal('', getline(19))
    call self.assert_equal("\"echo 'Hello World'", getline(20))
    call self.assert_equal(20, line('$'))
    bdelete!

    let g:licenses_copyright_holders_name = 'Last Name, First Name <my@email.com>'
endfunction

" Test the insertion of the MIT license in a buffer with a copyright holder
" and an author name name with filetype "vim".
function! s:tc.test_vim_with_copyright_holder_name_and_author_name()
    let g:licenses_copyright_holders_name = 'My Company'
    let g:licenses_authors_name = 'Last Name, First Name <my@email.com>'

    new test.vim
    call s:clearWindow()
    call s:insertText("\"echo 'Hello World'")
    Mit
    call self.assert_equal('" Copyright (c) ' . s:year . ' My Company', getline(1))
    call self.assert_equal('" Author: Last Name, First Name <my@email.com>', getline(2))
    call self.assert_equal('"', getline(3))
    call self.assert_equal('" Permission is hereby granted, free of charge, to any person obtaining a copy of', getline(4))
    call self.assert_equal('" CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.', getline(19))
    call self.assert_equal('', getline(20))
    call self.assert_equal("\"echo 'Hello World'", getline(21))
    call self.assert_equal(21, line('$'))
    bdelete!

    let g:licenses_copyright_holders_name = 'Last Name, First Name <my@email.com>'
    let g:licenses_authors_name = ''
endfunction
