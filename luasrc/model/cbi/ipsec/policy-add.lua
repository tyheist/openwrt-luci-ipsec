--[[
LuCI - Lua Configuration Interface

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

--require "luci.sys"

local sid = arg[1]

m = Map("ipsec", translate("IPSec - Policy Settings"))
m.redirect = luci.dispatcher.build_url("admin/services/ipsec")

-- General Setting
s_general = m:section(NamedSection, sid, "policy", translate("General"))
s_general.anonymous = true
s_general.addremove = false

name = s_general:option(Value, "name", translate("Name"))

link = s_general:option(ListValue, "link", translate("Link"))
link.default = "ipsec0"
link:value("ipsec0", translate("ipsec0"))
link:value("ipsec1", translate("ipsec1"))
link:value("ipsec2", translate("ipsec2"))
link:value("ipsec3", translate("ipsec3"))

-- Phase1 Setting
s_phase1 = m:section(NamedSection, sid, "policy", translate("Phase 1"))
s_phase1.anonymous = true
s_phase1.addremove = false

mode = s_phase1:option(ListValue, "aggrmode", translate("Mode"))
mode.default = "no"
mode:value("yes", translate("Aggrmode"))
mode:value("no", translate("Main"))

authby = s_phase1:option(ListValue, "authby", translate("Auth By"))
authby.default = "secret"
authby:value("secret", translate("Secret"))

key = s_phase1:option(Value, "key", translate("PSK"))
key.password = true

leftid = s_phase1:option(Value, "leftid", translate("Local ID"))

rightid = s_phase1:option(Value, "rightid", translate("Remote ID"))

auto = s_phase1:option(ListValue, "auto", translate("Auto Negotiate"))
auto.default = "add"
auto:value("add", translate("Yes"))
auto:value("start", translate("No"))

ike = s_phase1:option(ListValue, "ike", translate("IKE Algorithm"))
ike.default = "des3-sha1"
ike:value("des3-sha1", translate("3DES-SHA1"))
ike:value("des3-md5", translate("3DES-MD5"))
ike:value("des-sha1", translate("DES-SHA1"))
ike:value("des-md5", translate("DES-MD5"))

ikelifetime = s_phase1:option(Value, "ikelifetime", translate("IKE Life Time"))
ikelifetime.default = "86400"

-- phase2 Setting
s_phase2 = m:section(NamedSection, sid, "policy", translate("Phase 2"))
s_phase2.anonymous = true
s_phase2.addremove = false

leftsubnet = s_phase2:option(Value, "leftsubnets", translate("Local Subnet"))
rightsubnet = s_phase2:option(Value, "rightsubnets", translate("Remote Subnet"))

type = s_phase2:option(ListValue, "type", translate("Connection Type"))
type.default = "tunnel"
type:value("tunnel", translate("Tunnel"))
type:value("transport", translate("Transport"))

phase2 = s_phase2:option(ListValue, "phase2", translate("SA Type"))
phase2.default = "esp"
phase2:value("esp", translate("ESP"))
phase2:value("ah", translate("AH"))

phase2alg = s_phase2:option(ListValue, "phase2alg", translate("ESP Algorithm"))
phase2alg.default = "des3-sha1"
phase2alg:value("des3-sha1", translate("3DES-SHA1"))
phase2alg:value("des3-md5", translate("3DES-MD5"))
phase2alg:value("des-sha1", translate("DES-SHA1"))
phase2alg:value("des-md5", translate("DES-MD5"))

keylife = s_phase2:option(Value, "keylife", translate("ESP Life Time"))
keylife.default = 3600

return m
