--[[
	Copyright (C) 2022 Marcel AK. (Lichtblitz)

	Licensed under the GPL Version 3 license.
	http://www.gnu.org/licenses/gpl.html
	This script is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This script is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
]]--

local TableUtils = {}

function TableUtils.tableLength(table)
  local count = 0
  for _ in pairs(table) do
    count = count + 1
  end
  return count
end

return TableUtils