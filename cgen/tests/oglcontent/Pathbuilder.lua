--[[
OPEN GAME LICENSE Version 1.0a (see LICENSE file)

Section 15: Copyright Notice

Character copyright 2022, Amadeus
]] --
local Pathbuilder = {}

--[[
Created by Pathbuilder https://play.google.com/store/apps/details?id=com.redrazors.pathbuilder&hl=en&gl=US
Pathbuilder generates player characters - but it makes sense to use it to create NPCs with class levels as well.
In that case things like the challenge rating are not found in the statblock but it should still be parsable.

Fantasy Grounds creates HTML tags and HTML entities automatically when pasting content into it's text boxes.
]] --
function Pathbuilder:kyarash()
	return [[
<p>KYARASH</p><p>Chaotic Neutral Medium Ifrit Oracle 5;</p><p>Init 11; Senses Darkvision; Perception: +5</p><p>DEFENSE</p><p>AC 22, touch 14, flat-footed 18</p><p>Hp 43</p><p>Fort 4, Ref 7, Will 5</p><p>OFFENSE</p><p>Speed 20 ft.</p><p>Melee Battle aspergillum +9 (1d6+2 ), Dagger +8 (1d4+1 19-20),</p><p>Oracle spells known (CL 5; concentration +9)</p><p>2nd (5/day)- Ashen Path (DC 16); Cure Moderate Wounds (DC 16); Resist Energy (DC 16); Sound Burst (DC 18);</p><p></p><p>1st (7/day)- Burning Hands (DC 17); Cure Light Wounds (DC 15); Divine Favor (DC 17); Murderous Command (DC 15); Obscuring Mist (DC 15); Unbreakable Heart (DC 15);</p><p></p><p>0th (at will)- Detect Magic (DC 14); Grasp (DC 14); Guidance (DC 14); Mending (DC 14); Spark (DC 16); Stabilize (DC 14);</p><p>STATISTICS</p><p>Str 13, Dex 20, Con 15, Int 15, Wis 11, Cha 18</p><p>Base Atk + +3; CMB +4; CMD 19</p><p>Feats Greater Spell Focus: Evocation; Nimble Moves; Spell Focus: Evocation; Weapon Finesse;</p><p>SQ Curse: Tongues; Mystery: Flame; Revelations: Cinder Dance; Gaze of Flames;</p><p>Skills Acrobatics +13; Climb +7; Intimidate +12; Perception +5; Perform (a) +9; Sense Motive +8; Spellcraft +10;</p><p>Equipment Belt of incredible dexterity +2; Cloak of resistance +1;</p>
]]
end

return Pathbuilder
