-- lua/core/options.lua --- Sane Defaults & Performance

local opt = vim.opt

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.local/state/nvim/undo")

opt.number = true
opt.relativenumber = false
opt.signcolumn = "yes"
opt.list = true
opt.listchars = { trail = "·", tab = "  " }

opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 200
opt.timeoutlen = 400

-- Highlight on yank (Pulse effect)
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup="IncSearch", timeout=200 })
  end,
})
