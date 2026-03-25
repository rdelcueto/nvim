-- lua/plugins/ide.lua --- Treesitter, Blink.cmp, and Native LSP

return {
  -- Treesitter: AST-based highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "c", "cpp", "python", "rust", "lua", "bash", "markdown", "vimdoc", "org" },
      highlight = {
        enable = true,
        disable = function(lang, buf)
          return vim.b[buf].large_file
        end,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      -- Select textobjects
      local sel = function(key, query)
        vim.keymap.set({ "x", "o" }, key, function()
          require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
        end)
      end
      sel("af", "@function.outer")
      sel("if", "@function.inner")
      sel("ac", "@class.outer")
      sel("ic", "@class.inner")

      -- Move to textobjects
      local next_start = function(key, query)
        vim.keymap.set({ "n", "x", "o" }, key, function()
          require("nvim-treesitter-textobjects.move").goto_next_start(query, "textobjects")
        end)
      end
      local prev_start = function(key, query)
        vim.keymap.set({ "n", "x", "o" }, key, function()
          require("nvim-treesitter-textobjects.move").goto_previous_start(query, "textobjects")
        end)
      end
      next_start("]m", "@function.outer")
      next_start("]c", "@class.outer")
      prev_start("[m", "@function.outer")
      prev_start("[c", "@class.outer")
    end,
  },

  -- Blink.cmp: Rust-backed completion (No dependencies)
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = {
        preset = "default",
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
        kind_icons = {}
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- Trouble: Diagnostics and Location lists
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>ed", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>eb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>es", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
    },
    opts = { icons = { indent = { fold_open = "v", fold_closed = ">" } } },
  },

  -- Conform: Lightweight universal formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      { "<localleader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
      },
    },
  },

  -- Native LSP Setup (Neovim 0.11+ Pattern)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Global defaults for all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Enable servers (configs loaded from nvim-lspconfig/lsp/*.lua)
      vim.lsp.enable({ "ty", "rust_analyzer", "clangd" })

      -- Major Mode Leader Bindings (Local Leader)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local m = function(k, f, d) vim.keymap.set("n", k, f, { buffer = args.buf, desc = d }) end
          m("<localleader>la", vim.lsp.buf.code_action, "Code actions")
          m("<localleader>lr", vim.lsp.buf.rename, "Rename symbol")
          m("<localleader>lf", vim.lsp.buf.format, "Format buffer")
          m("<localleader>ld", vim.lsp.buf.hover, "Documentation")
          m("<localleader>li", "<cmd>FzfLua lsp_implementations<cr>", "Implementations")
          m("<localleader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", "Document symbols")
          m("<localleader>lS", "<cmd>FzfLua lsp_workspace_symbols<cr>", "Workspace symbols")
          m("<localleader>le", vim.diagnostic.open_float, "Show diagnostic")
          m("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
          m("]d", vim.diagnostic.goto_next, "Next diagnostic")
          m("gd", vim.lsp.buf.definition, "Jump to definition")
          m("gr", "<cmd>FzfLua lsp_references<cr>", "Jump to references")
        end,
      })
    end,
  },
}
