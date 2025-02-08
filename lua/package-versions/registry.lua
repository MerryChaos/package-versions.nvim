local M = {}

local uv = vim.loop

function M.fetch_latest_version(package_name, callback)
  local handle
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local stdout_data = ""
  local stderr_data = ""

  handle = uv.spawn("curl", {
    args = { "-s", "https://registry.npmjs.org/" .. package_name .. "/latest" },
    stdio = { nil, stdout, stderr },
  }, function(code, _)
    stdout:close()
    stderr:close()
    handle:close()
    if code == 0 then
      callback(stdout_data)
    else
      print("Failed to fetch latest version for " .. package_name)
      print("stderr: " .. stderr_data)
      callback(nil)
    end
  end)

  stdout:read_start(function(err, data)
    assert(not err, err)
    if data then
      stdout_data = stdout_data .. data
    end
  end)

  stderr:read_start(function(err, data)
    assert(not err, err)
    if data then
      stderr_data = stderr_data .. data
    end
  end)
end

return M
