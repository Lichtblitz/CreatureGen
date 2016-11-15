--[[
	Copyright (C) 2016 Ken L.
	Licensed under the GPL Version 3 license.
	http://www.gnu.org/licenses/gpl.html
	This script is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This script is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
]]--

function onRadioLogChanged()
	local logLevel = DB.getValue(getDatabaseNode(),'loglevel',''); 

	if logLevel == '1' then
		CreatureGen.dlog('level 1'); 
		processLog(1); 
	elseif logLevel == '2' then
		CreatureGen.dlog('level 2'); 
		processLog(2); 
	elseif logLevel == '3' then
		CreatureGen.dlog('level 3'); 
		processLog(3); 
	elseif logLevel == '4' then
		CreatureGen.dlog('level 4'); 
		processLog(4); 
	elseif logLevel == '5' then
		CreatureGen.dlog('level 5'); 
		processLog(5); 
	elseif logLevel == '0' then
		CreatureGen.dlog('level 0'); 
		processLog(0); 
	else
		CreatureGen.dlog(logLevel .. ' is unknown?'); 
	end
end

function processLog(level)
	local cgen_window = Interface.findWindow("cgen_window","cgen");
	local cgen_node = cgen_window.getDatabaseNode();
	local rawLog = DB.getValue(cgen_node,'lograw',''); 
	local logNode; 
	local msglvl; 
	local dispLog = '';

	if not level then level = 0; end

	rawLog = rawLog:gsub('<p>',''); 
	rawLog = CreatureGen.strsplitpattern(rawLog,'</p>');
	
	for _,v in pairs(rawLog) do
		msglvl = v:match('%d'); 
		msglvl = tonumber(msglvl); 
		if msglvl ~= nil then
			if msglvl <= level then
				dispLog = dispLog .. '<p>' .. v .. '</p>'; 
			end
		end
	end

	if (nil ~= cgen_node) then
		local nodes = cgen_node.getChildren(); 
		cgen_node.createChild('log','text'); 
		local lnode = cgen_node.getChild('log');
		lnode.setValue(dispLog); 
	else
		CreatureGen.dlog("NO WINDOW"); 
	end

end
