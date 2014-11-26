--[[
LuCI - Lua Configuration Interface

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

local sid = arg[1]

m = Map("ipsec", translate("IPSec - Policy Settings"))
m.redirect = luci.dispatcher.build_url("admin/services/ipsec")

--[[
-- General Setting
--]]
s_general = m:section(NamedSection, sid, "policy", translate("General"))
s_general.anonymous = true
s_general.addremove = false

-- name
name = s_general:option(Value, "name", translate("Name"), 
                        translate("The allowed characters are: <code>A-Z</code>, <code>a-z</code>, " ..
                                "<code>0-9</code> and <code>_</code>"))
name.rmempty = false                                
function name.validate(self, value)
    if value and value:match("^[a-zA-Z0-9_]+$") then
        local used = false
        m.uci:foreach("ipsec", "policy", 
            function(s)
                if s['.name'] ~= sid and s.name == value then
                    used = true
                end
            end)
        if used then 
            return nil, translate("Name had been used!")
        end
        return value
    else
        return nil, translate("Name field contain invalid values!")
    end
end

-- enable
enable = s_general:option(Flag, "enable", translate("Enable"))
enable.rmempty = false
enable.default = "1"

-- left
left = s_general:option(Value, "left", translate("Local Interface"))
left.template = "cbi/network_netlist"
left.nocreate = true
left.optional = false
function left.formvalue(...)
    return Value.formvalue(...) or "-"
end
function left.validate(self, value)
    if value == "-" then
        return nil, translate("Local interface required fields have no value!")
    end
    return value
end

-- right
right = s_general:option(Value, "right", translate("Remote Address"),
                    translate("IPv4 Address, <code>A.B.C.D</code>"))
right.rmempty = false
right.datatype = "ip4addr"

--[[
-- Phase1 Setting
--]]
s_phase1 = m:section(NamedSection, sid, "policy", translate("Phase 1"))
s_phase1.anonymous = true
s_phase1.addremove = false

-- mode
mode = s_phase1:option(ListValue, "aggrmode", translate("Mode"))
mode.default = "no"
mode:value("yes", translate("Aggrmode"))
mode:value("no", translate("Main"))

-- authby
authby = s_phase1:option(ListValue, "authby", translate("Auth By"))
authby.default = "secret"
authby:value("secret", translate("Secret"))

-- psk
psk = s_phase1:option(Value, "psk", translate("PSK"))
psk.rmempty = false
psk.password = true

-- leftid
leftid = s_phase1:option(Value, "leftid", translate("Local ID"),
                        translate("ID expressed as IPv4 address e.g. <code>10.10.10.10</code>,</br>" ..
                        "or as fully-qualified domain name preceded by @ e.g. <code>@domain</code>"))
leftid.rmempty = false                        
function leftid.validate(self, value)
    local ip = require "luci.ip"
    if (ip and ip.IPv4(value)) or (value:match("^@%w+")) then
        return value
    else
        return nil, translate("Local ID field contain invalid values!")
    end
    return value
end

-- rightid                        
rightid = s_phase1:option(Value, "rightid", translate("Remote ID"),
                        translate("ID expressed as IPv4 address e.g. <code>10.10.10.10</code>,</br>" ..
                        "or as fully-qualified domain name preceded by @ e.g. <code>@domain</code>"))
rightid.rmempty = false                        
function rightid.validate(sefl, value)
    local ip = require "luci.ip"
    if (ip and ip.IPv4(value)) or (value:match("^@%w+")) then
        return value
    else
        return nil, translate("Remote ID field contain invalid values!")
    end
    return value
end

-- auto                        
auto = s_phase1:option(ListValue, "auto", translate("Auto Negotiate"))
auto.default = "add"
auto:value("add", translate("No"))
auto:value("start", translate("Yes"))

-- ike
ike = s_phase1:option(ListValue, "ike", translate("IKE Algorithm"))
ike.default = "3des-sha1"

ike:value("3des-sha1", translate("3DES-SHA1"))
ike:value("3des-sha1;modp768", translate("3DES-SHA1-DH1"))
ike:value("3des-sha1;modp1024", translate("3DES-SHA1-DH2"))
ike:value("3des-sha1;modp1536", translate("3DES-SHA1-DH5"))

ike:value("3des-md5", translate("3DES-MD5"))
ike:value("3des-md5;modp768", translate("3DES-MD5-DH1"))
ike:value("3des-md5;modp1024", translate("3DES-MD5-DH2"))
ike:value("3des-md5;modp1536", translate("3DES-MD5-DH5"))

ike:value("des-sha1", translate("DES-SHA1"))
ike:value("des-sha1;modp768", translate("DES-SHA1-DH1"))
ike:value("des-sha1;modp1024", translate("DES-SHA1-DH2"))
ike:value("des-sha1;modp1536", translate("DES-SHA1-DH5"))

ike:value("des-md5", translate("DES-MD5"))
ike:value("des-md5;modp768", translate("DES-MD5-DH1"))
ike:value("des-md5;modp1024", translate("DES-MD5-DH2"))
ike:value("des-md5;modp1536", translate("DES-MD5-DH5"))

-- ikelifetime
ikelifetime = s_phase1:option(Value, "ikelifetime", translate("IKE Life Time"), 
                            translate("Unit: second, Range: <code>1-86400</code>, Defalut: <code>28800</code>"))
ikelifetime.default = "28800"
ikelifetime.datatype = "range(1, 86400)"
ikelifetime.rmempty = false
function ikelifetime.write(self, section, value)
    Value.write(self, section, value .. "s")
end
function ikelifetime.cfgvalue(self, section)
    local v = Value.cfgvalue(self, section)
    if v then
        return string.sub(v, string.find(v, "%d+"))
    else
        return nil
    end
end

--[[
-- phase2 Setting
--]]
s_phase2 = m:section(NamedSection, sid, "policy", translate("Phase 2"))
s_phase2.anonymous = true
s_phase2.addremove = false

-- leftsubnet
leftsubnet = s_phase2:option(Value, "leftsubnet", translate("Local Subnet"),
                            translate("Subnet expressed as network/netmask, e.g. <code>10.10.10.0/24</code>"))
leftsubnet.rmempty = false
function leftsubnet.validate(self, value)
    if value then
        local b1, b2, b3 = value:match("^(%d+%.%d+%.%d+.%d+)(%/)(%d+)")
        local ip = require "luci.ip"
        b3 = tonumber(b3)
        if (b2 and (ip and ip.IPv4(b1)) and (b3 and b3 >= 0 and b3 <=32)) then
            return value
        else
            return nil, translate("Local Subnet field contain invalid values!")
        end
    end
    return value
end

-- rightsubnet
rightsubnet = s_phase2:option(Value, "rightsubnet", translate("Remote Subnet"),
                            translate("Subnet expressed as network/netmask, e.g. <code>10.10.10.0/24</code>"))
rightsubnet.rmempty = true
function rightsubnet.validate(self, value)
    if value then
        local b1, b2, b3 = value:match("^(%d+%.%d+%.%d+.%d+)(%/)(%d+)")
        local ip = require "luci.ip"
        b3 = tonumber(b3)
        if (b2 and (ip and ip.IPv4(b1)) and (b3 and b3 >= 0 and b3 <=32)) then
            return value
        else
            return nil, translate("Remote Subnet field contain invalid values!")
        end
    end
    return value
end

-- type
type = s_phase2:option(ListValue, "type", translate("Connection Type"))
type.default = "tunnel"
type:value("tunnel", translate("Tunnel"))
type:value("transport", translate("Transport"))

--[[
-- phase2
--]]
phase2 = s_phase2:option(ListValue, "phase2", translate("SA Type"))
phase2.default = "esp"
phase2:value("esp", translate("ESP"))
phase2:value("ah", translate("AH"))

-- phase2alg
phase2alg_esp = s_phase2:option(ListValue, "_phase2alg_esp", translate("ESP Algorithm"))
phase2alg_esp.default = "3des-sha1"
phase2alg_esp:depends("phase2", "esp")
phase2alg_esp:value("3des-sha1", translate("3DES-SHA1"))
phase2alg_esp:value("3des-md5", translate("3DES-MD5"))
phase2alg_esp:value("des-sha1", translate("DES-SHA1"))
phase2alg_esp:value("des-md5", translate("DES-MD5"))
function phase2alg_esp.write(self, section, value)
    m.uci:set("ipsec", section, "phase2alg", value)
end
function phase2alg_esp.cfgvalue(self, section)
    return m.uci:get("ipsec", section, "phase2alg")
end

phase2alg_ah = s_phase2:option(ListValue, "_phase2alg_ah", translate("ESP Algorithm"))
phase2alg_ah.default = "sha1"
phase2alg_ah:depends("phase2", "ah")
phase2alg_ah:value("sha1", translate("SHA1"))
phase2alg_ah:value("md5", translate("MD5"))
function phase2alg_ah.write(self, section, value)
    m.uci:set("ipsec", section, "phase2alg", value)
end
function phase2alg_ah.cfgvalue(self, section)
    return m.uci:get("ipsec", section, "phase2alg")
end

-- keylife
keylife = s_phase2:option(Value, "keylife", translate("ESP Life Time"),
                        translate("Unit: second, Range: <code>1-86400</code>, Default: <code>3600</code>"))
keylife.default = 3600
keylife.datatype = "range(1, 86400)"
keylife.rmempty = false
function keylife.write(self, section, value)
    Value.write(self, section, value .. "s")
end
function keylife.cfgvalue(self, section)
    local v = Value.cfgvalue(self, section)
    if v then
        return string.sub(v, string.find(v, "%d+"))
    else
        return nil
    end
end

-- dpdenable
dpdenable = s_phase2:option(Flag, "dpdenable", translate("DPD Enable"))
dpdenable.default = "0"
dpdenable.rmempty = false

-- dpddelay
dpddelay = s_phase2:option(Value, "dpddelay", translate("DPD Delay"),
                        translate("Unit: second, Range: <code>1-3600</code>, Default: <code>30</code>"))
dpddelay.default = 30
dpddelay.datatype = "range(1, 3600)"
dpddelay.rmempty = true
dpddelay:depends("dpdenable", "1")

-- dpdtimeout
dpdtimeout = s_phase2:option(Value, "dpdtimeout", translate("DPD Timeout"),
                        translate("Unit: second, Range: <code>1-28800</code>, Default: <code>120</code>"))
dpdtimeout.default = 120
dpdtimeout.datatype = "range(1, 28800)"
dpdtimeout.rmempty = true
dpdtimeout:depends("dpdenable", "1")

-- dpdaction
dpdaction = s_phase2:option(ListValue, "dpdaction", translate("DPD Action"),
                    translate("Default: <code>restart_by_peer</code>"))
dpdaction.default = "restart_by_peer"
dpdaction:value("hold", translate("Hold"))
dpdaction:value("clear", translate("Clear"))
dpdaction:value("restart", translate("Restart"))
dpdaction:value("restart_by_peer", translate("Restart_by_peer"))
dpdaction:depends("dpdenable", "1")

return m
