-- Enhanced tmux integration for Neovim

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
    if filename:match('_spec%.rb$') then
      cmd = "bundle exec rspec " .. filename
    elseif filename:match('_test%.rb$') then
      cmd = "bundle exec ruby -Itest " .. filename
    else
      -- Try to find and run the corresponding test file
      local test_file = filename:gsub('%.rb$', '_spec.rb')
      if vim.fn.filereadable(test_file) == 1 then
        cmd = "bundle exec rspec " .. test_file
      else
        test_file = filename:gsub('%.rb$', '_test.rb')
        if vim.fn.filereadable(test_file) == 1 then
          cmd = "bundle exec ruby -Itest " .. test_file
        else
          print("No test file found for " .. filename)
          return
        end
      end
    end
  elseif filetype == 'python' then
    if filename:match('test_.+%.py$') or filename:match('_test%.py$') then
      cmd = "python -m pytest " .. filename .. " -v"
    else
      -- Try to find the corresponding test file
      local test_file = filename:gsub('%.py$', '_test.py')
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
    if filename:match('%.spec%.[jt]s') or filename:match('%.test%.[jt]s') then
      cmd = "npm test -- " .. filename
    else
      -- Try to find the corresponding test file
      local test_file = filename:gsub('%.[jt]s$', '.spec.%1')
      if vim.fn.filereadable(test_file) == 1 then
        cmd = "npm test -- " .. test_file
      else
        test_file = filename:gsub('%.[jt]s$', '.test.%1')
        if vim.fn.filereadable(test_file) == 1 then
          cmd = "npm test -- " .. test_file
        else
          print("No test file found for " .. filename)
          return
        end
      end
    end
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
    if filename:match('_spec%.rb$') then
      cmd = "bundle exec rspec " .. filename .. ":" .. line_number
    elseif filename:match('_test%.rb$') then
      cmd = "bundle exec ruby -Itest " .. filename .. " --name='/test_.\\+_" .. line_number .. "/'"
    else
      print("Not in a test file")
      return
    end
  elseif filetype == 'python' then
    if filename:match('test_.+%.py$') or filename:match('_test%.py$') then
      -- Try to get the test name from the current line or above
      local test_line = line_number
      local test_name = nil
      
      while test_line > 0 and test_name == nil do
        local line = vim.fn.getline(test_line)
        local match = line:match('def%s+(test_[%w_]+)')
        if match then
          test_name = match
          break
        end
        test_line = test_line - 1
      end
      
      if test_name then
        cmd = "python -m pytest " .. filename .. "::" .. test_name .. " -v"
      else
        print("No test function found near line " .. line_number)
        return
      end
    else
      print("Not in a test file")
      return
    end
  elseif filetype == 'javascript' or filetype == 'typescript' or filetype == 'javascriptreact' or filetype == 'typescriptreact' then
    -- Look for the closest test or describe block
    local test_line = line_number
    local test_name = nil
    
    while test_line > 0 and test_name == nil do
      local line = vim.fn.getline(test_line)
      local match = line:match('it%s*%([\'"](.-)[\'"]')
      if match then
        test_name = match
        break
      end
      
      match = line:match('describe%s*%([\'"](.-)[\'"]')
      if match then
        test_name = match
        break
      end
      
      test_line = test_line - 1
    end
    
    if test_name then
      cmd = "npm test -- " .. filename .. " -t \"" .. test_name .. "\""
    else
      print("No test or describe block found near line " .. line_number)
      return
    end
  else
    print("Running nearest test not supported for filetype: " .. filetype)
    return
  end
  
  M.send_to_tmux(cmd)
end

-- Function to run the current file
function M.run_current_file()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%:p')
  local cmd = ""
  
  if filetype == 'ruby' then
    cmd = "ruby " .. filename
  elseif filetype == 'python' then
    cmd = "python " .. filename
  elseif filetype == 'javascript' or filetype == 'typescript' then
    cmd = "node " .. filename
  elseif filetype == 'sh' or filetype == 'bash' or filetype == 'zsh' then
    cmd = "bash " .. filename
  elseif filetype == 'lua' then
    cmd = "lua " .. filename
  else
    print("Running not supported for filetype: " .. filetype)
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
  local sessions_output = vim.fn.system("tmux list-sessions -F '#S'")
  local sessions = {}
  
  for session in sessions_output:gmatch("([^\n]+)") do
    table.insert(sessions, session)
  end
  
  if #sessions == 0 then
    print("No tmux sessions found")
    return
  end
  
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

-- Function to list tmux sessions
function M.list_sessions()
  local sessions_output = vim.fn.system("tmux list-sessions")
  print(sessions_output)
end

-- Function to setup tmux integration
function M.setup()
  -- Only setup if we're running inside tmux
  if vim.fn.exists('$TMUX') == 1 then
    vim.keymap.set("n", "<leader>tr", function() M.run_selection_or_line() end, { desc = "Run current line in tmux" })
    vim.keymap.set("v", "<leader>tr", function() M.run_selection_or_line() end, { desc = "Run selection in tmux" })
    vim.keymap.set("n", "<leader>tf", function() M.run_current_file() end, { desc = "Run current file" })
    vim.keymap.set("n", "<leader>tt", function() M.run_test_file() end, { desc = "Run current test file" })
    vim.keymap.set("n", "<leader>tn", function() M.run_nearest_test() end, { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tw", function() M.create_window() end, { desc = "Create new tmux window" })
    vim.keymap.set("n", "<leader>tW", function() M.create_window(vim.fn.input("Window name: ")) end, { desc = "Create named tmux window" })
    vim.keymap.set("n", "<leader>ts", function() M.create_session() end, { desc = "Create new tmux session" })
    vim.keymap.set("n", "<leader>ta", function() M.attach_session() end, { desc = "Attach to tmux session" })
    vim.keymap.set("n", "<leader>tl", function() M.list_sessions() end, { desc = "List tmux sessions" })
    
    -- Display a message
    print("Tmux integration enabled")
  end
end

-- Set this up as a Neovim plugin
return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  config = function()
    -- Set up tmux integration if we're in tmux
    if vim.fn.exists('$TMUX') == 1 then
      M.setup()
    end
  end,
}