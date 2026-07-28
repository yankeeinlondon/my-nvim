# NVIM Configuration

This configuration uses [Lazy](https://github.com/folke/lazy.nvim) to load all plugins and provides a modular structure that
hopes to stay maintainable.

Inspiration was provided by many sources including:

- [Dillion Mullroy](https://github.com/dmmulroy/dotfiles)
- [another]()

## LSP's, Linters, and Formatters

This repo uses both [Mason](https://github.com/williamboman/mason.nvim) and [Mason LSP Config](https://github.com/williamboman/mason-lspconfig.nvim) to autoload the expected **LSP**'s, _linters_, and _formatters_. You're free to
dynamically manage these dependencies using the [Mason](https://github.com/williamboman/mason.nvim) UI.
