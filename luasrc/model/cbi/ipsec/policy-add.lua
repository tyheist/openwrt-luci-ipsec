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

enable = s_general:option(Flag, "enable", translate"Enable")
enable.rmempty = false
enable.default = "1"

left = s_general:option(Value, "left", translate("Local Interface"))
left.template = "cbi/network_netlist"
left.nocreate = true
left.optional = false

right = s_general:option(Value, "right", translate("Remote Address"))

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

psk = s_phase1:option(Value, "psk", translate("PSK"))
psk.password = true

leftid = s_phase1:option(Value, "leftid", translate("Local ID"))

rightid = s_phase1:option(Value, "rightid", translate("Remote ID"))

auto = s_phase1:option(ListValue, "auto", translate("Auto Negotiate"))
auto.default = "add"
auto:value("add", translate("No"))
auto:value("start", translate("Yes"))

ike = s_phase1:option(ListValue, "ike", translate("IKE Algorithm"))
ike.default = "3des-sha1"
ike:value("3des-sha1", translate("3DES-SHA1"))
ike:value("3des-md5", translate("3DES-MD5"))
ike:value("des-sha1", translate("DES-SHA1"))
ike:value("des-md5", translate("DES-MD5"))

ikelifetime = s_phase1:option(Value, "ikelifetime", translate("IKE Life Time"))
ikelifetime.default = "86400"

-- phase2 Setting
s_phase2 = m:section(NamedSection, sid, "policy", translate("Phase 2"))
s_phase2.anonymous = true
s_phase2.addremove = false

leftsubnet = s_phase2:option(Value, "leftsubnet", translate("Local Subnet"))
rightsubnet = s_phase2:option(Value, "rightsubnet", translate("Remote Subnet"))

type = s_phase2:option(ListValue, "type", translate("Connection Type"))
type.default = "tunnel"
type:value("tunnel", translate("Tunnel"))
type:value("transport", translate("Transport"))

phase2 = s_phase2:option(ListValue, "phase2", translate("SA Type"))
phase2.default = "esp"
phase2:value("esp", translate("ESP"))
phase2:value("ah", translate("AH"))

phase2alg = s_phase2:option(ListValue, "phase2alg", translate("ESP Algorithm"))
phase2alg.default = "3des-sha1"
phase2alg:value("3des-sha1", translate("3DES-SHA1"))
phase2alg:value("3des-md5", translate("3DES-MD5"))
phase2alg:value("des-sha1", translate("DES-SHA1"))
phase2alg:value("des-md5", translate("DES-MD5"))

keylife = s_phase2:option(Value, "keylife", translate("ESP Life Time"))
keylife.default = 3600

return m
