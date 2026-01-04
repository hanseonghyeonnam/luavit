package.path = "?.lua;?/init.lua;" .. package.path
local args = { ... }


-- Main config
local config = {
  NonMemoryExecution = false
}

local function async(func)
  func()
end

local function isempty(s)
  return s == nil or s == ''
end

local function exists(filename)
  local f = io.open(filename, "r")
  if f then
    f:close()
    return true
  end
  return false
end

local function keyPath(author, fingerprint)
  return string.format("keys/%s/%s", author, fingerprint:gsub(":", "_"))
end

local function exec(command)
    local handle = io.popen(command, 'r')
    if handle then
        local result = handle:read('*a')
        handle:close()
        return result
    else
        return nil, "Failed to execute command"
    end
end

local function argv_after_dashdash(argv)
  local out = {}
  local hit = false
  for _, v in ipairs(argv) do
    if hit then
      out[#out+1] = v
    elseif v == "--" then
      hit = true
    end
  end
  return out
end

local function shell_join(t)
  local out = {}
  for _, v in ipairs(t) do
    out[#out+1] = '"' .. tostring(v) .. '"'
  end
  return table.concat(out, " ")
end

local function table_includes(tbl, val)
    for _, value in pairs(tbl) do
        if value == val then
            return true -- Value found
        end
    end
    return false -- Value not found after checking all elements
end


async(function ()
  local fileName = args[1]

  if not fileName then
    print("Usage: luavit <lua file> {options} -- {sub options for lua file}")
    return
  end

  if not exists(fileName) then
    print("File not exists:", fileName)
    return
  end

  if exists("./luavit.json") then
    local raw = io.open("./luavit.json", "r"):read("*a")

    for key, value in raw:gmatch("(%w+)%s*:%s*(%w+)") do

      if value == "true" then
        config[key] = true
      elseif value == "false" then
        config[key] = false
      else
        config[key] = value
      end
    end
  end


  local file = io.open(fileName, "r")
  local path = string.format("%s.%s", fileName:gsub(".lua", ""), "transpiled.lua")
  local after_args = argv_after_dashdash(args)
  local final = shell_join(after_args)

  local content = [[
package.path = "?.lua;?/init.lua;" .. package.path

local luavit = {}
function luavit.stop()
  os.exit()
end

local unpack = unpack or table.unpack
function table.slice(tbl, first, last, step)
    local sliced = {}
    first = first or 1
    last = last or #tbl
    step = step or 1
    return {unpack(tbl, first, last)}
end

function luavit.args()
  local out = {}
  for i, v in ipairs(process.argv) do
    out[i] = v
  end
  out[1] = "test.lua"
  return out
end

function luavit.runtime()
  local runtime = {}
  runtime.engine = "luavit-1.0.9.beta"
  runtime.wrapper = "luavit"
  return runtime
end

function luavit.exists(filename)
  local f = io.open(filename, "r")
  if f then
    f:close()
    return true
  end
  return false
end

function luavit.exec(command)
    local handle = io.popen(command, 'r')
    if handle then
        local result = handle:read('*a')
        handle:close()
        return result
    else
        return nil, "Failed to execute command"
    end
end

function luavit.isempty(s) return s == nil or s == '' end

]] .. (file:read("*a"))

  :gsub(
  'import%s+(%w+)%s+from%s+["\']([^"\']+)["\']',
  'local %1 = require("%2")'
  )
  :gsub(
  'import%s+{%s*(.-)%s*}%s+from%s+["\']([^"\']+)["\']',
  function(vars, mod)
    local out = {}
    table.insert(out, 'local __mod = require("'..mod..'")')
    for v in vars:gmatch("%w+") do
      table.insert(out, "local "..v.." = __mod."..v)
    end
    return table.concat(out, "\n")
  end
  )

  :gsub("//", "--")

  -- memory execution [default]
  if not config.NonMemoryExecution then
    local tmp = os.tmpname() .. ".lua"
    local f = io.open(tmp, "w")
    f:write(content)
    f:close()

    local stdout = exec("luvit " .. tmp .. " " .. final)
    if stdout then print(stdout) end
    os.remove(tmp)
    os.exit()
  end



  local file_IO = io.open(path, "w")

  file_IO:write(content)

  file_IO:close()
  file:close()

  local stdout = exec("luvit " .. path .. " " .. final)

  if stdout then
    print(stdout)
  else
    print("")
  end

  if not args[2] or args[2] ~= "--save" and args[2] ~= "-s" then
    os.remove(path)
  end
end)