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
function Pathbuilder:humanbard()
	return [[
<p>Some Human Bard</p><p>MONSTER</p><p>Neutral Medium Human Bard 12;</p><p>Init 1; Senses Perception: +14</p><p>DEFENSE</p><p>AC 22, touch 13, flat-footed 21</p><p>hp 109</p><p>Fort 11, Ref 13, Will 11</p><p>OFFENSE</p><p>Speed 30 ft.</p><p>Bard spells known (CL 12; concentration +24)</p><p>4th (5/day)- Dominate Person (DC 24); Hold Monster (DC 24); Invisibility, Greater (DC 22); Wall of Blindness/Deafness (DC 22);</p><p>3rd (6/day)- Confusion (DC 23); Dispel Magic (DC 21); Displacement (DC 21); Fear (DC 21); Haste (DC 21); Purging Finale (DC 21);</p><p>2nd (7/day)- Blistering Invective (DC 20); Distracting Cacophony (DC 20); Heroism (DC 22); Invisibility (DC 20); Mirror Image (DC 20);</p><p>1st (7/day)- Alarm (DC 19); Charm Person (DC 21); Disguise Self (DC 19); Ear-Piercing Scream (DC 19); Grease (DC 19); Hideous Laughter (DC 21);</p><p>STATISTICS</p><p>Str 10, Dex 13, Con 16, Int 14, Wis 8, Cha 26</p><p>Base Atk + +9; CMB +9; CMD 22</p><p>Feats Combat Casting; Dazzling Display; Greater Spell Focus: Enchantment; Lingering Performance; Skill Focus: Perform (a); Skill Focus: Perform (b); Spell Focus: Enchantment; Weapon Focus: Melee Touch Attack;</p><p>SQ Countersong; Distraction; Fascinate; Glorious Epic; Heraldic Expertise; Inspire Greatness; Mockery; Satire; Soothing Performance; Suggestion; Well-Versed; Wide Audience; Versatile Performances: Comedy (Bluff, Intimidate); Dance (Acrobatics, Fly); Expanded Versatility; Expanded Versatility: Sense Motive;</p><p>Skills Diplomacy +29; Knowledge (arcana) +6; Knowledge (dungeoneering) +6; Knowledge (engineering) +6; Knowledge (geography) +6; Knowledge (history) +12; Knowledge (local) +23; Knowledge (nature) +6; Knowledge (nobility) +23; Knowledge (planes) +6; Knowledge (religion) +10; Perception +14; Perform (a) +29; Perform (b) +29; Spellcraft +17; Use Magic Device +23;</p><p>Equipment Amulet of natural armor +2; Belt of mighty constitution +4; Cloak of resistance +4; Headband of alluring charisma +6; Persistent Metamagic Rod; Ring of Protection +2;</p>
]]
end


return Pathbuilder
