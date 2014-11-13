--[[
LuCI - Lua Configuration Interface

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.ipsec", package.seeall)

function index()
    entry({"admin", "services", "ipsec"},
        alias("admin", "services", "ipsec", "policy"),
        _("IPSec"))

    --entry({"admin", "services", "ipsec", "policy"},
        --arcombine(cbi("ipsec/policy", {hideapplybtn=true, hidesavebtn=true, hideresetbtn=true}), cbi("ipsec/policy-add")),
        --_("Policy")).leaf=true
    
    entry({"admin", "services", "ipsec", "policy"},
        arcombine(cbi("ipsec/policy"), cbi("ipsec/policy-add")),
        _("Policy")).leaf=true


    entry({"admin", "services", "ipsec", "general"},
        cbi("ipsec/general"), _("General")).leaf = true
end
