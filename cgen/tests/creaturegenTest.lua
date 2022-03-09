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
]] --
package.path = package.path .. ";" .. "cgen/lua/?.lua" .. ";" .. "cgen/tests/?.lua" .. ";" .. "cgen/tests/oglcontent/?.lua" .. ";" .. "cgen/tests/framework/?.lua"

local lu = require('luaunit')
local StringUtils = require('StringUtils')
local TableUtils = require('TableUtils')
local D20pfsrdDOTcom = require('D20pfsrdDOTcom')
local Pathbuilder = require('Pathbuilder')

Debug = {}
function Debug.console(string)
	print(string)
end

Comm = {}
function Comm.addChatMessage(msg)
	print("CHAT: " .. StringUtils.serializeTable(msg))
end

require('creaturegen')

TestGenesis = {}
function TestGenesis:testCopyKrakenFromD20PFSRDdotCOM()
	local actual = genesis(D20pfsrdDOTcom.kraken());
	print(StringUtils.serializeTable(actual))

	lu.assertNotNil(actual)
	lu.assertNotNil(actual.creature)
	lu.assertNil(actual.creature.error)

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
	lu.assertNotNil(actual.creature.effects)
	lu.assertEquals({{type = 'cold'}, {type = 'mind-affecting effects'}, {type = 'poison'}}, actual.creature.effects.immunities)

	-- OFFENSE
	lu.assertEquals("10 ft., swim 40 ft., jet 280 ft.", actual.creature.speed);
	lu.assertEquals("2 arms +26 (2d6+10/19-20 plus grab) and 8 tentacles +24 (1d8+5 plus grab) and bite +26 (2d8+10)", actual.creature.fattack);
	lu.assertEquals("arms +26 (2d6+10/19-20 plus grab) or tentacles +24 (1d8+5 plus grab) or bite +26 (2d8+10)", actual.creature.attack);
	lu.assertEquals("20 ft./20 ft. (60 ft. with arm, 40 ft. with tentacle)", actual.creature.spacereachline);
	lu.assertEquals("constrict (tentacles, 1d8+10), ink cloud, rend ship", actual.creature.sa);

	-- Spells
	lu.assertNotNil(actual.creature.spells)
	lu.assertEquals(1, TableUtils.tableLength(actual.creature.spells))
	lu.assertNotNil(actual.creature.spells['spell-like abilities'])
	lu.assertEquals(0, actual.creature.spells['spell-like abilities'].concentration)
	lu.assertEquals(15, actual.creature.spells['spell-like abilities'].casterlevel)
	lu.assertEquals(3, TableUtils.tableLength(actual.creature.spells['spell-like abilities']))
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
	lu.assertEquals("Bleeding Critical, Blind-Fight, Cleave, Combat Expertise, Critical Focus, Improved Critical (arm), Improved Initiative, Improved Trip, Multiattack, Power Attack",
	                actual.creature.feats)
	lu.assertEquals("Intimidate +25, Knowledge (geography) +25, Knowledge (nature) +25, Perception +28, Stealth +11, Swim +41, Use Magic Device +25", actual.creature.skills)
	lu.assertEquals("Aquan, Common", actual.creature.lang)

	-- SPECIAL ABILITIES
	lu.assertNotNil(actual.creature.specialab)
	lu.assertEquals(4, TableUtils.tableLength(actual.creature.specialab))
	lu.assertEquals(
		[[A kraken can emit a cloud of black, venomous ink in an 80-foot spread once per minute as a free action while underwater. This cloud provides total concealment, which the kraken can use to escape a fight that is going badly. Creatures within the cloud are considered to be in darkness. In addition, the ink is toxic, functioning as contact poison against all creatures caught within it. The ink cloud persists for 1 minute before dispersing. The save DC against the poison effect is Constitution-based.
Kraken Ink: Ink cloud--contact; save Fort DC 29; frequency 1/round for 10 rounds; effect 1 Str damage plus nausea; cure 2 consecutive saves.]], actual.creature.specialab["Ink Cloud (Ex)"])
	lu.assertEquals("A kraken can jet backward as a full-round action, at a speed of 280 feet. It must move in a straight line, but does not provoke attacks of opportunity while jetting.",
	                actual.creature.specialab["Jet (Ex)"])
	lu.assertEquals(
		"As a full-round action, a kraken can attempt to use four of its tentacles to grapple a ship of its size or smaller. It makes a CMB check opposed by the ship's captain's Profession (sailor) check, but the kraken gets a cumulative +4 bonus on the check for each size category smaller than Gargantuan the ship is. If the kraken grapples the ship, it holds the ship motionless; it can attack targets anywhere on or within the ship with its tentacles, but can only attack foes on deck with its free arms and can't attack foes at all with its beak. Each round it maintains its hold on the ship, it automatically inflicts bite damage on the ship's hull.",
		actual.creature.specialab["Rend Ship (Ex)"])
	lu.assertEquals("A kraken does not gain the grappled condition if it grapples a foe with its arms or tentacles.", actual.creature.specialab["Tenacious Grapple (Ex)"])

	-- ECOLOGY
	lu.assertEquals("any ocean", actual.creature.environment)
	lu.assertEquals("solitary", actual.creature.organization)
	lu.assertEquals("triple", actual.creature.gearline)

end

function TestGenesis:testCopyScorpionfolkFromD20PFSRDdotCOM()
	local actual = genesis(D20pfsrdDOTcom.scorpionfolk());
	print(StringUtils.serializeTable(actual))

	lu.assertNotNil(actual)
	lu.assertNotNil(actual.creature)
	lu.assertNil(actual.creature.error)

	-- GENERAL
	lu.assertEquals("Scorpionfolk", actual.creature.name)
	lu.assertEquals(7, actual.creature.cr)
	lu.assertEquals(3200, actual.creature.exp)
	lu.assertEquals("large", actual.creature.size)
	lu.assertEquals("LE Large monstrous humanoid", actual.creature.tpe)
	lu.assertEquals(5, actual.creature.init)
	lu.assertEquals("darkvision 60 ft.; Perception +17", actual.creature.senses)

	-- DEFENSE
	lu.assertEquals(16, actual.creature.ac)
	lu.assertEquals(10, actual.creature.tch)
	lu.assertEquals(15, actual.creature.ff)
	lu.assertEquals("16, touch 10, flat-footed 15 (+1 Dex, +6 natural, -1 size)", actual.creature.acline)
	lu.assertEquals("12d10+12", actual.creature.hd)
	lu.assertEquals(78, actual.creature.hp)
	lu.assertEquals(7, actual.creature.fort)
	lu.assertEquals(9, actual.creature.ref)
	lu.assertEquals(10, actual.creature.will)
	lu.assertEquals("SR 18; Resist fire 5", actual.creature.sqline)
	lu.assertNotNil(actual.creature.effects)
	lu.assertEquals({{type = 'fire', mod = 5}}, actual.creature.effects.resistances)

	-- OFFENSE
	lu.assertEquals("40 ft.", actual.creature.speed);
	lu.assertEquals("sting +16 (1d8+4 plus poison) and 2 claws +13 (1d6+2) or large heavy lance +17 (2d6+6) and sting +14 (1d8+2 plus poison) and 2 claws +13 (1d6+2)", actual.creature.fattack);
	lu.assertEquals("sting +16 (1d8+4 plus poison) or claws +13 (1d6+2) or large heavy lance +17 (2d6+6) or sting +14 (1d8+2 plus poison) or claws +13 (1d6+2)", actual.creature.attack);
	lu.assertEquals("10 ft./10 ft.", actual.creature.spacereachline);
	lu.assertEquals("poison, trample (1d6+4, DC 20)", actual.creature.sa);

	-- Spells
	lu.assertNotNil(actual.creature.spells)
	lu.assertEquals(1, TableUtils.tableLength(actual.creature.spells))
	lu.assertNotNil(actual.creature.spells['spell-like abilities'])
	lu.assertEquals(0, actual.creature.spells['spell-like abilities'].concentration)
	lu.assertEquals(10, actual.creature.spells['spell-like abilities'].casterlevel)
	lu.assertEquals(4, TableUtils.tableLength(actual.creature.spells['spell-like abilities']))
	local spelllikeFirst = actual.creature.spells['spell-like abilities']['1/day']
	lu.assertNotNil(spelllikeFirst)
	lu.assertEquals(1, #spelllikeFirst)
	lu.assertEquals("majorimage", spelllikeFirst[1].propername)
	lu.assertEquals(15, spelllikeFirst[1].dc)

	local spelllikeSecond = actual.creature.spells['spell-like abilities']['2/day']
	lu.assertNotNil(spelllikeSecond)
	lu.assertEquals(1, #spelllikeSecond)
	lu.assertEquals("mirrorimage", spelllikeSecond[1].propername)

	-- STATISTICS
	lu.assertEquals(19, actual.creature.str)
	lu.assertEquals(12, actual.creature.dex)
	lu.assertEquals(13, actual.creature.con)
	lu.assertEquals(18, actual.creature.int)
	lu.assertEquals(14, actual.creature.wis)
	lu.assertEquals(15, actual.creature.cha)
	lu.assertEquals("Base Atk +12; CMB +17; CMD 28 (32 vs. trip attempts)", actual.creature.babcmd)
	lu.assertEquals("Alertness, Great Fortitude, Improved Initiative, Multiattack, Power Attack, Weapon Focus (sting)",
	                actual.creature.feats)
	lu.assertEquals("Diplomacy +4, Intimidate +17, Perception +17, Sense Motive +15", actual.creature.skills)
	lu.assertEquals("Common, Terran", actual.creature.lang)

	-- SPECIAL ABILITIES
	lu.assertNotNil(actual.creature.specialab)
	lu.assertEquals(1, TableUtils.tableLength(actual.creature.specialab))
	lu.assertEquals(
		[[Sting - injury; save Fort DC 17; frequency 1/round. for 6 rounds.; effect 1d2 Dex; cure 1 save. The save DC is Constitution-based.]], actual.creature.specialab["Poison (Ex)"])

	-- ECOLOGY
	lu.assertEquals("warm desert, plains, hills", actual.creature.environment)
	lu.assertEquals("solitary, pair, company (3-5), patrol (6-20 plus 2-8 Medium-sized scorpions plus 1 ranger of 3rd-5th level), or troop (21-40 plus 4-32 Medium-sized scorpions plus 1-4 giant scorpions plus 1 cleric of 6th-8th level plus 1 ranger of 6th-8th level)", actual.creature.organization)
	lu.assertEquals("standard", actual.creature.gearline)

end

function TestGenesis:testCopyFromPathbuilder()
	local actual = genesis(Pathbuilder.kyarash());
	print(StringUtils.serializeTable(actual))

	lu.assertNotNil(actual)
	lu.assertNotNil(actual.creature)
	lu.assertNil(actual.creature.error)

	-- GENERAL
	lu.assertEquals("Kyarash", actual.creature.name)
	lu.assertEquals(0, actual.creature.cr)
	lu.assertNil(actual.creature.exp)
	lu.assertEquals("medium", actual.creature.size)
	lu.assertEquals("Chaotic Neutral Medium Ifrit Oracle 5;", actual.creature.tpe)
	lu.assertEquals(11, actual.creature.init)
	lu.assertEquals("Darkvision; Perception: +5", actual.creature.senses)

	-- DEFENSE
	lu.assertEquals(22, actual.creature.ac)
	lu.assertEquals(14, actual.creature.tch)
	lu.assertEquals(18, actual.creature.ff)
	lu.assertEquals("22, touch 14, flat-footed 18", actual.creature.acline)
	lu.assertNil(actual.creature.hd)
	lu.assertEquals(43, actual.creature.hp)
	lu.assertEquals(4, actual.creature.fort)
	lu.assertEquals(7, actual.creature.ref)
	lu.assertEquals(5, actual.creature.will)
	lu.assertEquals("Special Qualities Curse: Tongues; Mystery: Flame; Revelations: Cinder Dance; Gaze of Flames;", actual.creature.sqline)

	-- OFFENSE
	lu.assertEquals("20 ft.", actual.creature.speed);
	lu.assertEquals("Battle aspergillum +9 (1d6+2 ) and Dagger +8 (1d4+1 19-20)", actual.creature.fattack);
	lu.assertEquals("Battle aspergillum +9 (1d6+2 ) or Dagger +8 (1d4+1 19-20)", actual.creature.attack);
	lu.assertEquals("5ft./5ft.", actual.creature.spacereachline);
	lu.assertNil(actual.creature.sa);

	-- Spells
	lu.assertNotNil(actual.creature.spells)
	local oracleSpells = actual.creature.spells['oracle spells known']
	lu.assertNotNil(oracleSpells)
	lu.assertEquals(9, oracleSpells.concentration)
	lu.assertEquals(5, oracleSpells.casterlevel)
	lu.assertEquals(5, TableUtils.tableLength(oracleSpells))
	local levelSpells = oracleSpells['0th (at will)']
	lu.assertNotNil(levelSpells)
	lu.assertEquals(6, #levelSpells)
	lu.assertEquals("detectmagic", levelSpells[1].propername)
	lu.assertEquals(14, levelSpells[1].dc)
	lu.assertEquals("grasp", levelSpells[2].propername)
	lu.assertEquals(14, levelSpells[2].dc)
	lu.assertEquals("guidance", levelSpells[3].propername)
	lu.assertEquals(14, levelSpells[3].dc)
	lu.assertEquals("mending", levelSpells[4].propername)
	lu.assertEquals(14, levelSpells[4].dc)
	lu.assertEquals("spark", levelSpells[5].propername)
	lu.assertEquals(16, levelSpells[5].dc)
	lu.assertEquals("stabilize", levelSpells[6].propername)
	lu.assertEquals(14, levelSpells[6].dc)

	levelSpells = oracleSpells['1st (7/day)']
	lu.assertNotNil(levelSpells)
	lu.assertEquals(6, #levelSpells)
	lu.assertEquals("burninghands", levelSpells[1].propername)
	lu.assertEquals(17, levelSpells[1].dc)
	lu.assertEquals("curelightwounds", levelSpells[2].propername)
	lu.assertEquals(15, levelSpells[2].dc)
	lu.assertEquals("divinefavor", levelSpells[3].propername)
	lu.assertEquals(17, levelSpells[3].dc)
	lu.assertEquals("murderouscommand", levelSpells[4].propername)
	lu.assertEquals(15, levelSpells[4].dc)
	lu.assertEquals("obscuringmist", levelSpells[5].propername)
	lu.assertEquals(15, levelSpells[5].dc)
	lu.assertEquals("unbreakableheart", levelSpells[6].propername)
	lu.assertEquals(15, levelSpells[6].dc)

	levelSpells = oracleSpells['2nd (5/day)']
	lu.assertNotNil(levelSpells)
	lu.assertEquals(4, #levelSpells)
	lu.assertEquals("ashenpath", levelSpells[1].propername)
	lu.assertEquals(16, levelSpells[1].dc)
	lu.assertEquals("curemoderatewounds", levelSpells[2].propername)
	lu.assertEquals(16, levelSpells[2].dc)
	lu.assertEquals("resistenergy", levelSpells[3].propername)
	lu.assertEquals(16, levelSpells[3].dc)
	lu.assertEquals("soundburst", levelSpells[4].propername)
	lu.assertEquals(18, levelSpells[4].dc)

	-- STATISTICS
	lu.assertEquals(13, actual.creature.str)
	lu.assertEquals(20, actual.creature.dex)
	lu.assertEquals(15, actual.creature.con)
	lu.assertEquals(15, actual.creature.int)
	lu.assertEquals(11, actual.creature.wis)
	lu.assertEquals(18, actual.creature.cha)
	lu.assertEquals("Base Atk + +3; CMB +4; CMD 19", actual.creature.babcmd)
	lu.assertEquals("Greater Spell Focus: Evocation; Nimble Moves; Spell Focus: Evocation; Weapon Finesse;", actual.creature.feats)
	lu.assertEquals("Acrobatics +13; Climb +7; Intimidate +12; Perception +5; Perform (a) +9; Sense Motive +8; Spellcraft +10;", actual.creature.skills)
	lu.assertNil(actual.creature.lang)

	-- SPECIAL ABILITIES

	lu.assertNil(actual.creature.specialab)

	-- ECOLOGY
	lu.assertNil(actual.creature.environment)
	lu.assertNil(actual.creature.organization)
	lu.assertNil(actual.creature.gearline)

end

os.exit(lu.LuaUnit.run())
