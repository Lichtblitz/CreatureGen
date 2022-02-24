--[[
OPEN GAME LICENSE Version 1.0a (see LICENSE file)

Section 15: Copyright Notice

Pathfinder Campaign Setting: Mythical Monsters Revisited © 2012, Paizo Publishing, LLC; Authors: Jesse Benner, Jonathan H. Keith, Michael Kenway, Jason Nelson, Anthony Pryor, and Greg A. Vaughan.
]] --
local D20pfsrdDOTcom = {}

--[[
Taken from https://www.d20pfsrd.com/bestiary/monster-listings/magical-beasts/kraken/

Fantasy Grounds creates HTML tags and HTML entities automatically when pasting content into it's text boxes.
]] --
function D20pfsrdDOTcom:kraken()
	return [[
<p /><p /><p>Kraken CR 18</p><p /><p>XP 153,600</p><p>NE Gargantuan magical beast (aquatic)</p><p>Init +4; Senses darkvision 120 ft., low-light vision; Perception +28</p><p /><p>DEFENSE</p><p /><p>AC 32, touch 6, flat-footed 32 (+26 natural, -4 size)</p><p>hp 290 (20d10+180)</p><p>Fort +21, Ref +12, Will +11</p><p>Immune cold, mind-affecting effects, poison</p><p /><p>OFFENSE</p><p /><p>Speed 10 ft., swim 40 ft., jet 280 ft.</p><p>Melee 2 arms +26 (2d6+10/19&#8211;20 plus grab), 8 tentacles +24 (1d8+5 plus grab), bite +26 (2d8+10)</p><p>Space 20 ft.; Reach 20 ft. (60 ft. with arm, 40 ft. with tentacle)</p><p>Special Attacks constrict (tentacles, 1d8+10), ink cloud, rend ship</p><p>Spell-Like Abilities (CL 15th)</p><p>1/day&#8212; control weather, control winds, dominate monster (DC 24, animal only), resist energy</p><p /><p>STATISTICS</p><p /><p>Str 30, Dex 10, Con 29, Int 21, Wis 20, Cha 21</p><p>Base Atk +20; CMB +34 (+38 grappling); CMD 44 (can&#8217;t be tripped)</p><p>Feats Bleeding Critical, Blind-Fight, Cleave, Combat Expertise, Critical Focus, Improved Critical (arm), Improved Initiative, Improved Trip, Multiattack, Power Attack</p><p>Skills Intimidate +25, Knowledge (geography) +25, Knowledge (nature) +25, Perception +28, Stealth +11, Swim +41, Use Magic Device +25</p><p>Languages Aquan, Common</p><p>SQ tenacious grapple</p><p /><p>SPECIAL ABILITIES</p><p>Ink Cloud (Ex)</p><p /><p>A kraken can emit a cloud of black, venomous ink in an 80-foot spread once per minute as a free action while underwater. This cloud provides total concealment, which the kraken can use to escape a fight that is going badly. Creatures within the cloud are considered to be in darkness. In addition, the ink is toxic, functioning as contact poison against all creatures caught within it. The ink cloud persists for 1 minute before dispersing. The save DC against the poison effect is Constitution-based.</p><p /><p>Kraken Ink: Ink cloud&#8212;contact; save Fort DC 29; frequency 1/round for 10 rounds; effect 1 Str damage plus nausea; cure 2 consecutive saves.</p><p>Jet (Ex)</p><p /><p>A kraken can jet backward as a full-round action, at a speed of 280 feet. It must move in a straight line, but does not provoke attacks of opportunity while jetting.</p><p>Rend Ship (Ex)</p><p /><p>As a full-round action, a kraken can attempt to use four of its tentacles to grapple a ship of its size or smaller. It makes a CMB check opposed by the ship&#8217;s captain&#8217;s Profession (sailor) check, but the kraken gets a cumulative +4 bonus on the check for each size category smaller than Gargantuan the ship is. If the kraken grapples the ship, it holds the ship motionless; it can attack targets anywhere on or within the ship with its tentacles, but can only attack foes on deck with its free arms and can&#8217;t attack foes at all with its beak. Each round it maintains its hold on the ship, it automatically inflicts bite damage on the ship&#8217;s hull.</p><p>Tenacious Grapple (Ex)</p><p /><p>A kraken does not gain the grappled condition if it grapples a foe with its arms or tentacles.</p><p /><p>ECOLOGY</p><p /><p>Environment any ocean</p><p>Organization solitary</p><p>Treasure triple </p>
]]
end

return D20pfsrdDOTcom
