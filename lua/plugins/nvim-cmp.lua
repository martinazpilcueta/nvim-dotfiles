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
            completeopt = "menu,menuone,preview,noselect"
        },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-n>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
            }),
            sources = cmp.config.sources({
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      })
        })
    end
    }
