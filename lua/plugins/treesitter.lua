return {
	{
		-- Treesitter on the new "main" branch
		"MeanderingProgrammer/treesitter-modules.nvim",
		branch = "main",
		-- Update parsers when the plugin is installed or updated
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		-- extra plugins that use Treesitter
		dependencies = {
			{
				-- Text objects still work with the new API
				"nvim-treesitter/nvim-treesitter",
				"nvim-treesitter/nvim-treesitter-textobjects",
				lazy = true,
			},
			{
				-- Autopairs is no longer built into Treesitter; this plugin adds context‑aware pairs
				"windwp/nvim-autopairs",
				opts = {
					check_ts = true, -- Use Treesitter for context awareness [oai_citation:4‡mintlify.com](https://www.mintlify.com/LunarVim/Neovim-from-scratch/plugins/autopairs#:~:text=Configuration)
				},
			},
			{
				-- Autotag for HTML/JSX/TSX – also no longer built into Treesitter
				"windwp/nvim-ts-autotag",
				opts = {},
			},
			{
				-- Optional: incremental selection replacement
				"shushtain/incselect.nvim",
				-- no setup options; map your keybindings here to mimic your old config
				config = function()
					-- these keymaps replicate your old <c-space>/<c-s>/<c-backspace> mappings
					vim.keymap.set({ "n", "x" }, "<C-space>", function()
						return require("incselect").init()
					end, { expr = true, silent = true })
					vim.keymap.set("x", "<C-s>", function()
						return require("incselect").parent()
					end, { expr = true, silent = true })
					vim.keymap.set("x", "<C-BS>", function()
						return require("incselect").undo()
					end, { expr = true, silent = true })
				end,
			},
		},
		-- Options passed directly to `require("nvim‑treesitter.config").setup()`
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"css",
				-- "gleam",
				-- "graphql",
				"html",
				"javascript",
				"json",
				"lua",
				"prisma",
				"typescript",
				"vim",
			},
			auto_install = true, -- install missing parsers automatically [oai_citation:5‡mintlify.com](https://www.mintlify.com/snehilshah/nvim/plugins/treesitter#:~:text=Treesitter%20is%20loaded%20immediately%20,and%20automatically%20updates%20parsers)
			highlight = { enable = true }, -- enable highlighting [oai_citation:6‡mintlify.com](https://www.mintlify.com/snehilshah/nvim/plugins/treesitter#:~:text=%22nvim,opts%20%3D%20%7B%7D%2C)
			indent = {
				enable = true,
				disable = { "ocaml", "ocaml_interface" },
			},
		},
	},
}
