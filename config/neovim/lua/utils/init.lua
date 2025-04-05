local M = {}

-- Function to check if a file exists
M.file_exists = function(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- Function to load a module safely
M.safe_require = function(module)
  local status, result = pcall(require, module)
  if status then
    return result
  else
    vim.notify("Error loading " .. module .. ": " .. result, vim.log.levels.ERROR)
    return nil
  end
end

return M
