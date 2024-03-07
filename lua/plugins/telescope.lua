return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup({
            pickers = {
                oldfiles = {
                    cwd_only = true,
                }
            },
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>bb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
        vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
        vim.keymap.set('n', '<leader>gs', builtin.live_grep, {})
    end
}
