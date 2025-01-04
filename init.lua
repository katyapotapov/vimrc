-- 1) Define Lua functions that replicate your top-level search logic.

local function jump_next_top_level_function()
  -- Save cursor position
  local save_pos = vim.fn.getcurpos()
  -- Current indentation
  local current_indent = vim.fn.indent(".")

  -- Search pattern:
  --   ^\s*             (start of line + possible leading spaces)
  --   \(async\s\+\)\?  (optional 'async' + space)
  --   def\s\+          (the 'def' keyword plus at least one space)
  --   \k\+\s*(         (function name + optional spaces + '(')
  --
  -- 'W' means "search forward without wrapping".
  -- If you'd like wrapping, use 'w' instead of 'W'.
  while vim.fn.search([[^\s*\(async\s\+\)\?def\s\+\k\+\s*(]], "W") > 0 do
    -- Check indent; if same or shallower, stop.
    if vim.fn.indent(".") <= current_indent then
      return
    end
  end

  -- If no suitable match found, restore cursor.
  vim.fn.setpos(".", save_pos)
end

local function jump_prev_top_level_function()
  -- Save cursor
  local save_pos = vim.fn.getcurpos()
  local current_indent = vim.fn.indent(".")

  -- 'bW' means "search backward without wrapping".
  while vim.fn.search([[^\s*\(async\s\+\)\?def\s\+\k\+\s*(]], "bW") > 0 do
    if vim.fn.indent(".") <= current_indent then
      return
    end
  end

  vim.fn.setpos(".", save_pos)
end

-- 2) Create user commands so you can run :JumpNextTopLevelFunction or :JumpPrevTopLevelFunction
vim.api.nvim_create_user_command("JumpNextTopLevelFunction", function()
  jump_next_top_level_function()
end, {})

vim.api.nvim_create_user_command("JumpPrevTopLevelFunction", function()
  jump_prev_top_level_function()
end, {})

-- 3) Map them to keys (]f and [f are typically free)
vim.keymap.set("n", "]f", jump_next_top_level_function, { desc = "Next top-level function" })
vim.keymap.set("n", "[f", jump_prev_top_level_function, { desc = "Prev top-level function" })

-- Source vimscript
vim.cmd("source ~/.config/nvim/init2.vim")

