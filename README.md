vim-licenses
============

[Vim Plugin][] that Provides Commands to Add Licenses at the Top of the Buffer

[Vim Plugin]: http://www.vim.org/scripts/script.php?script_id=4871

settings
--------

### `g:licenses_default_commands`

Choose what commands to create for the listed licenses

```vim
let g:licenses_default_commands = ['gpl', 'mit', 'foobar']
```

Only `:Gpl` and `:Mit` commands are avaiable. `:Foobar` is also created for `licenses/foobar.txt`.
