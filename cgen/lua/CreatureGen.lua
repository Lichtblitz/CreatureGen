--[[
	Copyright (C) 2016 Ken L.
	Contribuitors:
		Chris B. (BigD3mon)

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

--[[
	LUA is a pain in the posterior
]]--
local dmesg = {}; 
local warn = {}; 
local errs = {}; 

local fields = {};
fields['feedbackres'] = 'gCGenExtensionIcon'; 
fields['warningres'] = 'gCGenWarningIcon'; 
fields['errorres'] = 'gCGenErrorIcon'; 
fields['spelllib'] = 'PFRPG Archive Spells'; 
fields['spelllibprefix'] = 'reference.spells.'; 

function test()
	local modules, minfo;
	local spellname = 'fireball'; 

	modules = Module.getModules();

	for k,v in pairs(modules) do
		dlog(k .. ' ' .. v); 
	end

	minfo = Module.getModuleInfo(fields.spelllib); 
	if minfo then
		dlog('name: ' .. tostring(minfo['name'])); 
		dlog('category: ' .. tostring(minfo['category'])); 
		dlog('author: ' .. tostring(minfo['author'])); 
		dlog('size: ' .. tostring(minfo['size'])); 
		dlog('installed: ' .. tostring(minfo['installed'])); 
		dlog('loaded: ' .. tostring(minfo['loaded'])); 
		dlog('loading: ' .. tostring(minfo['loading'])); 
		dlog('loadpending: ' .. tostring(minfo['loadpending'])); 
		dlog('permission: ' .. tostring(minfo['permission'])); 
		dlog('intact: ' .. tostring(minfo['intact'])); 
		dlog('replaces: ' .. tostring(minfo['replaces'])); 
		dlog('hastokens: ' .. tostring(minfo['hastokens'])); 
		dlog('hasdata: ' .. tostring(minfo['hasdata'])); 
	end

	if minfo and minfo['loaded'] == true then
		-- verify that this is a module we can use
		-- do our thing
		local spellNode = DB.findNode(fields.spelllibprefix .. spellname .. '@' .. fields.spelllib); 
		if spellNode then
			dlog(spellNode.getChildren().description.getValue()); 
		end
		
	end
	

end

-- -- --
--
--
-- Utility functions
--
--
-- -- --

--[[
	Adds a warning to the warn log, prints to debug console. 
]]--
function addWarn(str)
	table.insert(warn,tostring(str)); 
	Debug.console('WARN: ' .. tostring(str)); 
	creLog('WARN: ' .. tostring(str),0); 
end

--[[
	Adds an error to the warn log, prints to debug console.
]]--
function addError(str)
	table.insert(errs,tostring(str)); 
	Debug.console('ERROR: ' .. tostring(str)); 
	creLog('ERROR: ' .. tostring(str),0); 
end

--[[
	Directly prints to the debug console. 
]]--
function dlog(str)
	Debug.console('GENERAL: ' .. tostring(str));
	creLog('GENERAL: ' .. tostring(str),0); 
end


--[[
	Send all warnings in a single message to chat
]]--
function sendWarnings()
	local content = ''; 
	for _,v in pairs(warn) do
		content = content  .. v .. '\n\n'; 
	end
	if content:len() > 1 then
		content = content:sub(1,-3); 
	end
	sendFeedback(content,fields.warningres); 
end

--[[
	Send all errors in a single message to chat
]]--
function sendErrors()
	local content = ''; 
	for _,v in pairs(errs) do
		content = content .. v .. '\n\n'; 
	end
	if content:len() > 1 then
		content = content:sub(1,-3); 
	end
	sendFeedback(content,fields.errorres); 
end

--[[
	Send Feedback via chat
]]--
function sendFeedback(str,iconres)
	local msg = {};

	if not str or str == '' then
		return; 
	end
	if not iconres then
		iconres = fields.feedbackres; 
	end
	msg.text = str;
	msg.secret = true; 
	msg.icon = iconres; 
	Comm.addChatMessage(msg); 	
end

--[[
	Adds a log entry at the specified level. 
]]--
function creLog(str,level)
	if nil == level then
		level = 0; 
	end
	table.insert(dmesg,'[' .. level .. '] ' .. tostring(str)); 
end

--[[
	Dump log entries at the specified level. 
]]--
function dumpLog(level)
	local dump=''; 

	if nil == level then
		level = 0;
	end

	for i = 1,#dmesg do
		clvl = tonumber(dmesg[i]:match('%d')); 
		if clvl and clvl <= level then
			dump = dump .. '<p>' .. dmesg[i] .. '</p>'; 
		end
	end


	return dump; 
end

-- -- --
--
--
-- XML interface functions
--
--
-- -- --

--[[
	Callback for the XML given the DB node as well as 
	the datastructure. Populates the node with the
	provided data structure. Currently adheres to the
	the FG PF ruleset. 
]]--
function populate(creBase,creData)
	local creature = creData.creature; 
	local creList = creBase.getChildren(); 
	-- creData -> log, creature -> creature_data
	-- (str name, ln databasenode)
	-- initial population has name
	-- creList.name = creData.name; 
	--for k,v in pairs(creList) do
	--	Debug.console('k: ' .. k .. ' v: ' .. type(v)); 
	--end
	-- <<<<<<<<<< CONFIRM TO CHARACTER SHEET HERE
	-- creList.name = creature.name; 
	-- TODO figure out the CRUD of an NPC entry
	creBase.setPublic(false); 
	creList.name.setValue(creature.name); 

	-- formatted block
	creBase.createChild('text','formattedtext'); 
	-- core
	creBase.createChild('type','string');
	creBase.createChild('init','number');
	creBase.createChild('senses','string'); 
	creBase.createChild('aura','string'); 
	creBase.createChild('ac','string'); 
	creBase.createChild('hp','number'); 
	creBase.createChild('hd','string'); 
	creBase.createChild('fortitudesave','number'); 
	creBase.createChild('reflexsave','number'); 
	creBase.createChild('willsave','number'); 
	-- attributes
	creBase.createChild('strength','number'); 
	creBase.createChild('dexterity','number'); 
	creBase.createChild('constitution','number'); 
	creBase.createChild('intelligence','number'); 
	creBase.createChild('wisdom','number'); 
	creBase.createChild('charisma','number'); 
	-- skills/feats
	creBase.createChild('feats','string'); 
	creBase.createChild('skills','string'); 
	-- auxillary
	creBase.createChild('babgrp','string'); 
	creBase.createChild('xp','number'); 
	creBase.createChild('cr','number'); 
	-- attacks
	creBase.createChild('atk','string'); 
	creBase.createChild('fullatk','string'); 
	-- specials
	creBase.createChild('specialqualities','string'); 
	creBase.createChild('specialattacks','string'); 
	-- gear/equipment
	creBase.createChild('treasure','string'); 
	-- language
	creBase.createChild('languages','string'); 
	-- space-reach
	creBase.createChild('spacereach','string');
	-- speed
	creBase.createChild('speed','string');
	-- organization
	creBase.createChild('organization','string');
	-- environment
	creBase.createChild('environment','string'); 


	creList = creBase.getChildren(); 
	-- formatted block
	creList.text.setValue(buildNotesFormat(creData)); 
	-- core
	creList.type.setValue(creature.tpe);
	creList.init.setValue(creature.init);
	creList.senses.setValue(creature.senses); 
	creList.aura.setValue(creature.aura);
	creList.ac.setValue(creature.acline); 
	creList.hp.setValue(creature.hp); 
	creList.hd.setValue(creature.hd); 
	creList.fortitudesave.setValue(creature.fort);
	creList.reflexsave.setValue(creature.ref);
	creList.willsave.setValue(creature.will);
	-- attributes
	creList.strength.setValue(creature.str);
	creList.dexterity.setValue(creature.dex);
	creList.constitution.setValue(creature.con);
	creList.intelligence.setValue(creature.int); 
	creList.wisdom.setValue(creature.wis); 
	creList.charisma.setValue(creature.cha); 
	-- skills/feats
	creList.feats.setValue(creature.feats);
	creList.skills.setValue(creature.skills); 
	-- auxillary
	creList.babgrp.setValue(creature.babcmd); 
	creList.xp.setValue(creature.exp);
	creList.cr.setValue(creature.cr); 
	-- attacks
	creList.atk.setValue(creature.attack); 
	creList.fullatk.setValue(creature.fattack); 
	-- specials
	creList.specialqualities.setValue(creature.sqline); 
	creList.specialattacks.setValue(creature.sa); 
	-- gear/equipment
	creList.treasure.setValue(creature.gearline); 
	-- language
	creList.languages.setValue(creature.lang); 
	-- space/reach
	creList.spacereach.setValue(creature.spacereachline); 
	-- speed
	creList.speed.setValue(creature.speed); 
	-- environment
	creList.environment.setValue(creature.environment); 
	-- organization
	creList.organization.setValue(creature.organization); 
	-- check library link
	checkLib(); 
	-- spells
	popSpells(creBase,creData); 

	-- warnings if any
	if next(warn) ~= nil then
		addWarn("Import complete for " .. creature.name); 
		sendWarnings(); 
	else
		sendFeedback("Import complete for " .. creature.name); 
	end
end

--[[
	Checks if our sync'd library is loaded. If it is not, warn the user.
]]--
function checkLib()
	local modules, minfo;

	modules = Module.getModules();
	minfo = Module.getModuleInfo(fields.spelllib); 

	if minfo and minfo['loaded'] == true then
		dlog('Spell library: "' .. fields.spelllib .. '" detected as loaded and available'); 
	else
		addWarn('Spell library: "' .. fields.spelllib .. '" is not loaded or not available, spells will not be populated'); 
	end
end

--[[
	Populate spells specifically for the FG pathfinder charactersheet
]]--
function popSpells(creBase, creData)
	local creature = creData.creature; 
	local creList,spellList,casterNode,spellTypeNode,spellTypeBaseNode,tmp; 
	local casterType,spellType;
	local cnt = 1; 

	if creature.spells then
		spellList = creBase.createChild('spellset'); 
		for k,v in pairs(creature.spells) do
			casterType = k;
			-- we don't do spell like abilities in this pass
			if not casterType:match('Spell%-Like') then
				creLog('caster ->> ' .. casterType,3); 
				casterNode = spellList.createChild('id%-' .. string.format('%05d',cnt));
				casterNode.createChild('label','string'); 
				casterNode.getChildren().label.setValue(casterType); 
				-- concentration + caster level checks
				casterNode.createChild('cc').createChild('misc','number').setValue(creature.spells[casterType].concentration);
				casterNode.createChild('cl','number').setValue(creature.spells[casterType].casterlevel);
				cnt = cnt + 1; 
				for k2,v2 in pairs(creature.spells[casterType]) do
					spellType = k2;
					spellTypeBaseNode = casterNode.createChild('levels'); 
					if spellType:match('0') then
						casterNode.createChild('availablelevel0','number'); 
						casterNode.getChildren().availablelevel0.setValue(#creature.spells[casterType][spellType]); 
						tmp = spellTypeBaseNode.createChild('level0'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(0);
						tmp.maxprepared.setValue(#creature.spells[casterType][spellType]); 
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 

					elseif spellType:match('1st') then
						casterNode.createChild('availablelevel1','number'); 
						casterNode.getChildren().availablelevel1.setValue(getSpellsPerLevel(creData,spellTypeNode,casterType,spellType)); 
						tmp = spellTypeBaseNode.createChild('level1'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(1);
						tmp.maxprepared.setValue(#creature.spells[casterType][spellType]); 
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 

					elseif spellType:match('2nd') then
						casterNode.createChild('availablelevel2','number'); 
						casterNode.getChildren().availablelevel2.setValue(getSpellsPerLevel(creData,spellTypeNode,casterType,spellType)); 
						tmp = spellTypeBaseNode.createChild('level2'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(2);
						tmp.maxprepared.setValue(#creature.spells[casterType][spellType]); 
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 

					elseif spellType:match('3rd') then
						casterNode.createChild('availablelevel3','number'); 
						casterNode.getChildren().availablelevel3.setValue(getSpellsPerLevel(creData,spellTypeNode,casterType,spellType)); 
						tmp = spellTypeBaseNode.createChild('level3'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(3);
						tmp.maxprepared.setValue(#creature.spells[casterType][spellType]); 
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 

					elseif spellType:match('4th') then
						casterNode.createChild('availablelevel4','number'); 
						casterNode.getChildren().availablelevel4.setValue(getSpellsPerLevel(creData,spellTypeNode,casterType,spellType)); 
						tmp = spellTypeBaseNode.createChild('level4'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(4);
						tmp.maxprepared.setValue(#creature.spells[casterType][spellType]); 
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 

					elseif spellType:match('5th') then
						casterNode.createChild('availablelevel5','number'); 
						casterNode.getChildren().availablelevel5.setValue(getSpellsPerLevel(creData,spellTypeNode,casterType,spellType)); 
						tmp = spellTypeBaseNode.createChild('level5'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(5);
						tmp.maxprepared.setValue(#creature.spells[casterType][spellType]); 
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 

					elseif spellType:match('6th') then
						casterNode.createChild('availablelevel6','number'); 
						casterNode.getChildren().availablelevel6.setValue(getSpellsPerLevel(creData,spellTypeNode,casterType,spellType)); 
						tmp = spellTypeBaseNode.createChild('level6'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(6);
						tmp.maxprepared.setValue(#creature.spells[casterType][spellType]); 
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 

					elseif spellType:match('7th') then
						casterNode.createChild('availablelevel7','number'); 
						casterNode.getChildren().availablelevel7.setValue(getSpellsPerLevel(creData,spellTypeNode,casterType,spellType)); 
						tmp = spellTypeBaseNode.createChild('level7'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(7);
						tmp.maxprepared.setValue(#creature.spells[casterType][spellType]); 
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 

					elseif spellType:match('8th') then
						casterNode.createChild('availablelevel8','number'); 
						casterNode.getChildren().availablelevel8.setValue(getSpellsPerLevel(creData,spellTypeNode,casterType,spellType)); 
						tmp = spellTypeBaseNode.createChild('level8'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(8);
						tmp.maxprepared.setValue(#creature.spells[casterType][spellType]); 
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 

					elseif spellType:match('9th') then
						casterNode.createChild('availablelevel9','number'); 
						casterNode.getChildren().availablelevel9.setValue(getSpellsPerLevel(creData,spellTypeNode,casterType,spellType)); 
						tmp = spellTypeBaseNode.createChild('level9'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(9);
						tmp.maxprepared.setValue(#creature.spells[casterType][spellType]); 
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 

					end
				end
			end
		end
	end

	popSpellLikeAb(creBase,creData,cnt); 
end

--[[
	Populate spell like abilities which will occupy FG 'levels' to allow ticking off of uses. 
	idcarry, is a carry from the spells population such that we're consistant with the id-naming
	schema. 
]]--
function popSpellLikeAb(creBase, creData, idcarry)
	local creature = creData.creature; 
	local creList,spellList,casterNode,spellTypeNode,spellTypeBaseNode,alloLevel,tmp; 
	local casterType,spellType;
	local cnt = idcarry; 
	local avail; 
	local sidcarry = 1; 

	if not idcary then idcarry = 1; end

	--[[
		Each spell type will already be a 'bucket' of the same pool of uses ie: 7/day SLA groups
		therefore all we need to do is add the additional layer of tracking taken levels, and creating
		overflow levels where necessary. 
	]]--

	if creature.spells then
		spellList = creBase.createChild('spellset'); 
		for k,v in pairs(creature.spells) do
			casterType = k;
			-- each new caster has their own allocation
			avail = {1,2,3,4,5,6,7,8,9}; 
			-- we only care about SLAs in this pass
			if casterType:match('Spell%-Like') then
				creLog('SLA caster ->> ' .. casterType,3); 
				casterNode = spellList.createChild('id%-' .. string.format('%05d',cnt));
				casterNode.createChild('label','string'); 
				casterNode.getChildren().label.setValue(casterType); 
				casterNode.createChild('castertype','string'); 
				casterNode.getChildren().castertype.setValue('spontaneous'); 
				-- concentration + caster level checks
				casterNode.createChild('cc').createChild('misc','number').setValue(creature.spells[casterType].concentration);
				casterNode.createChild('cl','number').setValue(creature.spells[casterType].casterlevel);
				cnt = cnt + 1; 
				for k2,v2 in pairs(creature.spells[casterType]) do
					spellType = k2; 
					spellTypeBaseNode = casterNode.createChild('levels'); 
					if spellType:match('Constant') then
						casterNode.createChild('availablelevel0','number'); 
						rc = (#creature.spells[casterType][spellType]); 
						tmp = spellTypeBaseNode.createChild('level0'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(0);
						if tmp.maxprepared.getValue() then
							casterNode.getChildren().availablelevel0.setValue(tmp.maxprepared.getValue()+rc); 
							tmp.maxprepared.setValue(tmp.maxprepared.getValue()+rc); 
						end
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						sidcarry = popSpellTypeList(creData,spellTypeNode,casterType,spellType,sidcarry); 
					elseif spellType:match('At will') then
						casterNode.createChild('availablelevel0','number'); 
						rc = (#creature.spells[casterType][spellType]); 
						tmp = spellTypeBaseNode.createChild('level0'); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(0);
						if tmp.maxprepared.getValue() then
							casterNode.getChildren().availablelevel0.setValue(tmp.maxprepared.getValue()+rc); 
							tmp.maxprepared.setValue(tmp.maxprepared.getValue()+rc); 
						end
						tmp.totalcast.setValue(0);
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						sidcarry = popSpellTypeList(creData,spellTypeNode,casterType,spellType,sidcarry); 
					elseif spellType:match('day') then
						if next(avail) == nil then
							-- we need to create a new overflow class!!
							error('OVERFLOW on spell-like abilities currently unhandled'); 
						end
						alloLevel = table.remove(avail,1);
						casterNode.createChild('availablelevel' .. tostring(alloLevel),'number'); 
						rc = getBonusNumber(spellType); 
						casterNode.getChildren()['availablelevel' .. tostring(alloLevel)].setValue(rc); 
						tmp = spellTypeBaseNode.createChild('level' .. tostring(alloLevel)); 
						tmp.createChild('level','number');
						tmp.createChild('maxprepared','number');
						tmp.createChild('totalcast','number');
						tmp.createChild('totalprepared','number'); 
						spellTypeNode = tmp.createChild('spells'); 
						tmp = tmp.getChildren();
						tmp.level.setValue(alloLevel);
						tmp.totalcast.setValue(0);
						tmp.maxprepared.setValue(rc); 
						tmp.totalprepared.setValue(#creature.spells[casterType][spellType]); 
						popSpellTypeList(creData,spellTypeNode,casterType,spellType); 
						

					end

				end
			end
		end
	end


end

--[[
	Get spells per level for the given caster/spelltype by summing the
	prepped spells.

	NOTE: this assumes all slots are prepped as is typical of NPC blocks
]]--
function getSpellsPerLevel(creData,spellTypeNode, casterType, spellType)
	local creature = creData.creature; 
	local spellCnt = 0;  

	for k,v in pairs(creature.spells[casterType][spellType]) do
		spellCnt = spellCnt + v.prepped; 
	end
	return spellCnt; 
end

--[[
	Poplulates SpellType (1st,2nd,3/day,1/week etc...) lists. 
	idcarry is mainly for Constant/Spell-Like-Abilities which occupy the 0-level
]]--
function popSpellTypeList(creData, spellTypeNode, casterType, spellType, idcarry)
	local creature = creData.creature; 
	local spellNode; 
	local prefix; 
	local cnt = 1; 
	
	if idcarry then
		cnt = idcarry;
	end

	if casterType:match('Spell%-Like') then prefix = '(' ..spellType .. ') '; end

	for k,v in pairs(creature.spells[casterType][spellType]) do
		spellNode = spellTypeNode.createChild('id%-' .. string.format('%05d',cnt));
		if prefix then v.name = prefix .. v.name; end
		popSpellDetail(spellNode,v); 
		cnt = cnt + 1; 
	end

	return cnt; 
end

--[[
	Populates data for the actual spell iteself by hopefully linking to a library. 
]]--
function popSpellDetail(spellNode, spellData)
	local tmp; 
	spellNode.createChild('name','string');
	spellNode.createChild('prepared','number');
	--TODO more spell details pending DB link
	tmp = spellNode.getChildren(); 
	-- TODO allow meta name by adding in metas from the spell data
	tmp.name.setValue(spellData.name); 
	tmp.prepared.setValue(spellData.prepped); 
	-- Library link
	linkSpellLibrary(spellNode,spellData); 
	creLog('popSpellDetail: populated: ' .. spellData.name,3); 
end

--[[
	Given the spell's DB node, and the complementary spell data,
	look up in our spell library to try and fill in the details.
]]--
function linkSpellLibrary(spellNode, spellData)
	local minfo, xmlSpellName, libNode, tmp, tmpb; 

	xmlSpellName = trim(spellData.propername:gsub('%s','')) .. spellData.varient; 
	xmlSpellName = xmlSpellName:lower(); 
	creLog('library XML spell name searched: "' .. xmlSpellName .. '"',4); 

	minfo = Module.getModuleInfo(fields.spelllib); 
	if minfo and minfo['loaded'] == true then
		-- TODO verify that this is a module we can use, currently we just use it
		-- do our thing
		local libNode = DB.findNode(fields.spelllibprefix .. xmlSpellName .. '@' .. fields.spelllib); 
		if libNode then
			-- populate our spell stuffs
			spellNode.createChild('castingtime','string'); 
			spellNode.createChild('components','string'); 
			spellNode.createChild('cost','number'); 
			spellNode.createChild('description','string'); 
			spellNode.createChild('duration','string'); 
			spellNode.createChild('effect','string'); 
			spellNode.createChild('level','string'); 
			spellNode.createChild('range','string'); 
			spellNode.createChild('save','string'); 
			spellNode.createChild('school','string'); 
			spellNode.createChild('shortdescription','string'); 
			spellNode.createChild('sr','string'); 
			-- fill our entries
			tmp = spellNode.getChildren();
			tmpb = libNode.getChildren(); 
			tmp.castingtime.setValue(tmpb.castingtime.getValue()); 
			tmp.components.setValue(tmpb.components.getValue()); 
			tmp.description.setValue(stripTags(tmpb.description.getValue())); 
			tmp.duration.setValue(tmpb.duration.getValue()); 
			tmp.level.setValue(tmpb.level.getValue()); 
			tmp.range.setValue(tmpb.range.getValue()); 
			tmp.save.setValue(tmpb.save.getValue()); 
			tmp.school.setValue(tmpb.school.getValue()); 
			tmp.sr.setValue(tmpb.sr.getValue()); 
			-- these are 'optional' datum which may not exist, they're a basket case
			if tmpb.cost then
				tmp.cost.setValue(tmpb.cost.getValue()); 
			end
			if tmpb.effect then
				tmp.effect.setValue(tmpb.effect.getValue()); 
			end
			if tmpb.shortdescription then
				tmp.shortdescription.setValue(tmpb.shortdescription.getValue()); 
			end
		else
			addWarn('"' .. spellData.name .. '" cannot be found within spell library "' .. fields.spelllib .. '"'); 
		end
	end

end

--[[
	Build the displayed 'notes' field. This should:

	1. TEMPORARILY consist of the spells/spell-like abilities
	2. Show save riders
	3. Show special abilities
	4. Contain the statblock

	All within a formatted text field
]]--
function buildNotesFormat(creData)
	local retval = '';
	local creature = creData.creature; 

	if creature.saverider then
		retval = retval .. '<h>Saving Throw Bonuses</h>\n';
		retval = retval .. '<p>' .. creature.saverider .. '</p>\n'; 
	end

	if creature.specialab then
		retval = retval .. '<h>Special Abilities</h>\n'; 
		for k,v in pairs(creature.specialab) do
			retval = retval .. '<p><b>' .. k .. '</b>' .. ' ' .. v .. '</p>'; 
		end
	end

	-- Tactics
	if creature.beforecombat or creature.duringcombat or creature.morale or creature.basestats then
		retval = retval .. '<h>Tactics</h>\n';
		if creature.beforecombat then
			retval = retval .. '<p><b>Before Combat: </b>' .. creature.beforecombat .. '</p>\n';
		end
		if creature.duringcombat then
			retval = retval .. '<p><b>During Combat: </b>' .. creature.duringcombat .. '</p>\n';
		end
		if creature.morale then
			retval = retval .. '<p><b>Morale: </b>' .. creature.morale .. '</p>\n';
		end
		if creature.basestats then
			retval = retval .. '<p><b>Base Statistics: </b>' .. creature.basestats .. '</p>\n';
		end
	end

	-- statblock
	retval = retval .. '<h>Statstics Block</h>'
	retval = retval .. creature.fmt; 

	return retval; 
end

--[[
	Let's create some monsters... FG style!
]]--
function genesis(data)
	dmesg = {}; 
	warn = {}; 
	errs = {};
	local creature = {}; 
	local retval = {}; 

	scan(creature,data); 
	test(); 
	-- Data bundle
	retval.creature = creature; 
	retval.log = dumpLog(5);
	return retval; 
end

-- -- --
--
--
-- Parsing functions
--
--
-- -- --

--[[
	Perform the primary scan, isolate parsed datum
	into pcalls to catch statblock errors as they
	appear in their respective areas for verbose
	feedback.
]]--
function scan(creature,data)
	local err, errmsg, ldata, fmt; 

	-- Split by newline, remove blank lines
	data = stripString(data); 
	ldata = data:lower(); 
	data = strsplit(data,'\n');
	ldata = strsplit(ldata,'\n');
	for i = #data,1,-1 do
		data[i] = trim(data[i]:gsub('<.?p>','')); 
		ldata[i] = trim(ldata[i]:gsub('<.?p>','')); 
		if data[i]:len() == 0 then
			table.remove(data,i); 	
			table.remove(ldata,i); 	
		end
	end
	-- Log it, and format the display dump
	creature.fmt = ''; 
	for i = 1,#data do
		creLog(('(' .. i .. ') ' .. data[i]),0); 
		creature.fmt = creature.fmt .. '<p>' .. data[i] .. '</p>'; 
		--creLog('cookies',0); 
	end

	-- Parse each component of the statblock
	err, errmsg = pcall(parsePreliminary,creature,data,ldata); 
	if (not err) then
		addError('Error while parsing Preliminary: ' .. errmsg); 
		creature.error = true; 
	end

	if (not creature.error) then
		dlog('ok doing defense',self); 
		err, errmsg = pcall(parseDefense,creature,data); 
		if (not err) then
			addError('Error while parsing defense: ' .. errmsg); 
			creature.error = true; 
		end
	end

	if (not creature.error) then
		dlog('ok doing offense',self); 
		err, errmsg = pcall(parseOffense,creature,data); 
		if (not err) then
			addError('Error while parsing offense: ' .. errmsg); 
			creature.error = true; 
		end
	end

	if (not creature.error) then
		dlog('ok doing tactics',self); 
		err, errmsg = pcall(parseTactics,creature,data); 
		if (not err) then
			addError('Error while parsing tactics: ' .. errmsg); 
			creature.error = true; 
		end
	end

	if (not creature.error) then
		dlog('ok doing statistics',self); 
		err, errmsg = pcall(parseStatistics,creature,data); 
		if (not err) then
			addError('Error while parsing statistics: ' .. errmsg); 
			creature.error = true; 
		end
	end

	if (not creature.error) then
		dlog('ok doing ecology',self); 
		err, errmsg = pcall(parseEcology,creature,data); 
		if (not err) then
			addError('Error while parsing ecology: ' .. errmsg); 
			creature.error = true; 
		end
	end

	if (not creature.error) then
		dlog('ok doing special abilities',self); 
		err, errmsg = pcall(parseSpecialAbilities,creature,data,ldata); 
		if (not err) then
			addError('Error while parsing special abilities: ' .. errmsg); 
			creature.error = true; 
		end
	end

	if creature.error then
		sendWarnings(); 
		sendErrors(); 
	end

end

--[[
	Aids in marker finding by insuring the searched
	for marker is singleton on the found line. returns
	first occurance line number. 
]]--
function findMarker(strName,coll) 
	local rv1,rv2,halt,cline; 

	cline = 1; 
	rv1,rv2 = getLineByName(strName,coll,cline,#coll);
	while cline < #coll do
		if rv1 == nil then
			halt = true; 
		end
		if rv1 == strName then
			return rv2; 
		end
		cline = rv2; 
		if not cline then break; end
		cline = cline +1; 
		rv1,rv2 = getLineByName(strName,coll,cline,#coll);
	end
	return nil; 
end

--[[
	Parse name, CR, type, aura, and all prelimiary datum prior to the
	offense section.
]]--
function parsePreliminary(creature,data,ldata)
	local name,cr,exp,hp,hd; 
	local senses,alignment,aura,tpe,init; 
	local tmp,tmp2; 
	local termChars = {',',';'}; 

	-- validate
	if #data < 1 then
		error('no statblock'); 
		return; 
	end


	-- find our bookmarks
	creature.mark_defense = nil; 
	creature.mark_offense = nil; 
	creature.mark_tactics = nil; 
	creature.mark_statistics = nil; 
	creature.mark_ecology = nil; 

	--TODO normaize to the new 'findMarker' function
	creature.mark_defense = findMarker('defense',ldata); 
	if not creature.mark_defense then
		error('No DEFENSE tag found'); 
	end
	creature.mark_offense = findMarker('offense',ldata); 
	if not creature.mark_offense then
		error('No OFFENSE tag found'); 
	end
	creature.mark_statistics = findMarker('statistics',ldata);
	if not creature.mark_statistics then
		error('No STATISTICS tag found'); 
	end
	creature.mark_tactics = findMarker('tactics',ldata); 
	if not creature.mark_tactics then
		creature.mark_tactics = creature.mark_statistics; 
	end
	creature.mark_special_abilities = findMarker('special abilities',ldata); 
	if not creature.mark_special_abilities then
		creature.mark_special_abilities = #ldata
	end
	creature.mark_ecology = findMarker('ecology',ldata); 
	if not creature.mark_ecology then
		creature.mark_ecology = #ldata; 
	end

	-- parse name
	name = data[1]; 
	name = data[1]:match('.+CR'); 
	if (name == nil) then
		name = data[1];
	else
		name = name:reverse();
		name = name:sub(name:find('RC')+2);
		name = name:reverse(); 
	end
	creature.name = name; 

	-- normalize name
	tmp = strsplit(name:lower(),'%s'); 
	name = ''; 
	for _,v in pairs(tmp) do
		v = trim(v);
		v = v:sub(1,1):upper() .. v:sub(2); 
		name = name .. ' ' .. v; 
	end
	creature.name = trim(name); 

	-- parse CR
	cr = data[1]:reverse():match('%d+');
	if (nil == cr) then
		cr = 0;
	else 
		cr = tonumber(cr:reverse()); 
	end
	creature.cr = cr; 

	-- parse Init, Senses
	tmp = getLineByName('Init',data,1,(nil == creature.mark_defense and #data or creature.mark_defense));
	init = trim(getValueByName('Init',tmp,termChars)); 
	senses = trim(getValueByName('Senses',tmp,{})); 
	creature.init = getBonusNumber(init,0);
	creature.senses = senses; 
	creLog('Init ' .. tostring(creature.init),5); 
	creLog('Senses ' .. tostring(creature.senses),5);

	-- parse Type, Alignment, currently on the same line as size
	-- TODO parse out class levels, for NPCs and a bunch of monster codex entries
	-- ie: medium goblin bla bla
	--     Cleric 2
	-- which are on seperate lines
	tmp,tmp2 = getLineByName('small',ldata,1,(nil == creature.mark_defense and #data or creature.mark_defense));
	creature.size = 'small'; 
	if not tmp then
		tmp,tmp2 = getLineByName('medium',ldata,1,(nil == creature.mark_defense and #data or creature.mark_defense));
		creature.size = 'medium'; 
	end
	if not tmp then
		tmp,tmp2 = getLineByName('large',ldata,1,(nil == creature.mark_defense and #data or creature.mark_defense));
		creature.size = 'large'; 
	end
	if not tmp then
		tmp,tmp2 = getLineByName('huge',ldata,1,(nil == creature.mark_defense and #data or creature.mark_defense));
		creature.size = 'huge'; 
	end
	if not tmp then
		tmp,tmp2 = getLineByName('gargantuan',ldata,1,(nil == creature.mark_defense and #data or creature.mark_defense));
		creature.size = 'gargantuan'; 
	end
	if not tmp then
		tmp,tmp2 = getLineByName('colossal',ldata,1,(nil == creature.mark_defense and #data or creature.mark_defense));
		creature.size = 'colossal'; 
	end
	if not tmp then
		tmp,tmp2 = getLineByName('tiny',ldata,1,(nil == creature.mark_defense and #data or creature.mark_defense));
		creature.size = 'tiny'; 
	end
	if not tmp then
		tmp,tmp2 = getLineByName('diminutive',ldata,1,(nil == creature.mark_defense and #data or creature.mark_defense));
		creature.size = 'diminutive'; 
	end
	if not tmp then
		tmp,tmp2 = getLineByName('fine',ldata,1,(nil == creature.mark_defense and #data or creature.mark_defense));
		creature.size = 'fine'; 
	end
	creature.tpe = trim(data[tmp2]); 

	-- parse aura
	tmp = getLineByName('Aura',data,1,(nil == creature.mark_defense and #data or creature.mark_defense));
	aura = trim(getValueByName('Aura',tmp,termChars));
	creature.aura = aura; 

	-- parse EXP
	exp = getLineByName('XP',data,2); 
	exp = exp:gsub(',',''); 
	exp = exp:match('%d+'); 
	exp = tonumber(exp); 
	creature.exp = exp; 
end

--[[
	Parse all defense attributes such as weaknesses,resistances,saves,
	ac/hp etc..
	NOTE: SQ is processed here due to how FG combines the defense attributes and SQ together
]]--
function parseDefense(creature,data)
	local fort,ref,will,saverider; 
	local ac,ff,tch,acline,isenseline; 
	local sr,dr,weak,resist,imm,defab,sq,regen,fh; 
	local tmp; 
	local termChars = {';'}; 

	-- parse AC
	acline = getLineByName('AC',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense));
	if not acline then
		error('No \'AC\' field found within defenses'); 
	end
	ac = trim(getValueByName('AC',acline,termChars)); 
	ff = trim(getValueByName('flat-footed',acline,termChars)); 
	tch = trim(getValueByName('touch',acline,termChars)); 
	acline = trim(acline:gsub('AC','')); 
	creature.ac = ac;
	creature.ff = ff;
	creature.tch = tch; 
	creature.acline = acline; 

	-- parse HP/HD
	tmp = getLineByName('hp',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense));
	if not tmp then
		error('No \'hp\' field found within defenses'); 
	end
	hp = getValueByName('hp',tmp,termChars); 
	hp = getBonusNumber(hp,0); 
	hd = tmp:match('%(.+%)');
	hd = trim(hd:gsub('%(',''):gsub('%)','')); 
	creature.hp = hp; 
	creature.hd = hd; 

	-- parse Saves
	tmp = getLineByName('Fort',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense)); 
	if not tmp then
		error('No fort save found within defenses'); 
	end

	fort = getValueByName('Fort',tmp,termChars); 
	ref = getValueByName('Ref',tmp,termChars); 
	will = getValueByName('Will',tmp,termChars); 
	creature.fort = tonumber(getBonusNumber(fort,1));
	creature.ref = tonumber(getBonusNumber(ref,1));
	creature.will = tonumber(getBonusNumber(will,1)); 

	-- parse Save Riders
	saverider = tmp:find('vs.'); 
	if saverider then
		saverider = trim(tmp); 
		creature.saverider = saverider; 
	end

	-- parse DR
	tmp = getLineByName('DR',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense)); 
	if tmp then
		dr = getValueByName('DR',tmp,termChars); 
	end
	-- parse SR
	tmp = getLineByName('SR',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense)); 
	if tmp then
		sr = getValueByName('SR',tmp,termChars); 
	end
	-- parse Regeneration
	tmp = getLineByName('regeneration',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense)); 
	if tmp then
		regen = getValueByName('regeneration',tmp,termChars); 
	end
	-- parse Fast Healing
	tmp = getLineByName('fast healing',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense)); 
	if tmp then
		fh = getValueByName('fast healing',tmp,termChars); 
	end
	-- parse Weaknesses
	tmp = getLineByName('Weaknesses',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense)); 
	if tmp then
		weak = getValueByName('Weaknesses',tmp,termChars); 
	end
	-- parse Resistances
	tmp = getLineByName('Resist',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense)); 
	if tmp then
		resist = getValueByName('Resist',tmp,termChars); 
	end
	-- parse Immunities
	tmp = getLineByName('Immune',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense)); 
	if tmp then
		imm = getValueByName('Immune',tmp,termChars); 
	end
	-- parse Defensive Abilities
	tmp = getLineByName('Defensive Abilities',data,creature.mark_defense,(nil == creature.mark_offense and #data or creature.mark_offense)); 
	if tmp then
		defab = getValueByName('Defensive Abilities',tmp,termChars); 
	end
	-- parse Special Qualities (SQ)
	tmp = getLineByName('SQ',data,creature.mark_statistics,(nil == creature.mark_ecology and #data or creature.mark_ecology)); 
	if tmp then
		sq = getValueByName('SQ',tmp,{}); 
	end

	-- make SQ line (for FG)
	creature.sqline = ''; 
	if dr then creature.sqline = creature.sqline .. 'DR ' .. trim(dr):gsub(';','') .. '; '; end
	if sr then creature.sqline = creature.sqline .. 'SR ' .. trim(sr):gsub(';','') .. '; '; end
	if weak then creature.sqline = creature.sqline .. 'Weaknesses ' .. trim(weak):gsub(';','') .. '; '; end
	if resist then creature.sqline = creature.sqline .. 'Resistances ' .. trim(resist):gsub(';','') .. '; '; end
	if imm then creature.sqline = creature.sqline .. 'Immune ' .. trim(imm):gsub(';','') .. '; '; end
	if regen then creature.sqline = creature.sqline .. ' regeneration ' .. trim(regen):gsub(';','') .. '; ' ; end
	if fh then creature.sqline = creature.sqline .. ' fast healing ' .. trim(fh):gsub(';','') .. '; ' ; end
	if defab then creature.sqline = creature.sqline .. trim(defab):gsub(';','') .. '; ' ; end
	if sq then 
		creature.sqline = creature.sqline .. trim(sq); 
	elseif sqline ~= '' then
		creature.sqline = creature.sqline:sub(1,-3); 
	end


end

--[[
	Parse all offensive attributes such as speed, attacks, space/reach
	etc..
]]--
function parseOffense(creature,data)
	local err, errmsg; 
	local sa,spd,spc,rch,spcrchline,dfspc; 
	local tmp; 

	-- parse Special Attacks
	tmp = getLineByName('Special Attacks',data,creature.mark_offense,(nil == creature.mark_tactics and #data or creature.mark_tactics)); 
	if tmp then
		sa = getValueByName('Special Attacks',tmp,{}); 
		-- TODO add to creature.spells the special abilities of the attacks
	end
	if sa then creature.sa = trim(sa); end

	-- parse Speed
	tmp = getLineByName('Speed',data,creature.mark_offense,(nil == creature.mark_tactics and #data or creature.mark_tactics)); 
	if tmp then
		spd = trim(getValueByName('Speed',tmp,{})); 
	end
	if spd then creature.speed = spd; end

	-- parse Space
	tmp = getLineByName('Space',data,creature.mark_offense,(nil == creature.mark_tactics and #data or creature.mark_tactics)); 
	if tmp then
		spc = trim(getValueByName('Space',tmp,{';'})); 
	end

	-- parse Reach
	tmp = getLineByName('Reach',data,creature.mark_offense,(nil == creature.mark_tactics and #data or creature.mark_tactics)); 
	if tmp then
		rch = trim(getValueByName('Reach',tmp,{';'})); 
	end

	-- for cases where we are not provided 'space' we utilize the size
	-- which should have been captured in preliminaries, WARN if not
	-- available and use 5ft
	spcrchline = ''; 
	-- default space
	if creature.size == 'small' then
		dfspc = '5ft.'; 
	elseif creature.size == 'medium' then
		dfspc =  '5ft.'; 
	elseif creature.size == 'large' then
		dfspc =  '10ft.'; 
	elseif creature.size == 'huge' then
		dfspc =  '15ft.'; 
	elseif creature.size == 'gargantuan' then
		dfspc =  '20ft.'; 
	elseif creature.size == 'colossal' then
		dfspc =  '30ft.'; 
	elseif creature.size == 'diminutive' then
		dfspc =  '0ft.'; 
	elseif creature.size == 'fine' then
		dfspc =  '0ft.'; 
	else
		dfspc = '5ft.'; 
		addWarn('No size parameter located within statblock.'); 
	end

	if spc then
		spcrchline = spcrchline .. spc; 
	end
	if spcrchline ~= '' and rch then
		spcrchline = spcrchline .. '/' .. rch;
	elseif rch then
		-- space will default to size field
		spc = dfspc; 
		spcrchline = spc .. '/' .. rch; 
	else
		spcrchline = '5ft./5ft'; 
	end
	creature.spacereachline = spcrchline; 

	-- parse attacks
	if (not creature.error) then
		dlog('ok doing attacks',self); 
		err, errmsg = pcall(parseAttacks,creature,data); 
		if (not err) then
			addError('Error while parsing attacks: ' .. errmsg); 
			creature.error = true; 
		end
	end

	-- parse spells
	parseSpells(creature,data); 
end

--[[
	Parse out the spells
]]--
function parseSpells(creature,data)
	-- break out the spells by searching for 'spell-like','spells-known'
	-- 'spells prepared','extracts-prepared' and prepare the following datastructure:
	-- spells
	-- -> spellcasting type
	--    -> spell casting class
	--       -> spell levels
	--          -> spell name
	--             -> spell details
	--       -> CL/CC
	--       -> known 0,1,2,3,4,5,6,7,8,9
	formatSpells('Spell%-Like Abilities',creature,data); 
	formatSpells('Spells Known',creature,data); 
	formatSpells('Spells Prepared',creature,data); 
	formatSpells('Extracts Prepared',creature,data,1); 
end

--[[
	Formats spells by type, extra field is a flag field. For now
	it differs alchemists to not have a concentration or caster check
]]--
function formatSpells(typestr,creature,data,extra)
	local tmp;
	local spells = {}; 
	local start,fin,line,casterType,spellType;
	local concentration,casterLevel; 
	local a,b,i; 

	if creature.spells then spells = creature.spells; end

	line,start = getLineByName(typestr,data,creature.mark_offense,creature.mark_statistics); 
	creLog('formatSpells: formatting : ' .. typestr,3); 
	while (line) do
		if line then
			tmp = line:find('%('); 
			if tmp then
				casterType = trim(line:sub(1,line:find('%(')-1)); 
				concentration = tonumber(getBonusNumber(getValueByName('concentration',line,{';'}),0));
				casterLevel = tonumber(getBonusNumber(getValueByName('CL',line,{';'}),0)); 
				creLog('formatSpells: '..casterType..' concentration ' .. concentration,3); 
				creLog('formatSpells: '..casterType..' casterlevel ' .. casterLevel,3); 
				if casterLevel == 0 then
					addWarn('No caster level found for ' .. casterType); 
				end
				if concentration == 0 then
					addWarn('No concentration bonus found for ' .. casterType); 
				end
			else
				casterType = trim(line); 
				addWarn('No concentration bonus found for ' .. casterType); 
				addWarn('No caster level found for ' .. casterType); 
			end
			if not spells[casterType] then spells[casterType] = {}; end
			spells[casterType]['concentration'] = concentration;
			spells[casterType]['casterlevel'] = casterLevel; 
			start = start + 1; 
			-- parse spells following this line
			for i=start, #data do
				a,b = data[i]:find('%-%-'); 
				if a then
					--dlog('a: ' .. a .. ' b: ' .. b); 
					spellType = data[i]:sub(1,a-1); 
					if not spells[casterType][spellType] then spells[casterType][spellType]={}; end
					line = data[i]:sub(b+1);
					tmp = strsplitparen(line,','); 
					for k,v in pairs(tmp) do
						--dlog(v);
						creLog('formatSpells: Adding Spell: ' .. casterType .. ' ' .. spellType .. ' ' ..  v,3); 
						table.insert(spells[casterType][spellType],trim(formatSpellName(v))); 
						--TODO parse out multiple preparations (#)
					end
				else
					start = i; 
					break;
				end
			end
			line = getLineByName(typestr,data,start,creature.mark_statistics)
		else
			break; 
		end
	end

	if not creature.spells then creature.spells = spells; end
end

--[[
	Format the spell name to extract super/sub scripts, DC, number prepared,
	meta-magics etc...
]]--
function formatSpellName(spellstr)
	local spell = {};
	local termChars = {',',';'}; 
	local dc,nprep,meta,proper,varient;


	dc = getValueByName('DC',spellstr,termChars);
	if dc then 
		dc = getBonusNumber(dc,0); 
		nprep = spellstr:gsub(dc,'');
	else
		nprep = spellstr; 
	end

	nprep = getBonusNumber(nprep,0); 
	if tonumber(nprep) == 0 then
		nprep = 1;
	else 
		nprep = tonumber(nprep); 
	end

	proper = trim(spellstr:gsub('%(.+%)',''))
	proper = formatSuperSubScript(proper); 
	proper,varient = formatSpellStrength(proper); 
	proper,meta = formatMetaMagics(proper); 
	proper = fmtXmlName(proper); 

	spell['dc'] = dc;
	spell['prepped'] = nprep;
	spell['varient'] = varient or '';
	spell['meta'] = meta or '';
	spell['propername'] = proper; 
	spell['name'] = trim(spellstr); 
	creLog('formatSpellName: ' .. spell.name .. ' parsed',4); 
	return spell; 
end

--[[
	Format out super and subscripts often attached to spell names to
	get the base name. 
]]--
function formatSuperSubScript(str)
	if not str then return; end
	local retval = str; 
	local cases = {'1st','2nd','3rd','4th','5th','6th','7th','8th','9th',
		'UM','TG','UC','APG','MC','D','B'}; 
	
	for _,v in pairs(cases) do
		if v == '' or str:sub(-v:len()) == v then
			retval = trim(str:gsub(v,'')); 
		end
	end

	return retval; 
end

--[[
	Deal with spell strength varients
]]--
function formatSpellStrength(spellName)
	if not spellName then return; end
	local retval = spellName;
	local retval2; 
	local strengths = {'communal','mass','lesser','greater','IX','VIII','VII','VI','IV','V','III','II','I'};

	for _,v in pairs(strengths) do
		if spellName:find(v) then
			retval = trim(retval:gsub(v,'')); 	
			retval2 = v; 
			break; 
		end
	end
	return retval, retval2; 
end

--[[
	Format out meta magic prefixes often attached to spell names of
	high level magic casters, and get the base name. 
	TODO have this be a library link
	TODO there exists the case of multiple meta magics which is currently unhandled, we
	should ideally return a table as our meta field.
]]--
function formatMetaMagics(spellName)
	local retval,retval2;
	local metas = {
		'aquatic',
		'bouncing',
		'brisk',
		'burning',
		'coaxing',
		'concussive',
		'consecrated',
		'contagious',
		'dazing',
		'disruptive',
		'echoing',
		'eclipsed',
		'ectoplasmic',
		'elemental',
		'empowered',
		'encouraging',
		'enlarged',
		'extended',
		'fearsome',
		'flaring',
		'fleeting',
		'focused',
		'furious',
		'heightened',
		'intensified',
		'intuitive',
		'jinxed',
		'lingering',
		'logical',
		'maximized',
		'merciful',
		'persistent',
		'piercing',
		'quickened',
		'reach',
		'rimed',
		'scarring',
		'scouting',
		'seeking',
		'selective',
		'shadow',
		'sickening',
		'silent',
		'snuffing',
		'solar',
		'solid',
		'stilled',
		'studied',
		'stylized',
		'tenacious',
		'thanatopic',
		'tenebrous',
		'threatening',
		'threnodic',
		'thundering',
		'toppling',
		'toxic',
		'traumatic',
		'tricky',
		'umbral',
		'vast',
		'verdant',
		'widened',
		'yai-mimiced'
	}

	retval = spellName; 
	for _,v in pairs(metas) do
		if spellName:find(v) then
			retval = trim(retval:gsub(v,'')); 	
			retval2 = v; 
			break; 
		end
	end

	return retval,retval2; 
end

--[[
	Parse the tactics fields before/during combat, as well as morale
	@author Chris B (BigD3m0n)
]]--
function parseTactics(creature,data)
	local beforecombat, duringcombat, morale;
	local basestats;
	local tmp;

	tmp = getLineByName('Before Combat',data,creature.mark_tactics,(nil == creature.mark_statistics and #data or creature.mark_statistics));
	if tmp then
		beforecombat = trim(getValueByName('Before Combat',tmp,{}));
	end
	creature.beforecombat = beforecombat;

	tmp = getLineByName('During Combat',data,creature.mark_tactics,(nil == creature.mark_statistics and #data or creature.mark_statistics));
	if tmp then
		duringcombat = trim(getValueByName('During Combat',tmp,{}));
	end
	creature.duringcombat = duringcombat;

	tmp = getLineByName('Morale',data,creature.mark_tactics,(nil == creature.mark_statistics and #data or creature.mark_statistics));
	if tmp then
		morale = trim(getValueByName('Morale',tmp,{}));
	end
	creature.morale = morale;

	tmp = getLineByName('Base Statistics',data,creature.mark_tactics,(nil == creature.mark_statistics and #data or creature.mark_statistics));
	if tmp then
		basestats = trim(getValueByName('Base Statistics',tmp,{}));
	end
	creature.basestats = basestats;
	
end

--[[
	Parse the stastics attributes whicn include skills/feats/languages..
]]--
function parseStatistics(creature,data)
	local str,dex,con,int,wis,cha;
	local bab,cmb,cmd,babcmd,lang; 
	local err, errmsg; 
	local tmp;
	local termChars = {',',';'}; 

	-- parse Staistics
	tmp = getLineByName('Str',data,creature.mark_statistics,(nil == creature.mark_ecology and #data or creature.mark_ecology)); 
	str = getBonusNumber(getValueByName('Str',tmp,termChars),0); 
	dex = getBonusNumber(getValueByName('Dex',tmp,termChars),0); 
	con = getBonusNumber(getValueByName('Con',tmp,termChars),0); 
	int = getBonusNumber(getValueByName('Int',tmp,termChars),0); 
	wis = getBonusNumber(getValueByName('Wis',tmp,termChars),0); 
	cha = getBonusNumber(getValueByName('Cha',tmp,termChars),0); 
	creature.str = str;
	creature.dex = dex;
	creature.con = con;
	creature.int = int;
	creature.wis = wis;
	creature.cha = cha; 

	-- parse BAB/CMB/CMD
	babcmd = getLineByName('Base Atk',data,creature.mark_statistics,(nil == creature.mark_ecology and #data or creature.mark_ecology)); 
	creature.babcmd = babcmd; 

	-- parse Feats, Skills
	if (not creature.error) then
		dlog('ok doing feats/skills',self); 
		err, errmsg = pcall(parseFeatsSkills,creature,data); 
		if (not err) then
			addError('Error while parsing Feats and Skills: ' .. errmsg); 
			creature.error = true; 
		end
	end

	-- parse language
	lang = getLineByName('Languages',data,creature.mark_statistics,(nil == creature.mark_ecology and #data or creature.mark_ecology)); 
	if lang then creature.lang = trim(getValueByName('Languages',lang,{})); end

	-- parse Equipment (and treasure)
	if (not creature.error) then
		dlog('ok doing equipment',self); 
		err, errmsg = pcall(parseEquipment,creature,data); 
		if (not err) then
			addError('Error while parsing equipment: ' .. errmsg); 
			creature.error = true; 
		end
	end
	
end

--[[
	Parse the ecology attributes such as environment/organization/treasure.
	NOTE: treasure is parsed in statistics as it's combined with gear(combat/other/untyped)
]]--
function parseEcology(creature,data)
	local org,env;
	local tmp; 

	tmp = getLineByName('Organization',data,creature.mark_ecology,(nil == creature.mark_special_abilities and #data or creature.mark_special_abilities)); 
	if tmp then
		org = trim(getValueByName('Organization',tmp,{})); 
	end
	creature.organization = org;

	tmp = getLineByName('Environment',data,creature.mark_ecology,(nil == creature.mark_special_abilities and #data or creature.mark_special_abilities)); 
	if tmp then
		env = trim(getValueByName('Environment',tmp,{})); 
	end
	creature.environment = env;
end

--[[
	Create a table of name-description pairs and store it to the creature
]]--
function parseSpecialAbilities(creature,data,ldata)
	local termChars = {',',';'}; 
	local line,abname,abdesc;
	local ab = {}; 
	local tmp; 

	if creature.mark_special_abilities ~= #data then
		for i=creature.mark_special_abilities, #data do
			line = data[i];
			lline = ldata[i]; 
			-- TODO pull name out
			if lline:match(escMagic('(su)')) then
				tmp = line:find(escMagic(')')); 
				abname = trim(line:sub(1,tmp)); 
				abdesc = trim(line:sub(tmp+1)); 
				ab[abname] = abdesc; 
			elseif lline:match(escMagic('(ex)')) then
				tmp = line:find(escMagic(')')); 
				abname = trim(line:sub(1,tmp)); 
				abdesc = trim(line:sub(tmp+1)); 
				ab[abname] = abdesc; 
			elseif lline:match(escMagic('(sp)')) then
				tmp = line:find(escMagic(')')); 
				abname = trim(line:sub(1,tmp)); 
				abdesc = trim(line:sub(tmp+1)); 
				ab[abname] = abdesc; 
			end
		end
	end

	for k,v in pairs(ab) do
		creLog('parseSpecialAbilities: k: ' .. k .. ' v: ' .. v,3); 
	end
	if next(ab) ~= nil then
		creature.specialab = ab; 
	end
end


--[[
	Parse Feats and skills, simple line extraction
]]--
function parseFeatsSkills(creature,data)
	local feats,skills,tmp;

	tmp = getLineByName('Feats',data,creature.mark_statistics,(nil == creature.mark_ecology and #data or creature.mark_ecology)); 
	feats = trim(getValueByName('Feats',tmp,{})); 
	creature.feats = feats;

	tmp = getLineByName('Skills',data,creature.mark_statistics,(nil == creature.mark_ecology and #data or creature.mark_ecology)); 
	skills = trim(getValueByName('Skills',tmp,{})); 
	creature.skills = skills; 
end

--[[
	Parse attacks (ranged/melee) simple line extraction with iterative truncating
]]--
function parseAttacks(creature,data)
	local melee,ranged,attack,fattack,tmp;

	tmp = getLineByName('Melee',data,creature.mark_offense,(nil == creature.mark_statistics and #data or creature.mark_statistics)); 
	melee = trim(getValueByName('Melee',tmp,{})); 
	
	tmp = getLineByName('Ranged',data,creature.mark_offense,(nil == creature.mark_statistics and #data or creature.mark_statistics)); 
	ranged = trim(getValueByName('Ranged',tmp,{}));

	creLog('parseAttacks (melee)' .. tostring(melee),1);
	creLog('parseAttacks (ranged)' .. tostring(ranged),1);

	if (melee and ranged) then
		creature.fattack = melee:gsub(',',' and ') .. ' or ' .. ranged:gsub(',',' and ');
		creature.attack = dropIter(melee):gsub(' and ',' or ') .. ' or ' .. dropIter(ranged):gsub(' and ',' or ');
	elseif (melee) then
		creature.fattack = melee:gsub(',',' and ');
		creature.attack = dropIter(melee):gsub(' and ',' or '); 
	elseif (ranged) then
		creature.fattack = ranged:gsub(',',' and ');
		creature.attack = dropIter(ranged):gsub(' and ',' or '); 
	end
end

--[[
	Drop the iteratives off any attack as well as multi-attacks (used for the single attack line vs the full attack in FG)
]]--
function dropIter(atkline)
	local atks,rv,dmg,tmp,i;

	atkline = atkline:gsub(' and ',','); 
	tmp = strsplitpattern(atkline,' or ');

	volleys = {}; 
	atks = {}; 
	for k,v in pairs(tmp) do
		atks = {}; 
		v = strsplit(v,',');  
		i = 1; 
		for km,vm in pairs(v) do
			atks[i] = trim(vm);
			i = i + 1; 
		end
		table.insert(volleys,atks); 
	end

	local atkName,a,b,c,d,mod,newmod; 
	for k,v in pairs(volleys) do
		for ke,va in pairs(v) do
			atkName = va:match('%a+');
			a,b = va:find(atkName);
			c,d = va:find('[^%a%s]+',b); 
			mod = va:sub(c,d);
			newmod = getBonusNumber(va:sub(c,va:find('[/%s]',c)),1);
			--dlog(va .. a .. ' ' .. b .. ' ' .. c .. ' ' .. d .. ' ' .. mod .. ' ' .. newmod); 
			va = va:gsub(escMagic(mod),newmod); 
			-- strip multiple attacks
			a = va:match('%d+'); 
			c,d = va:find(a); 
			if c == 1 then
				va = trim(va:sub(d+1)); 
			end
			volleys[k][ke] = va; 
			creLog('dropIter (dropping iteratives) : ' .. tostring(va),3); 
		end
	end

	rv = ''; 
	for k,v in pairs(volleys) do
		for ke,va in pairs(v) do
			rv = rv .. va .. ' and ' 	
		end
		-- handle trailing and
		rv = rv:sub(1,#rv-5);
		rv = rv .. ' or '; 
	end
	-- handle trailing or
	rv = rv:sub(1,#rv-4); 

	return rv; 
end

--[[
	Parse Equipment, note that Gear and treasure are joined to a uniform value as FG only has a 'treasure' feild
]]--
function parseEquipment(creature, data)
	local termChars = {';'}; 
	local cgear,ogear,gear,tres,tmp; 

	tmp = getLineByName('Combat Gear',data,creature.mark_statistics,(nil == creature.mark_ecology and #data or creature.mark_ecology)); 
	if tmp then
		cgear = trim(getValueByName('Combat Gear',tmp,termChars)); 
	end

	tmp = getLineByName('Other Gear',data,creature.mark_statistics,(nil == creature.mark_ecology and #data or creature.mark_ecology)); 
	if tmp then
		ogear = trim(getValueByName('Other Gear',tmp,termChars)); 
	end

	if not cgear and not ogear then
		tmp = getLineByName('Other Gear',data,creature.mark_statistics,(nil == creature.mark_ecology and #data or creature.mark_ecology)); 
		if tmp then
			gear = trim(getValueByName('Gear',tmp,termChars));
		end
	end

	if not cgear and not ogear and not gear then
		tmp = getLineByName('Treasure',data,creature.mark_ecology,(nil == creature.mark_special_abilities and #data or creature.mark_special_abilities)); 
		if tmp then
			tres = trim(getValueByName('Treasure',tmp,termChars)); 
		end
	end

	if tres then
		creature.gearline = tres;
	elseif gear then
		creature.gearline = gear;
	elseif cgear and ogear then
		creature.gearline = cgear .. ', ' .. ogear; 
	end
end

-- -- --
--
--
-- Workhorse functions
--
--
-- -- --

--[[
	0 is scalar, 1 is signed
]]--
function getBonusNumber(str, type)
	if (not str) then return '0'; end
	if (not type) then type = 1; end

	local retval = '0';
	local locStart = 0;
	local locEnd = #str;
	local num;

	str = str:gsub('%s','');
	if type == 0 then
		num = str:match('%d+');
		if num then 
			retval = num;
		else 
			retval = '0'
		end
	elseif type == 1 then
		num = str:match('%+%d+');
		if num == nil then
			num = str:match('%-%d+');
			if num == nil then
				num = str:match('%d+');
				if num == nil then
					num = '0';
				end
			end
		end
		retval = num; 
	end
	return retval; 
end


--[[
	Given a name, array of lines, and a start/end location, find the first
	line that contains the given name. 
]]--
function getLineByName(strName, aryLines, locStart, locEnd)
	creLog('getLineByName: name ' .. strName .. ' data ' .. tostring(aryLines ~= nil),5); 
	if (not strName or not aryLines) then return nil; end
	if (not locStart) then locStart = 1; end
	local retval1,retval2;
	if not locEnd then
		locEnd = #aryLines; 
	end

	
	creLog("getLineByName: " .. strName .. ' ' .. tostring(locStart) .. ' ' .. tostring(locEnd) .. ' ' .. tostring(aryLines ~= nil),5); 

	for i=locStart, locEnd do
		if (aryLines[i]:find(strName) ~= nil) then
			retval1 = aryLines[i];
			retval2 = i; 
			break;
		end
	end

	creLog('getLineByName: name ' .. strName .. ' value: ' .. tostring(retval1) .. ' ' .. tostring(retval2),5); 
	return retval1, retval2; 
end


--[[
	Given a line, name and terminators, return the value. Value is
	the trimmed text after the name and before the terminator
]]--
function getValueByName(strName, strLine, termChars)
	if (not strLine or not strName or not termChars) then return nil end;
	local retval;
	local loc = -1; 
	local locTerm = #strLine;

	creLog("getValueByName: " .. strName .. ' ' .. tostring(termChars) .. ' ' .. strLine,5); 
	loc = strLine:find(strName);
	if loc then
		for i = 1, #termChars do
			local tmp = strLine:find(termChars[i],loc);
			if ((tmp ~= nil) and (tmp < locTerm)) then
				locTerm = tmp;
			end
		end
		if (locTerm > loc) then
			locTerm = getParenSafeTerm(strLine,loc,locTerm,termChars);
			retval = strLine:sub(loc+#strName,locTerm); 
			creLog('getValueByName: name ' .. strName .. ' f-start ' .. loc+#strName .. ' f-fin ' .. locTerm-1,5); 
		end
	else
		creLog('getValueByName: name ' .. strName .. ' not found in ' .. strLine,4); 
	end

	creLog('getValueByName: name ' .. strName .. ' value: ' .. tostring(retval),5); 
	return retval; 
end

--[[ 
	Get the location of the close terminator that is paren safe. If there
	are parens.
	TODO Fix this
]]--
function getParenSafeTerm(strLine, start, fin, termChars)
	local newTerm = -1;
	local inParen = 0;
	local closeLoc = -1;
	local i; 

	creLog('getParenSafeTerm: start ' .. start .. ' fin ' .. fin .. ' strLine ' .. #strLine,5); 
	if (start >= fin) then return fin; end
	for i = start, #strLine do
		if strLine:sub(i,i) == '(' then
			inParen = inParen + 1;
		elseif strLine:sub(i,i) == ')' then
			inParen = inParen -1;
		end
		if i >= fin then
			if inParen <= 0 then
				--if fin ~= #strLine then fin = fin-1; end
				return fin;
			elseif inParen > 0 then
				break;
			end
		end
	end
	if inParen <= 0 then
		return fin; 
	end
	creLog("in parens for " .. strLine .. " openparens: " .. inParen,5);
	closeLoc = strLine:find(')',start);
	fin = #strLine;
	if closeLoc == -1 then
		return fin;
	end
	for i=1, #termChars do
		newTerm = strLine:find(termChars[i],closeLoc); 
		if nil == newTerm then
			newTerm = #strLine
		elseif newTerm <= fin then
			fin = newTerm;
		end
	end
	-- hack for end of line terminators (inclusive terminators...)
	--[[
	if #strLine ~= fin then
		fin = fin-1; 
	end
	]]--

	return fin; 
end

--[[
	String the dataset of special unicode into forms we can deal with
--]]
function stripString(data)
	-- UTF-8 triples
	data = data:gsub('&#226;&#128;&#148;','--'); 
	data = data:gsub('&#226;&#128;&#147;','-'); 
	data = data:gsub('&#226;&#128;&#156;','"'); 
	data = data:gsub('&#226;&#128;&#157;','"'); 
	data = data:gsub('&#226;&#128;&#153;','\''); 

	-- UTF-8 doubles
	data = data:gsub('&#195;&#151;','x'); 

	-- UTF-8 singles
	data = data:gsub('&#34;','"'); 


	-- UTF-8 codes
	data = data:gsub('\\u2013','-'); 
	data = data:gsub('\\u2014','--'); 
	data = data:gsub('\\u2019','\''); 
	data = data:gsub('\\u201d','\"'); 
	data = data:gsub('\\u201c','\"'); 

	return data; 
end

--[[
	Trim leading and trailing whitespace
--]]
function trim(s)
	if type(s) ~= 'string' then
		return s;
	end
	return (s:gsub("^%s*(.-)%s*$", "%1")); 
end

--[[
	Remove magic characters
]]--
function rmMagic(str)
	if not str then return; end
	str = str:gsub('%(',' '); 
	str = str:gsub('%)',' '); 
	str = str:gsub('%.',' '); 
	str = str:gsub('%+',' '); 
	str = str:gsub('%-',' '); 
	str = str:gsub('%*)',' '); 
	str = str:gsub('%?)',' '); 
	str = str:gsub('%[)',' '); 
	str = str:gsub('%^)',' '); 
	str = str:gsub('%$)',' '); 
	return str; 
end

--[[
	Escape magic characters
]]--
function escMagic(str)
	if not str then return; end
	str = str:gsub('%(','%%('); 
	str = str:gsub('%)','%%)'); 
	str = str:gsub('%.','%%.'); 
	str = str:gsub('%+','%%+'); 
	str = str:gsub('%-','%%-'); 
	str = str:gsub('%*)','%%*)'); 
	str = str:gsub('%?)','%%?)'); 
	str = str:gsub('%[)','%%[)'); 
	str = str:gsub('%^)','%%^)'); 
	str = str:gsub('%$)','%%$)'); 
	return str; 
end

--[[
	Strip tags (from spell library descriptions)
]]--
function stripTags(str)
	if not str then return; end
	str = str:gsub('<p>',''); 
	str = str:gsub('</p>','\n'); 
	str = str:gsub('<b>',''); 
	str = str:gsub('</b>',''); 
	str = str:gsub('<i>',''); 
	str = str:gsub('</i>',''); 
	return str; 
end

--[[
	Formats a string into a legal xml name
]]--
function fmtXmlName(str)
	if not str then return; end
	str = str:gsub('\'','');
	str = str:gsub('%s','');
	str = str:gsub('/','');
	str = str:lower(); 
	return str; 
end


--[[ 
	@author anonymous
	http://stackoverflow.com/questions/1426954/split-string-in-lua
]]--
function strsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"; 
	elseif inputstr == nil then
		return {}; 
	end
	local t={}; 
	local i=1; 
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str; 
		i = i + 1; 
	end
	return t
end

--[[
	Split string based on a pattern
]]--
function strsplitpattern(inputstr, sep)
	local a,b,o,line; 
	if sep == nil then
		sep = "%s";
	elseif inputstr == nil then
		return {};
	end

	local t={}
	local line = inputstr; 

	a,b = line:find(sep);
	while a ~= nil do
		table.insert(t,line:sub(1,a-1));
		o = b+1;
		line = line:sub(o); 
		a,b = line:find(sep); 
	end	
	table.insert(t,line);
	return t; 

end

--[[
	Split string based on a character (paren safe)
]]--
function strsplitparen(inputstr, sep)
	local a,b,o,line,substr; 
	if sep == nil then
		return {}; 
	elseif inputstr == nil then
		return {};
	end

	local t={}
	local line = inputstr; 

	a,b = line:find(sep);
	--dlog(line); 
	--dlog('a: ' .. a .. ' b: ' .. b); 
	while a ~= nil do
		b = getParenSafeTerm(line,1,b,{sep});
		--dlog('b: ' .. b .. ' after paren.. line length: ' .. tostring(#line)); 
		if b ~= #line then b = b-1; end
		substr = line:sub(1,b); 
		table.insert(t,substr); 
		line = line:sub(b+2);
		--dlog(line); 
		if not line then break; end
		a,b = line:find(sep); 
		--dlog(line); 
		if not a then break; end
		--dlog('a: ' .. a .. ' b: ' .. b); 
	end	
	if #line > 1 then
		table.insert(t,line);
	end
	return t; 

end
