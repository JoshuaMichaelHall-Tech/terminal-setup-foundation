-- Path: ~/.config/nvim/lua/plugins/custom/tmux.lua

local M = {}

-- Function to send command to tmux
function M.send_tmux_cmd(cmd)
  vim.fn.system('tmux ' .. cmd)
end

-- Function to run a command in a tmux pane
function M.send_to_tmux(cmd, pane)
  pane = pane or ""
  cmd = cmd:gsub("'", "'\\''") -- Escape single quotes
  M.send_tmux_cmd("send-keys -t " .. pane .. " '" .. cmd .. "' Enter")
end

-- Function to run command or selection in tmux
function M.run_selection_or_line()
  local mode = vim.fn.mode()
  local cmd = ""

  if mode == 'v' or mode == 'V' then
    -- Get visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getline(start_pos[2], end_pos[2])
    
    if #lines == 0 then
      return
    end
    
    if mode == 'v' then
      -- Trim first and last line for visual mode
      if #lines == 1 then
        lines[1] = lines[1]:sub(start_pos[3], end_pos[3])
      else
        lines[1] = lines[1]:sub(start_pos[3])
        lines[#lines] = lines[#lines]:sub(1, end_pos[3])
      end
    end
    
    cmd = table.concat(lines, "\n")
  else
    -- Get current line
    cmd = vim.fn.getline('.')
  end
  
  if cmd == "" then
    return
  end
  
  M.send_to_tmux(cmd)
end

-- Function to run test file based on filetype
function M.run_test_file()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%:p')
  local cmd = ""
  
  if filetype == 'ruby' then
    if filename:match('_spec%.rb) then
      cmd = "bundle exec rspec " .. filename
    elseif filename:match('_test%.rb) then
      cmd = "bundle exec ruby -Itest " .. filename
    else
      -- Try to find and run the corresponding test file
      local test_file = filename:gsub('%.rb, '_spec.rb')
      if vim.fn.filereadable(test_file) == 1 then
        cmd = "bundle exec rspec " .. test_file
      else
        test_file = filename:gsub('%.rb, '_test.rb')
        if vim.fn.filereadable(test_file) == 1 then
          cmd = "bundle exec ruby -Itest " .. test_file
        else
          print("No test file found for " .. filename)
          return
        end
      end
    end
  elseif filetype == 'python' then
    if filename:match('test_.+%.py) or filename:match('_test%.py) then
      cmd = "python -m pytest " .. filename .. " -v"
    else
      -- Try to find the corresponding test file
      local test_file = filename:gsub('%.py, '_test.py')
      if vim.fn.filereadable(test_file) == 1 then
        cmd = "python -m pytest " .. test_file .. " -v"
      else
        test_file = vim.fn.expand('%:p:h') .. "/test_" .. vim.fn.expand('%:t')
        if vim.fn.filereadable(test_file) == 1 then
          cmd = "python -m pytest " .. test_file .. " -v"
        else
          print("No test file found for " .. filename)
          return
        end
      end
    end
  elseif filetype == 'javascript' or filetype == 'typescript' or filetype == 'javascriptreact' or filetype == 'typescriptreact' then
    cmd = "npm test -- " .. filename
  else
    print("Running tests not supported for filetype: " .. filetype)
    return
  end
  
  M.send_to_tmux(cmd)
end

-- Function to run nearest test
function M.run_nearest_test()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%:p')
  local line_number = vim.fn.line('.')
  local cmd = ""
  
  if filetype == 'ruby' then
    if filename:match('_spec%.rb) then
      cmd = "bundle exec rspec " .. filename .. ":" .. line_number
    elseif filename:match('_test%.rb) then
      cmd = "bundle exec ruby -Itest " .. filename .. " --name='/test_.\\+_" .. line_number .. "/'"
    else
      print("Not in a test file")
      return
    end
  elseif filetype == 'python' then
    if filename:match('test_.+%.py) or filename:match('_test%.py) then
      cmd = "python -m pytest " .. filename .. "::$(sed -n " .. line_number .. "p " .. filename .. " | grep -o 'def test[a-zA-Z0-9_]\\+' | sed 's/def //')"
    else
      print("Not in a test file")
      return
    end
  elseif filetype == 'javascript' or filetype == 'typescript' or filetype == 'javascriptreact' or filetype == 'typescriptreact' then
    cmd = "npm test -- " .. filename .. " -t \"$(sed -n " .. line_number .. "p " .. filename .. " | grep -o 'test(\\'[^']*\\'' | sed 's/test(\\'//')\""
  else
    print("Running nearest test not supported for filetype: " .. filetype)
    return
  end
  
  M.send_to_tmux(cmd)
end

-- Function to create a new tmux window
function M.create_window(name)
  name = name or ""
  if name ~= "" then
    M.send_tmux_cmd("new-window -n " .. name)
  else
    M.send_tmux_cmd("new-window")
  end
end

-- Function to create a new tmux session
function M.create_session(name)
  name = name or vim.fn.input("Session name: ")
  if name ~= "" then
    M.send_tmux_cmd("new-session -d -s " .. name)
    M.send_tmux_cmd("switch-client -t " .. name)
  end
end

-- Function to attach to a tmux session
function M.attach_session()
  local sessions = vim.fn.systemlist("tmux list-sessions -F '#S'")
  local session_list = ""
  
  for i, session in ipairs(sessions) do
    session_list = session_list .. i .. ". " .. session .. "\n"
  end
  
  print(session_list)
  local choice = tonumber(vim.fn.input("Choose session (1-" .. #sessions .. "): "))
  
  if choice and choice >= 1 and choice <= #sessions then
    M.send_tmux_cmd("switch-client -t " .. sessions[choice])
  end
end

-- Set up keymaps
function M.setup_keymaps()
  local keymap = vim.keymap.set
  
  -- Run commands in tmux
  keymap("n", "<leader>tr", function() M.run_selection_or_line() end, { desc = "Run current line in tmux" })
  keymap("v", "<leader>tr", function() M.run_selection_or_line() end, { desc = "Run selection in tmux" })
  
  -- Run tests
  keymap("n", "<leader>tt", function() M.run_test_file() end, { desc = "Run current test file" })
  keymap("n", "<leader>tn", function() M.run_nearest_test() end, { desc = "Run nearest test" })
  
  -- Tmux window/session management
  keymap("n", "<leader>tw", function() M.create_window() end, { desc = "Create new tmux window" })
  keymap("n", "<leader>ts", function() M.create_session() end, { desc = "Create new tmux session" })
  keymap("n", "<leader>ta", function() M.attach_session() end, { desc = "Attach to tmux session" })
end

-- Initialize the module
function M.setup()
  -- Only setup if we're running inside tmux
  if vim.fn.exists('$TMUX') == 1 then
    M.setup_keymaps()
  end
end

return M