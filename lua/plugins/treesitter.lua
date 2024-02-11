return {
    'nvim-treesitter/nvim-treesitter', 
    build = ":TSUpdate",
    config = function()
        require"nvim-treesitter.configs".setup {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "lua", 
                "css", 
                "html", 
                "javascript",
                "json",
                "scss",
                "typescript",
                "yaml",
            }
        }
    end
}
