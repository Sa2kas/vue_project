local rpc = require 'vuci.rpc'
local ucis = require 'ucis'
local uci = require 'uci'

local M = {
  ERROR_ENTRY_EXISTS = "Such entry in firewall already exists!"
}

M.add_to_firewall = function (values, type, name)
  local params = {}
  params.values = values
  params.type = type
  params.name = name
  params.config = 'firewall'
  return ucis.add(params)
end

M.add_rule = function (params)
  local c = uci.cursor()
  local name = params.name
  local matched = false
  c:foreach("firewall", "rule", function (s)
    if s.name == name then
      matched = true
    end
  end)
  if not matched then
    return M.add_to_firewall(params, "rule")
  else
    return { M.ERROR_ENTRY_EXISTS }
  end
end

M.add_forward = function (params)
  local c = uci.cursor()
  local src, dest = params.src, params.dest
  local matched = false  c:foreach("firewall", "forwarding", function (s)
    if s.src == src and s.dest == dest then
      matched = true
    end
  end)
  if not matched then
    return M.add_to_firewall(params, "forwarding")
  else
    return M.ERROR_ENTRY_EXISTS
  end
end

M.add_zone = function (params)
  local c = uci.cursor()
  local name = params.name
  local matched = false
  c:foreach("firewall", "zone", function(s)
    if s.name == name then
      matched = true
    end
  end)
  if not matched then
    return M.add_to_firewall(params, "zone")
  else
    return M.ERROR_ENTRY_EXISTS
  end
end

M.get = function(section, param, value, return_param)
  local c = uci.cursor()
  local result = nil
  c:foreach("firewall", section, function (s)
    if s[param] == value then
      if return_param ~= nil then
        result = s[return_param]
      else
        result = s
      end
    end
  end)
  return result
end

M.get_zone_by = function (params)
  M.get('zone',params.param, params.value, params.only)
end

M.delete = function(params)
  params.section = params.sid
  params.sid = nil
  params.config = 'firewall'
  ucis.delete(params)
end

return