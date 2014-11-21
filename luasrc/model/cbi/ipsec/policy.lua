--[[
LuCI - Lua Configuration Interface

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

local ds = require "luci.dispatcher"

m = Map("ipsec", translate("IPSec"))

-- policy
s = m:section(TypedSection, "policy", translate("Policy"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true
s.extedit   = ds.build_url("admin", "services", "ipsec", "policy", "%s")

function s.create(...)
    local id = TypedSection.create(...)
    luci.http.redirect(
        ds.build_url("admin", "services", "ipsec", "policy", id)
    )
end

-- Name
name = s:option(DummyValue, "name", translate("Name"))
name.width = "15%"

-- Enable 
enable = s:option(Flag, "enable", translate("Enable"))
enable.rmempty = false

-- Local interface
interface = s:option(DummyValue, "left", translate("Local Interface"))
interface.template = "cbi/network_netinfo"
interface.width = "15%"


-- status
local status = s:option(DummyValue, "status", translate("Status"))
status.template = "ipsec/policy_status"
status.width = "20%"

-- Connect
local connect = s:option(Button, "_connect", translate("Connect"))
connect.inputstyle = "apply"
connect.width = "10%"
function connect.write(self, section, value)
    luci.sys.call("ubus call ipsec.policy.%s up" % name:cfgvalue(section))
end
function connect.cfgvalue(self, section)
    if enable:cfgvalue(section) == "1" then
        self.title = translate("Connect")
        self.inputstyle = "apply"
    else
        return false
    end
end

-- Disconect
local disconnect = s:option(Button, "_disconnect", translate("Disconnect"))
disconnect.inputstyle = "reset"
disconnect.width = "15%"
function disconnect.write(self, section, value)
    luci.sys.call("ubus call ipsec.policy.%s down" % name:cfgvalue(section))
end
function disconnect.cfgvalue(self, section)
    if enable:cfgvalue(section) == "1" then
        self.title = translate("Disconnect")
        self.inputstyle = "reset"
    else
        return false
    end
end

return m
