-- lua/plugins/navigation.lua --- FZF-Lua & Flash

-- Helper: get the directory of the current buffer (falls back to cwd)
local function bufdir()
  local buf = vim.api.nvim_buf_get_name(0)
  if buf ~= "" then return vim.fn.fnamemodify(buf, ":p:h") end
  return vim.fn.getcwd()
end

-- Helper: git root resolved from the current buffer's location
local function git_root()
  local dir = bufdir()
  local root = vim.trim(vim.fn.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }))
  if vim.v.shell_error == 0 then return root end
  return nil
end

return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      -- Global Search
      { "<leader><leader>", "<cmd>FzfLua commands<cr>", desc = "M-x (commands)" },
      { "<leader>bb", "<cmd>FzfLua buffers<cr>", desc = "Switch buffer" },
      { "<leader>ff", function() require("fzf-lua").files({ cwd = bufdir() }) end, desc = "Find file" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
      { "<leader>/",  function() require("fzf-lua").live_grep_native({ cwd = git_root() or bufdir() }) end, desc = "Ripgrep project" },
      { "<leader>sl", "<cmd>FzfLua blines<cr>", desc = "Consult line" },
      { "<leader>si", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Imenu (symbols)" },
      { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help tags" },
      { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command history" },
      { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
      { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>ry", "<cmd>FzfLua registers<cr>", desc = "Kill ring" },
      { "<leader>ss", function() require("fzf-lua").live_grep_native({ cwd = git_root() or bufdir() }) end, desc = "Search Project" },

      -- Project Search (Spacemacs SPC p)
      { "<leader>pf", function()
          require("fzf-lua").files({ cwd = git_root() or bufdir() })
        end, desc = "Find file in project" },
      { "<leader>pp", function()
          local root = git_root()
          if root then
            require("fzf-lua").git_files({ cwd = root })
          else
            require("fzf-lua").files({ cwd = bufdir() })
          end
        end, desc = "Switch project" },
    },
    opts = {
      "default-title",
      fzf_opts = { ["--layout"] = "default" },
      file_icons = false,
      git_icons = false,
      winopts = {
        preview = { layout = "vertical", icons = false },
      },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>jj", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Jump" },
      { "<leader>jl", mode = { "n", "x", "o" }, function() require("flash").jump({ search = { mode = "search", max_length = 0 } }) end, desc = "Jump line" },
      { "<leader>jw", mode = { "n", "x", "o" }, function() require("flash").jump({ pattern = ".", search = { mode = "search", max_length = 1 } }) end, desc = "Jump word" },
    },
  },
}
