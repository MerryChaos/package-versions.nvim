local M = {}

local function get_line_number(bufnr, package_name)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    local pattern = string.format('"%s": "(.-)"', package_name:gsub("%-", "%%-"))
    if line:match(pattern) then
      return i - 1
    end
  end
  return nil
end

function M.get_packages(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local package_json_str = table.concat(lines, '\n')
  local success, package_json = pcall(vim.fn.json_decode, package_json_str)
  if not success then
    return nil
  end

  local packages = {}

  for key, value in pairs(package_json) do
    if key:match("ependencies$") then
      for package_name, version in pairs(value) do
        packages[#packages + 1] = { name = package_name, version = version, line = get_line_number(bufnr, package_name) }
      end
    end
  end

  return packages
end

return M
