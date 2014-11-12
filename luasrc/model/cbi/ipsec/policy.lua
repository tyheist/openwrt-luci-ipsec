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

local name = s:option(DummyValue, "name", translate("Name"))
local type = s:option(DummyValue, "type", translate("Type"))


return m
