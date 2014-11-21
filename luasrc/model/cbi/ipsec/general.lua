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

enable = s:option(Flag, "enable", translate("Enable"))
enable.rmempty = false

plutodebug = s:option(MultiValue, "plutodebug", translate("Debug"))
plutodebug:value("all", translate("all"))
plutodebug:value("control", translate("control"))
plutodebug:value("dpd", translate("dpd"))


return m
