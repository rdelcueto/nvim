-- Helper: git root resolved from the current buffer's location
local function git_root()
  local buf = vim.api.nvim_buf_get_name(0)
  local dir = buf ~= "" and vim.fn.fnamemodify(buf, ":p:h") or vim.fn.getcwd()
  local root = vim.trim(vim.fn.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }))
  if vim.v.shell_error == 0 then return root end
  return nil
end

return {
  -- Neogit: Magit-clone for Neovim (Muscle memory preservation)
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" }, 
    keys = {
      { "<leader>gg", function() require("neogit").open({ cwd = git_root() }) end, desc = "Neogit Status" },
      { "<leader>gc", function() require("neogit").open({ "commit", cwd = git_root() }) end, desc = "Neogit Commit" },
      { "<leader>gp", function() require("neogit").open({ "push", cwd = git_root() }) end, desc = "Neogit Push" },
      { "<leader>gl", function() require("neogit").open({ "log", cwd = git_root() }) end, desc = "Neogit Log" },
    },
    opts = {
      disable_insert_on_commit = "auto",
      integrations = { diffview = false },
    },
  },

  -- Gitsigns: Inline hunk info
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    keys = {
      { "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next hunk" },
      { "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Prev hunk" },
      { "<leader>ghs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
      { "<leader>ghr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
      { "<leader>ghp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
      { "<leader>gb",  function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame line" },
    },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
      },
    },
  },

  -- Oil.nvim: Writable Dired replacement
  {
    "stevearc/oil.nvim",
    keys = {
      { "<leader>fd", "<cmd>Oil<CR>", desc = "Dired" },
      { "-", "<cmd>Oil<CR>", desc = "Dired (Up)" },
    },
    opts = {
      columns = {}, 
      view_options = { show_hidden = true },
      keymaps = {
        ["h"] = "actions.parent",
        ["l"] = "actions.select",
        ["q"] = "actions.close",
      },
    },
  },

  -- Editing Utilities
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", config = true },
  -- Note: Commenting is handled by Neovim 0.10+ native 'gc' maps.

  -- Persistence: Simple session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    },
  },


  -- Diffview: VCS history navigation
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Repo History" },
    },
    opts = {
      enhanced_diff_hl = true,
      icons_enabled = false,
    },
  },
}
