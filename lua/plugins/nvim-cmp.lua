return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path"
    },
    config = function()
        local cmp = require("cmp")
    cmp.setup({
        completion = {
            completeopt = "menu,menuone,preview,noselect",
                keyword_length = 2
        },
            window = {
  documentation = cmp.config.window.bordered(),
  completion = cmp.config.window.bordered()
},
            mapping = cmp.mapping.preset.insert({
                ["<Up>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<Down>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-p>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-n>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({select = false}),
                ["<C-e>"] = cmp.mapping.abort(),
            }),
            sources = cmp.config.sources({
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),
            formatting = {
  fields = {'menu', 'abbr', 'kind'},
  format = function(entry, item)
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
