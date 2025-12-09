-- LSP configuration for web development
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TypeScript/JavaScript LSP
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- Svelte LSP
        svelte = {},

        -- HTML LSP
        html = {},

        -- CSS LSP
        cssls = {},

        -- JSON LSP
        jsonls = {},
      },
    },
  },

  -- TypeScript tools integration
  {
    "jose-elias-alvarez/typescript.nvim",
    lazy = true,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("lazyvim.util").lsp.on_attach(function(_, buffer)
        vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", {
          buffer = buffer,
          desc = "Organize Imports",
        })
        vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", {
          buffer = buffer,
          desc = "Rename File",
        })
        vim.keymap.set("n", "<leader>cF", "<cmd>TypescriptFixAll<CR>", {
          buffer = buffer,
          desc = "Fix All",
        })
      end)
    end,
  },

  -- Mason for LSP/formatter/linter installation
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "prettier",
        "typescript-language-server",
        "svelte-language-server",
        "html-lsp",
        "css-lsp",
        "json-lsp",
      },
    },
  },

  -- Formatting with conform
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        typescript = { "prettier" },
        javascript = { "prettier" },
        jsx = { "prettier" },
        tsx = { "prettier" },
        svelte = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        bash = { "shfmt" },
        fish = { "fish_indent" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
