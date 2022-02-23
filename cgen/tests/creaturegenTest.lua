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

package.path = package.path .. ";" .. "cgen/lua/?.lua" .. ";" .. "cgen/tests/?.lua" .. ";" .. "cgen/tests/oglcontent/?.lua" .. ";" .. "cgen/tests/framework/?.lua"

local lu = require('luaunit')
local StringUtils = require('StringUtils')
local TableUtils = require('TableUtils')
local D20pfsrdDOTcom = require('D20pfsrdDOTcom')

Debug = {}
function Debug.console(string)
  print(string)
end

Comm = {}
function Comm.addChatMessage(msg)
  print("CHAT: ".. StringUtils.serializeTable(msg))
end

require('creaturegen')



TestGenesis = {}
function TestGenesis:testCopyFromD20PFSRDdotCOM()
  local actual = genesis(D20pfsrdDOTcom.kraken());
  print(StringUtils.serializeTable(actual))
  
  lu.assertNotNil(actual)
  lu.assertNotNil(actual.creature)
  
  
  -- GENERAL
  lu.assertEquals("Kraken", actual.creature.name)
  lu.assertEquals(18, actual.creature.cr)
  lu.assertEquals(153600, actual.creature.exp)
  lu.assertEquals("gargantuan", actual.creature.size)
  lu.assertEquals("NE Gargantuan magical beast (aquatic)", actual.creature.tpe)
  lu.assertEquals(4, actual.creature.init)
  lu.assertEquals("darkvision 120 ft., low-light vision; Perception +28", actual.creature.senses)
  
  
  -- DEFENSE
  lu.assertEquals(32, actual.creature.ac)
  lu.assertEquals(6, actual.creature.tch)
  lu.assertEquals(32, actual.creature.ff)
  lu.assertEquals("32, touch 6, flat-footed 32 (+26 natural, -4 size)", actual.creature.acline)
  lu.assertEquals("20d10+180", actual.creature.hd)
  lu.assertEquals(290, actual.creature.hp)
  lu.assertEquals(21, actual.creature.fort)
  lu.assertEquals(12, actual.creature.ref)
  lu.assertEquals(11, actual.creature.will)
  lu.assertEquals("Immune cold, mind-affecting effects, poison; Special Qualities tenacious grapple", actual.creature.sqline)
  
  -- OFFENSE
  lu.assertEquals("10 ft., swim 40 ft., jet 280 ft.", actual.creature.speed);
  lu.assertEquals("2 arms +26 (2d6+10/19-20 plus grab) and 8 tentacles +24 (1d8+5 plus grab) and bite +26 (2d8+10)", actual.creature.fattack);
  lu.assertEquals("arms +26 (2d6+10/19-20 plus grab) or tentacles +24 (1d8+5 plus grab) or bite +26 (2d8+10)", actual.creature.attack);
  lu.assertEquals("20 ft./20 ft. (60 ft. with arm, 40 ft. with tentacle)", actual.creature.spacereachline);
  lu.assertEquals("constrict (tentacles, 1d8+10), ink cloud, rend ship", actual.creature.sa);
  
  -- Spells
  lu.assertNotNil(actual.creature.spells)
  lu.assertNotNil(actual.creature.spells['spell-like abilities'])
  lu.assertEquals(0, actual.creature.spells['spell-like abilities'].concentration)
  lu.assertEquals(15, actual.creature.spells['spell-like abilities'].casterlevel)
  local spelllike = actual.creature.spells['spell-like abilities']['1/day']
  lu.assertNotNil(spelllike)
  lu.assertEquals(4, #spelllike)
  lu.assertEquals("controlweather", spelllike[1].propername)
  lu.assertEquals("controlwinds", spelllike[2].propername)
  lu.assertEquals("dominatemonster", spelllike[3].propername)
  lu.assertEquals(24, spelllike[3].dc)
  lu.assertEquals("resistenergy", spelllike[4].propername)
  
  -- STATISTICS
  lu.assertEquals(30, actual.creature.str)
  lu.assertEquals(10, actual.creature.dex)
  lu.assertEquals(29, actual.creature.con)
  lu.assertEquals(21, actual.creature.int)
  lu.assertEquals(20, actual.creature.wis)
  lu.assertEquals(21, actual.creature.cha)
  lu.assertEquals("Base Atk +20; CMB +34 (+38 grappling); CMD 44 (can't be tripped)", actual.creature.babcmd)
  lu.assertEquals( "Bleeding Critical, Blind-Fight, Cleave, Combat Expertise, Critical Focus, Improved Critical (arm), Improved Initiative, Improved Trip, Multiattack, Power Attack", actual.creature.feats)
  lu.assertEquals( "Intimidate +25, Knowledge (geography) +25, Knowledge (nature) +25, Perception +28, Stealth +11, Swim +41, Use Magic Device +25", actual.creature.skills)
  lu.assertEquals( "Aquan, Common", actual.creature.lang)
  
  -- SPECIAL ABILITIES
  
  lu.assertNotNil(actual.creature.specialab)
  lu.assertEquals(4, TableUtils.tableLength(actual.creature.specialab))
  lu.assertEquals([[A kraken can emit a cloud of black, venomous ink in an 80-foot spread once per minute as a free action while underwater. This cloud provides total concealment, which the kraken can use to escape a fight that is going badly. Creatures within the cloud are considered to be in darkness. In addition, the ink is toxic, functioning as contact poison against all creatures caught within it. The ink cloud persists for 1 minute before dispersing. The save DC against the poison effect is Constitution-based.
Kraken Ink: Ink cloud--contact; save Fort DC 29; frequency 1/round for 10 rounds; effect 1 Str damage plus nausea; cure 2 consecutive saves.]], actual.creature.specialab["Ink Cloud (Ex)"])
  lu.assertEquals("A kraken can jet backward as a full-round action, at a speed of 280 feet. It must move in a straight line, but does not provoke attacks of opportunity while jetting.", actual.creature.specialab["Jet (Ex)"])
  lu.assertEquals("As a full-round action, a kraken can attempt to use four of its tentacles to grapple a ship of its size or smaller. It makes a CMB check opposed by the ship's captain's Profession (sailor) check, but the kraken gets a cumulative +4 bonus on the check for each size category smaller than Gargantuan the ship is. If the kraken grapples the ship, it holds the ship motionless; it can attack targets anywhere on or within the ship with its tentacles, but can only attack foes on deck with its free arms and can't attack foes at all with its beak. Each round it maintains its hold on the ship, it automatically inflicts bite damage on the ship's hull.", actual.creature.specialab["Rend Ship (Ex)"])
  lu.assertEquals("A kraken does not gain the grappled condition if it grapples a foe with its arms or tentacles.", actual.creature.specialab["Tenacious Grapple (Ex)"])

  -- ECOLOGY
  lu.assertEquals("any ocean", actual.creature.environment)
  lu.assertEquals("solitary", actual.creature.organization)
  lu.assertEquals("triple", actual.creature.gearline)

end

os.exit( lu.LuaUnit.run() )