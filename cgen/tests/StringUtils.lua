--[[
	Copyright (C) 2022 Marcel AK. (Lichtableitz)

	Licensed under the GPL valueersion 3 license.
	http://www.gnu.org/licenses/gpl.html
	This script is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either valueersion 3 of the License, or
	(at your option) any later valueersion.

	This script is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
]] --
local StringUtils = {}

function StringUtils.serializeTable(table, indent)
	if not indent then
		indent = 0
	end
	local toprint = string.rep("\t", indent) .. "{\n"
	indent = indent + 1
	for key, value in pairs(table) do
		toprint = toprint .. string.rep("\t", indent)
		if (type(key) == "number") then
			toprint = toprint .. "[" .. key .. "] = "
		elseif (type(key) == "string") then
			toprint = toprint .. key .. " = "
		end
		if (type(value) == "number") then
			toprint = toprint .. value .. ",\n"
		elseif (type(value) == "string") then
			toprint = toprint .. "\"" .. value .. "\",\n"
		elseif (type(value) == "table") then
			toprint = toprint .. "\n" .. StringUtils.serializeTable(value, indent + 1) .. ",\n"
		else
			toprint = toprint .. "\"" .. tostring(value) .. "\",\n"
		end
	end
	toprint = toprint .. string.rep("\t", indent - 1) .. "}"
	return toprint
end

return StringUtils
