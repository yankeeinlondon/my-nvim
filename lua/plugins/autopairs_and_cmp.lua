---@diagnostic disable: missing-fields
return {
    -- core cmp (NO cmp_* sources in dependencies)
    {
        "hrsh7th/nvim-cmp",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim",
            "windwp/nvim-autopairs",
            "windwp/nvim-ts-autotag",
        },
        config = function()
            -- scrub poisoned modules/globals that may be booleans
            if package.loaded.cmp ~= nil and type(package.loaded.cmp) ~= "table" then
                package.loaded.cmp = nil
            end
            if _G.cmp ~= nil and type(_G.cmp) ~= "table" then
                _G.cmp = nil
            end

            local ok_cmp, cmp = pcall(require, "cmp")
            if not (ok_cmp and type(cmp) == "table") then
                vim.notify("nvim-cmp not available (or wrong type)", vim.log.levels.WARN)
                return
            end

            local has_ap, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
            if has_ap and type(cmp_autopairs) ~= "table" then
                has_ap = false
                cmp_autopairs = nil
            end

            local has_npairs, npairs = pcall(require, "nvim-autopairs")
            if has_npairs and type(npairs) ~= "table" then
                has_npairs = false
                npairs = nil
            end

            local has_luasnip, luasnip = pcall(require, "luasnip")
            if has_luasnip and type(luasnip) ~= "table" then
                has_luasnip = false
                luasnip = nil
            end

            local has_kind, lspkind = pcall(require, "lspkind")
            if has_kind and type(lspkind) ~= "table" then
                has_kind = false
                lspkind = nil
            end

            -- setup autopairs if the module is valid
            if has_npairs and type(npairs.setup) == "function" then
                npairs.setup()
            end

            if
                has_ap
                and cmp_autopairs
                and type(cmp.event) == "table"
                and type(cmp.event.on) == "function"
                and type(cmp_autopairs.on_confirm_done) == "function"
            then
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end

            if has_luasnip and type(require) == "function" then
                pcall(function()
                    local loader = require "luasnip.loaders.from_vscode"
                    if type(loader) == "table" and type(loader.lazy_load) == "function" then
                        loader.lazy_load()
                    end
                end)
            end

            -- Optional bordered windows (only if present on this cmp version)
            local bordered_win = nil
            if
                type(cmp.config) == "table"
                and type(cmp.config.window) == "table"
                and type(cmp.config.window.bordered) == "function"
            then
                local ok1, w1 = pcall(cmp.config.window.bordered)
                local ok2, w2 = pcall(cmp.config.window.bordered)
                if ok1 and ok2 then
                    bordered_win = { completion = w1, documentation = w2 }
                end
            end

            -- Build sources (only add things that exist)
            local sources = {
                { name = "nvim_lsp" },
                { name = "buffer", max_item_count = 5 },
                { name = "path", max_item_count = 3 },
            }
            if has_luasnip then
                table.insert(sources, 2, { name = "luasnip", max_item_count = 3 })
            end
            if pcall(require, "copilot_cmp") or pcall(require, "copilot") then
                table.insert(sources, 1, { name = "copilot" })
            end

            cmp.setup {
                -- Don’t attach in special buffers
                enabled = function()
                    local bt = vim.bo.buftype
                    return bt ~= "prompt" and bt ~= "terminal" and bt ~= "nofile"
                end,
                completion = {
                    autocomplete = false,
                },
                snippet = has_luasnip and {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                } or nil,

                window = bordered_win, -- ok if nil

                mapping = cmp.mapping.preset.insert {
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-Space>"] = cmp.mapping.complete {},
                    ["<C-c>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm { select = true },
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif
                            has_luasnip
                            and luasnip
                            and luasnip.expand_or_jumpable
                            and luasnip:expand_or_jumpable()
                        then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif has_luasnip and luasnip and luasnip.jumpable and luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },

                sources = sources,

                formatting = (has_kind and lspkind and type(lspkind.cmp_format) == "function") and {
                    expandable_indicator = true,
                    format = lspkind.cmp_format {
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    },
                } or nil,

                experimental = { ghost_text = false },
            }
        end,
    },

    -- cmp sources (must load AFTER nvim-cmp)
    { "hrsh7th/cmp-nvim-lsp", dependencies = { "hrsh7th/nvim-cmp" } },
    { "hrsh7th/cmp-buffer", dependencies = { "hrsh7th/nvim-cmp" } },
    { "hrsh7th/cmp-path", dependencies = { "hrsh7th/nvim-cmp" } },
    { "saadparwaiz1/cmp_luasnip", dependencies = { "hrsh7th/nvim-cmp", "L3MON4D3/LuaSnip" } },
}
