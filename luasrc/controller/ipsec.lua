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

    entry({"admin", "services", "ipsec", "policy"},
        arcombine(cbi("ipsec/policy"), cbi("ipsec/policy-add")),
        _("Policy")).leaf=true

    entry({"admin", "services", "ipsec", "general"},
        cbi("ipsec/general"), _("General")).leaf = true

    entry({"admin", "services", "ipsec", "log"}, call("ipsec_log"), _("Log")).leaf = true

    entry({"admin", "services", "ipsec", "status"}, call("ipsec_status"), nil).leaf = true
end

function ipsec_status(section)
    local uci = require("luci.model.uci").cursor()
    local name = uci:get("ipsec", section, "name")
    local rv = luci.sys.exec("ubus call ipsec.policy.%s get_status" % name)
    luci.http.prepare_content("application/json")
    luci.http.write(rv)
end

function ipsec_log()
    local syslog = luci.sys.exec("logread | grep pluto")
    luci.template.render("ipsec/ipsec_log", { syslog=syslog})
end
