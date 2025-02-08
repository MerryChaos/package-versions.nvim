local M = {}

local namespace_id = vim.api.nvim_create_namespace('package-versions')

local highlights = {
  ok = 'Comment',
  warning = 'WarningMsg',
  error = 'ErrorMsg',
}

local function update_virtual_text_line(bufnr, line, text, highlight)
  vim.api.nvim_buf_set_extmark(bufnr, namespace_id, line, 0, {
    virt_text = { { text, highlight } },
    virt_text_pos = 'eol',
  })
end

local function update_virtual_text()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, namespace_id, 0, -1)

  local packages = require('package-versions.package_json').get_packages(bufnr)
  if not packages then
    return
  end

  local registry = require('package-versions.registry')
  for _, pkg in ipairs(packages) do
    registry.fetch_latest_version(pkg.name, function(package_info)
      if package_info then
        vim.schedule(function()
          local json = vim.fn.json_decode(package_info)
          if json == 'Not Found' then
            update_virtual_text_line(bufnr, pkg.line, '! Package not found', highlights.error)
            return
          end

          local stripped_version = string.match(pkg.version, '^[%^~]?([%d%.]+)')
          if json.version == stripped_version then
            update_virtual_text_line(bufnr, pkg.line, string.format('✓ %s', json.version), highlights.ok)
            return
          end

          update_virtual_text_line(bufnr, pkg.line, string.format('✗ %s', json.version), highlights.warning)
        end)
      end
    end)
  end
end

function M.setup(opts)
  opts = opts or {}
  local autocmds = opts.autocmds or {
    'BufReadPost',
    'BufWritePost',
  }

  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(autocmd, {
      pattern = 'package.json',
      callback = function()
        update_virtual_text()
      end,
    })
  end

  -- Set custom highlights
  if opts.highlights then
    for key, value in pairs(opts.highlights) do
      highlights[key] = value
    end
  end
end

return M
