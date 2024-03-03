return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",         -- Adding LuaSnip as a dependency
        "saadparwaiz1/cmp_luasnip", -- Adding cmp_luasnip to use LuaSnip with nvim-cmp
    },
    config = function()
        local kind_icons = {
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
        local luasnip = require("luasnip")
        luasnip.config.set_config({
            history = true,
            updateevents = "TextChanged,TextChangedI",
        })
        require("luasnip.loaders.from_vscode").lazy_load() -- Load any VSCode style snippets
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
                ["<Up>"] = cmp.mapping.select_prev_item(),   -- previous suggestion
                ["<Down>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-p>"] = cmp.mapping.select_prev_item(),  -- previous suggestion
                ["<C-n>"] = cmp.mapping.select_next_item(),  -- next suggestion
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<C-e>"] = cmp.mapping.abort(),
            }),
            sources = cmp.config.sources({
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
