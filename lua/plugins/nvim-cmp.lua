return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",         -- Adding LuaSnip as a dependency
        "saadparwaiz1/cmp_luasnip", -- Adding cmp_luasnip to use LuaSnip with nvim-cmp
        "zbirenbaum/copilot-cmp",
    },
    config = function()
        local kind_icons = {
            Copilot = '',
            Text = "",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰇽",
            Variable = "󰂡",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰅲",
        }
        local cmp = require("cmp")
        local copilot_cmp = require("copilot_cmp")
        copilot_cmp.setup()

        local luasnip = require("luasnip")
        luasnip.config.set_config({
            history = true,
            updateevents = "TextChanged,TextChangedI",
        })
        require("luasnip.loaders.from_vscode").lazy_load() -- Load any VSCode style snippets

        local has_words_before = function()
            if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
        end

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body) -- This tells nvim-cmp how to expand snippets using LuaSnip
                end,
            },
            completion = {
                completeopt = "menu,menuone,preview,noselect",
                keyword_length = 2
            },
            window = {
                documentation = cmp.config.window.bordered(),
                completion = cmp.config.window.bordered()
            },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = vim.schedule_wrap(function(fallback)
                    if cmp.visible() and has_words_before() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end),
                ["<S-Tab>"] = vim.schedule_wrap(function(fallback)
                    if cmp.visible() and has_words_before() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<C-e>"] = cmp.mapping.abort(),
            }),
            sources = cmp.config.sources({
                { name = "copilot" },  -- text within current buffer
                { name = "nvim_lsp" }, -- text within current buffer
                { name = "luasnip" },
                { name = "buffer" },   -- text within current buffer
                { name = "path" },     -- file system paths
            }),
            formatting = {
                fields = { 'menu', 'abbr', 'kind' },
                format = function(entry, item)
                    item.kind = string.format('%s %s', kind_icons[item
                        .kind], item
                        .kind) -- This concatenates the icons with the name of the item kind
                    local menu_icon = {
                        copilot = '',
                        nvim_lsp = 'λ',
                        luasnip = '⋗',
                        buffer = 'Ω',
                        path = '🖫',
                    }

                    item.menu = menu_icon[entry.source.name]
                    return item
                end,
            },
        })
    end
}
