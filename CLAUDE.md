# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration that uses [Lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. The configuration follows a modular architecture with separate files for plugins, options, and utility configurations.

## Architecture

### Core Structure

- `init.lua`: Entry point that sets up Lazy.nvim and loads all configuration modules
- `lua/options.lua`: Core Neovim settings (tabs, indentation, search behavior, etc.)
- `lua/plugins/`: Individual plugin configurations (one file per plugin/feature)
- `lua/config/`: Utility modules, keymaps, and helper functions

### Plugin Management

- Uses Lazy.nvim for plugin management with lazy loading based on events
- Lock file: `lazy-lock.json` (tracked in version control)
- Plugins are auto-imported from `lua/plugins/` directory

### Key Components

1. **LSP Configuration** (`lua/plugins/lsp.lua`):
   - Mason.nvim for LSP server management
   - Configured servers: bashls, cssls, html, jsonls, lua_ls, pyright, sqlls, tailwindcss, ts_ls, yamlls
   - Custom diagnostics filtering for TypeScript

2. **Completion** (`lua/plugins/autopairs_and_cmp.lua`):
   - nvim-cmp for autocompletion
   - LuaSnip for snippets
   - Integration with LSP

3. **Formatting & Linting**:
   - conform.nvim for formatting (`lua/plugins/formatting.lua`)
   - nvim-lint for linting (`lua/plugins/linting.lua`)
   - Format on save functionality (`lua/config/format_on_save.lua`)

## Common Commands

### Plugin Management
```bash
# Open Lazy.nvim UI (from within Neovim)
:Lazy

# Update plugins
:Lazy update

# Sync plugins (clean + install)
:Lazy sync

# Check plugin status
:Lazy check
```

### LSP & Mason Commands
```bash
# Open Mason UI to manage LSP servers
:Mason

# View LSP info for current buffer
:LspInfo

# Install specific LSP server via Mason
:MasonInstall <server-name>
```

### Development Workflow
```bash
# Test configuration changes
nvim --headless "+Lazy sync" +qa  # Update plugins from command line

# Check for errors in config
nvim --headless "+checkhealth" +qa

# Debug plugin loading
nvim --startuptime startup.log
```

## Key Bindings
- Leader key: `<Space>`
- Window navigation: `<C-h/j/k/l>` (with Kitty/Tmux integration)
- LSP keybindings are defined in `lua/config/keymaps.lua` via `map_lsp_keybinds` function

## Important Configurations
- Tabs set to 2 spaces with expandtab
- Relative line numbers enabled
- Mouse mode enabled
- Persistent undo history
- Format on save enabled for supported file types
- ESLint toggle functionality available

## Adding New Plugins
1. Create a new file in `lua/plugins/` with the plugin specification
2. Follow the existing pattern: return a table with plugin configuration
3. Lazy.nvim will automatically detect and load the new plugin file

## Debugging Issues
1. Check `:messages` for error messages
2. Use `:checkhealth` to diagnose common issues
3. Review `lazy-lock.json` for plugin version conflicts
4. Temporarily disable problematic plugins by renaming to `.lua_ignore`
