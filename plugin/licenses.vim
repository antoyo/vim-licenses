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

" Vim plugin to insert licenses.
" Last Change: 2015 October 11
" Maintener: Antoni Boucher <bouanto@gmail.com>
" License: BSD

if exists('g:loaded_licenses')
    finish
endif

let g:loaded_licenses = 1

if !exists('g:licenses_copyright_holders_name')
    let g:licenses_copyright_holders_name = ''
endif

if !exists('g:licenses_authors_name')
    let g:licenses_authors_name = ''
endif

if !exists('g:licenses_default_commands')
    let g:licenses_default_commands =
        \['affero'
        \, 'allpermissive'
        \, 'apache'
        \, 'boost'
        \, 'bsd2'
        \, 'bsd3'
        \, 'cecill'
        \, 'epl'
        \, 'gfdl'
        \, 'gpl'
        \, 'gplv2'
        \, 'isc'
        \, 'lgpl'
        \, 'mit'
        \, 'mpl'
        \, 'unlicense'
        \, 'verbatim'
        \, 'wtfpl'
        \, 'zlib'
    \]
endif

" Default comment delimiters for some languages without proper options
" setting.
let s:filetypeCommentDelimiters = {
    \'cmake': {
        \'singlelineStart': '# '
    \},
    \'haskell': {
        \'end': '-}',
        \'middle': ' - ',
        \'start': '{-'
    \},
    \'python': {
        \'singlelineStart': '# '
    \},
    \'sh': {
        \'singlelineStart': '# '
    \}
\}

let s:licensesPath = expand('<sfile>:p:h:h') . '/licenses/'

" Insert and comment the provided license.
function! InsertLicense(name)
    " Check if the license is already in the buffer.
    let licenseFileName = s:licensesPath . a:name . '.txt'
    if filereadable(expand(licenseFileName))
        let fileContent = readfile(expand(licenseFileName))

        let searchResult = search(fileContent[-1])
        if searchResult == 0 || searchResult > len(fileContent) + 5
            let oldLineCount = line('$')
            let secondLineEmpty = line('$') > 1 && getline(2) == ''
            let addedLineCount = s:insertLicense(licenseFileName, secondLineEmpty)

            let commentDelimiters = s:getCommentDelimiters()

            " Comment the license.
            if s:isSinglelineComment(commentDelimiters)
                call s:insertSinglelineComment(commentDelimiters, addedLineCount)
            else
                call s:insertComment(commentDelimiters, addedLineCount, secondLineEmpty)
            endif
            let newLineCount = line('$')
            let lineCountDiff = newLineCount - oldLineCount

            let lastLine = line('.') - 1
            let firstLine = lastLine - lineCountDiff + 1
            call s:substituteYear(firstLine, lastLine)
            call s:substituteCopyrightHolder(firstLine, lastLine)
            call s:substituteAuthorName(firstLine, lastLine)
        endif
    else
        echoerr 'Cannot find file ' . licenseFileName . '.'
    endif
endfunction

" Reading of comment delimiter.
function! s:getCommentDelimiters()
    let comments = split(&comments, ',')
    let commentDelimiters = {}
    if has_key(s:filetypeCommentDelimiters, &filetype)
        return s:filetypeCommentDelimiters[&filetype]
    endif
    let commentIndent = 1
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
                endif
            endif
        else
            let commentDelimiters['singlelineStart'] = splitted[0]
            let commentIndent = s:getIndent('', commentIndent)
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

" Go to the specified line number.
function! s:goTo(lineNumber)
    execute ':' . a:lineNumber
endfunction

" License insertion.
function! s:insertLicense(licenseFileName, secondLineEmpty)
    let lineCounteBefore = line('$')
    normal! gg

    let line1 = getline(1)

    if line1 =~# '^#!' 
        if line('$') < 2
            normal! o
            call setline('.', '')
        endif

        let lineCounteBefore = line('$')

        execute 'keepalt 2read ' . expand(a:licenseFileName)
    elseif s:isFileType('php') && line1 =~# '^<?php'
        let lineCounteBefore = line('$')

        if a:secondLineEmpty
            execute 'keepalt 2read ' . expand(a:licenseFileName)
        else
            execute 'keepalt 1read ' . expand(a:licenseFileName)
        endif
    else
        execute 'keepalt 0read ' . expand(a:licenseFileName)
    endif

    let lineCountAfter = line('$')
    return lineCountAfter - lineCounteBefore
endfunction

" Insert singleline comment.
function s:insertSinglelineComment(commentDelimiters, addedLineCount)
    normal! gg

    let line1 = getline(1)
    if line1 =~# '^#!'
        call cursor(line('.') + 2, 0)
    endif

    let commentChar = a:commentDelimiters['singlelineStart']

    let lastLine = line('.') + a:addedLineCount - 1

    for i in range(1, a:addedLineCount)
        substitute /^/\=commentChar/
        substitute /\s\+$//e
        call cursor(line('.') + 1, 0)
    endfor

    if line('.') == lastLine
        normal! o
        call setline('.', '')
        normal! o
    else
        normal! O
    endif
    call setline('.', '')
endfunction

" Insert multiline comment.
function s:insertComment(commentDelimiters, addedLineCount, secondLineEmpty)
    " Insert php open tag if filetype is php and first line does not
    " contain it.
    let hasInsertedPhpTag = 0
    let line1 = getline(1)
    if s:isFileType('php')
        if line1 !~# '^<?php'
            let hasInsertedPhpTag = 1
            normal! ggO<?php
            normal! o
        else
            normal! gg
            if !a:secondLineEmpty
                normal! o
            else
                call cursor(line('.') + 1, 0)
            endif
        endif
        normal! o
    else
        normal! ggO
    endif

    call setline('.', a:commentDelimiters['start'])
    for i in range(1, a:addedLineCount)
        call cursor(line('.') + 1, 0)
        substitute /^/\=a:commentDelimiters['middle']/
        substitute /\s\+$//e
    endfor
    put =a:commentDelimiters['end']
    normal! I 

    " Insert php close tag if filetype is php and first line did not
    " contain it.
    if s:isFileType('php') && hasInsertedPhpTag
        normal! o
        normal! o?>
    endif

    normal! o
endfunction

" Check whether the current file is of the specified filetype.
function! s:isFileType(filetype)
    return &filetype == a:filetype
endfunction

" Check whether only the singleline comment is supported.
function! s:isSinglelineComment(commentDelimiters)
    return !(has_key(a:commentDelimiters, 'start') && has_key(a:commentDelimiters, 'middle') && has_key(a:commentDelimiters, 'end')) || s:isFileType('cmake') || s:isFileType('vim') || s:isFileType('sh')
endfunction

" Substitute the year tag to the current year.
function! s:substituteYear(firstLine, lastLine)
    call s:goTo(a:firstLine)
    let _ = search('<year>', 'w')
    let currentLine = line('.')
    if currentLine >= a:firstLine && currentLine <= a:lastLine
        silent! substitute /<year>/\=strftime('%Y')/
    endif
endfunction

" Substitute the copyright holder's name tag.
function! s:substituteCopyrightHolder(firstLine, lastLine)
    if len(g:licenses_copyright_holders_name) > 0
        call s:goTo(a:firstLine)
        let _ = search('<name of copyright holder>', 'w')
        let currentLine = line('.')
        if currentLine >= a:firstLine && currentLine <= a:lastLine
            silent! substitute /<name of copyright holder>/\=g:licenses_copyright_holders_name/
        endif
    endif
endfunction

" Substitute the author's name tag.
function! s:substituteAuthorName(firstLine, lastLine)
    call s:goTo(a:firstLine)
    let _ = search('<name of author>', 'w')
    let currentLine = line('.')
    if currentLine >= a:firstLine && currentLine <= a:lastLine
        if len(g:licenses_authors_name) > 0
            silent! substitute /<name of author>/\='Author: ' . g:licenses_authors_name/
        else
            if getline('.') =~ "<name of author>"
                normal! dd
            endif
        endif
    endif
endfunction

" Add a the default commands.
for s:license in g:licenses_default_commands
    let s:command = toupper(s:license[0]) . tolower(s:license[1:])
    execute 'command '. s:command . ' call InsertLicense("' . s:license . '")'
endfor
