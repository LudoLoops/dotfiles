-- Terminal integration with Fish shell
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "float",
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
        shell = vim.o.shell,
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local fish_term = Terminal:new({ cmd = "fish", hidden = true })

      function _fish_toggle()
        fish_term:toggle()
      end

      vim.keymap.set("n", "<leader>tf", "<cmd>lua _fish_toggle()<CR>", {
        noremap = true,
        silent = true,
        desc = "Toggle Fish Terminal",
      })

      -- Also available: <C-\> for any terminal
    end,
  },
}
