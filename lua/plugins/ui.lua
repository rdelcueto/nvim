-- lua/plugins/ui.lua --- Themes, Statusline (No Icons)

return {
  -- Which-Key (Discovery)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      icons = { enabled = false },
      delay = 400,
    },
  },
  
  -- Modus Themes (High Contrast, Mnemonic)
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    config = function()
      require("modus-themes").setup({ style = "vivendi" })
      vim.cmd("colorscheme modus")
    end,
  },

  -- Lualine (Minimalist Statusline)
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "modus-vivendi",
        icons_enabled = false,
        component_separators = "|",
        section_separators = "",
      },
    },
  },

}
