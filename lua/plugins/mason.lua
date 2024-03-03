return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local mason = require("mason")
            mason.setup()
            local mason_tool_installer = require("mason-tool-installer")

            -- enable mason and configure icons
            mason.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            mason_tool_installer.setup({
                ensure_installed = {
                    "prettierd", -- prettier formatter
                    "prettier",  -- prettier formatter
                    "eslint_d",  -- js linter
                },
            })

            vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'gr', require("telescope.builtin").lsp_references, opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)
                end
            })
            require("mason-lspconfig").setup {
                ensure_installed = { "lua_ls", "tsserver", "html", "marksman", "unocss", "yamlls" },
                automatic_installation = true
            }
            require("mason-lspconfig").setup_handlers {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {}
                end
            }
        end
    },
    { "neovim/nvim-lspconfig", event = { "BufReadPost", "BufNewFile" } }
}
