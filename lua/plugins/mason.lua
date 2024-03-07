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
          "prettierd",           -- prettier formatter
          "prettier",            -- prettier formatter
          "eslint_d",            -- js linter
          "eslint"
        },
      })

      vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          local function lsp_buf_definition_with_qf_close()
            -- Call the original LSP 'go to definition' function
            vim.lsp.buf.definition()

            -- Use an autocmd to modify the quickfix window after it's populated
            vim.api.nvim_create_autocmd("FileType", {
              pattern = "qf",
              callback = function()
                -- Temporarily set key mappings in the quickfix window to close it upon selection
                vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<CR>:cclose<CR>',
                  { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(0, 'n', 'o', 'o:cclose<CR>',
                  { noremap = true, silent = true })
              end,
              -- Make this autocmd temporary by automatically removing it after it triggers once
              once = true,
            })
          end
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', lsp_buf_definition_with_qf_close, opts)
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
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          -- Default handler with added capabilities for LSP
          local opts = {
            capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol
              .make_client_capabilities())
          }

          require("lspconfig")[server_name].setup(opts)
        end,
      })
    end
  },
  { "neovim/nvim-lspconfig", event = { "BufReadPost", "BufNewFile" } }
}
