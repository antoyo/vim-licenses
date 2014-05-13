" Copyright (c) 2014 Boucher, Antoni <bouanto@gmail.com>
" 
" All rights reserved.
" 
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions
" are met:
" 
" * Redistributions of source code must retain the above copyright
" notice, this list of conditions and the following disclaimer.
" 
" * Redistributions in binary form must reproduce the above copyright
" notice, this list of conditions and the following disclaimer in the
" documentation and/or other materials provided with the distribution.
" 
" * Neither the name of the copyright holder nor the names of its
" contributors may be used to endorse or promote products derived from
" this software without specific prior written permission.
" 
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
" "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
" LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
" A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
" OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
" SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
" LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
" DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
" THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
" (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
" OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

" Vim plugin to insert licenses.
" Last Change: 2014 May 12
" Maintener: Antoni Boucher <bouanto@gmail.com>
" License: BSD

if exists('g:loaded_licenses')
    finish
endif

let g:loaded_licenses = 1

" Insert and comment the provided license.
function! InsertLicense(name)
    " Check if the license is already in the buffer.
    if has('win32')
        let licenseFileName = '~/vimfiles/licenses/' . a:name . '.txt'
    else
        let licenseFileName = '~/.vim/licenses/' . a:name . '.txt'
    endif
    if filereadable(expand(licenseFileName))
        let fileContent = readfile(expand(licenseFileName))

        if search(fileContent[-1:][0]) == 0
            let addedLineCount = s:insertLicense(licenseFileName)

            let commentDelimiters = s:getCommentDelimiters()

            " Comment the license.
            if s:isSinglelineComment(commentDelimiters)
                call s:insertSinglelineComment(commentDelimiters, addedLineCount)
            else
                call s:insertComment(commentDelimiters, addedLineCount)
            endif

            call s:substituteYear()
        endif
    else
        echoerr 'Cannot find file ' . licenseFileName . '.'
    endif
endfunction

" Reading of comment delimiter.
function! s:getCommentDelimiters()
    let comments = split(&comments, ',')
    let commentDelimiters = {}
    let commentIndent = 0
    for i in range(len(comments))
        let splitted = split(comments[i], ':')
        if len(splitted) > 1
            let flags = splitted[0]
            if len(flags) > 0
                if flags[0] == 's'
                    let commentDelimiters['start'] = splitted[1]
                    let commentIndent = s:getIndent(flags, commentIndent)
                endif
                if flags[0] == 'e'
                    let commentDelimiters['end'] = splitted[1]
                    let commentIndent = s:getIndent(flags, commentIndent)
                endif
                if flags[0] == 'm'
                    let commentDelimiters['middle'] = splitted[1]
                endif
                if flags !~# '[efms]'
                    let commentDelimiters['singlelineStart'] = splitted[1]
                    let commentIndent = s:getIndent(flags, commentIndent)
                    if commentIndent == 0 && flags =~# 'b'
                        let commentIndent = 1
                    endif
                endif
            endif
        else
            let commentDelimiters['singlelineStart'] = splitted[0]
        endif
    endfor
    let indentString = s:getIndentString(commentIndent)
    if has_key(commentDelimiters, 'singlelineStart')
        let commentDelimiters['singlelineStart'] .= indentString
    endif
    if has_key(commentDelimiters, 'middle')
        let commentDelimiters['middle'] = indentString . commentDelimiters['middle']
        let commentDelimiters['middle'] .= indentString
    endif
    return commentDelimiters
endfunction

" Get the comment indent.
function! s:getIndent(commentString, defaultIndent)
    let indent = a:defaultIndent
    for i in range(len(a:commentString))
        if a:commentString[i] =~# '[0-9]'
            let indent = a:commentString[i]
        endif
    endfor
    return indent
endfunction

" Get the indent string (string of length of comment indent parameter).
function! s:getIndentString(commentIndent)
    let indentString = ''
    for i in range(a:commentIndent)
        let indentString .= ' '
    endfor
    return indentString
endfunction

" License insertion.
function! s:insertLicense(licenseFileName)
    let lineCounteBefore = line('$')
    normal gg

    let line1 = getline(1)

    if line1 =~# '^#!' || (&filetype == 'php' && line1 =~# '^<?php')
        if line('$') < 2
            normal o
            call setline('.', '')
            normal o
            call setline('.', '')
        endif

        let lineCounteBefore = line('$')

        execute '2read ' . expand(a:licenseFileName)
    else
        execute '0read ' . expand(a:licenseFileName)
    endif

    let lineCountAfter = line('$')
    return lineCountAfter - lineCounteBefore
endfunction

" Insert singleline comment.
function s:insertSinglelineComment(commentDelimiters, addedLineCount)
    normal gg

    let line1 = getline(1)
    if line1 =~# '^#!'
        call cursor(line('.') + 2, 0)
    endif

    let commentChar = a:commentDelimiters['singlelineStart']

    for i in range(1, a:addedLineCount)
        substitute /^/\=commentChar/
        call cursor(line('.') + 1, 0)
    endfor

    normal O
endfunction

" Insert multiline comment.
function s:insertComment(commentDelimiters, addedLineCount)
    " Insert php open tag if filetype is php and first line does not
    " contain it.
    let hasInsertedPhpTag = 0
    let line1 = getline(1)
    if &filetype == 'php'
        if line1 !~# '^<?php'
            let hasInsertedPhpTag = 1
            normal ggO<?php
            normal o
        else
            normal ggo
            call cursor(line('.') + 1, 0)
        endif
    else
        normal ggO
    endif

    put =a:commentDelimiters['start']
    call cursor(line('.') - 1, 0)
    delete
    for i in range(1, a:addedLineCount)
        call cursor(line('.') + 1, 0)
        substitute /^/\=a:commentDelimiters['middle']/
        call cursor(0, col('.') + 1)
    endfor
    put =a:commentDelimiters['end']
    normal I 

    " Insert php close tag if filetype is php and first line did not
    " contain it.
    if &filetype == 'php' && hasInsertedPhpTag
        normal o?>
    endif

    normal o
endfunction

" Check whether only the singleline comment is supported.
function s:isSinglelineComment(commentDelimiters)
    let isCMakeLists = expand('%:t') == 'CMakeLists.txt'
    return !(has_key(a:commentDelimiters, 'start') && has_key(a:commentDelimiters, 'middle') && has_key(a:commentDelimiters, 'end')) || isCMakeLists
endfunction

" Substitute the year tag to the current year.
function! s:substituteYear()
    let _ = search('<year>', 'b')
    silent! substitute /<year>/\=strftime('%Y')/
endfunction

" Add a few default commands.
if !exists(':Bsd')
    command Bsd call InsertLicense('bsd')
endif

if !exists('Gpl')
    command Gpl call InsertLicense('gpl')
endif

if !exists('Lgpl')
    command Lgpl call InsertLicense('lgpl')
endif
