--[[
LuCI - Lua Configuration Interface

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

m = Map("ipsec", translate("IPSec"))

-- setup
s = m:section(TypedSection, "setup", translate("General"))
s.anonymous = true
s.addremove = false
link1 = s:option(Value, "ipsec0", translate("Link1"))
link2 = s:option(Value, "ipsec1", translate("Link2"))
link3 = s:option(Value, "ipsec2", translate("Link3"))
link4 = s:option(Value, "ipsec3", translate("Link4"))


return m
