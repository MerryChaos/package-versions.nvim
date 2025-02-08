local M = {}

local namespace = vim.api.nvim_create_namespace('package-versions')

local function update_virtual_text()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

  local packages = require('package-versions.package_json').get_packages(bufnr)
  if not packages then
    print('Failed to parse package.json')
    return
  end

  local registry = require('package-versions.registry')
  for _, pkg in ipairs(packages) do
    registry.fetch_latest_version(pkg.name, function(package_info)
      if package_info then
        vim.schedule(function()
          local success, json = pcall(vim.fn.json_decode, package_info)
          local virtual_text
          local virtual_text_type
          if success then
            local stripped_version = string.match(pkg.version, '^[%^~]?([%d%.]+)')
            if json.version == stripped_version then
              virtual_text = string.format('✓ %s', json.version)
              virtual_text_type = '@comment.hint'
            else
              virtual_text = string.format('✗ %s', json.version)
              virtual_text_type = '@comment.warning'
            end
          else
            virtual_text = 'Failed to fetch latest version'
            virtual_text_type = '@comment.error'
          end
          vim.api.nvim_buf_set_extmark(bufnr, namespace, pkg.line, 0, {
            virt_text = { { virtual_text, virtual_text_type } },
            virt_text_pos = 'eol',
          })
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
end

return M
