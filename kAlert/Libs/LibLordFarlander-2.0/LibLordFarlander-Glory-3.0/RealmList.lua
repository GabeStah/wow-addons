
local Glory = LibStub:GetLibrary( "LibLordFarlander-Glory-3.0", true )
if( not Glory ) then return end

if GetCVar("realmList"):match("tw") then
    Glory.BGServerBattleGroup = {
        ["尖石"] = "1",
        ["聖光之願"] = "2",
        ["暗影之月"] = "1",
        ["鬼霧峰"] = "2",
        ["地獄吼"] = "1",
        ["世界之樹"] = "1",
        ["米奈希爾"] = "1",
        ["奧妮克希亞"] = "2",
        ["冰霜之刺"] = "1",
        ["巨龍之喉"] = "1",
        ["寒冰皇冠"] = "2",
        ["暴風祭壇"] = "2",
        ["水晶之刺"] = "1",
        ["冰風崗哨"] = "1",
        ["戰歌"] = "1",
        ["血頂部族"] = "1",
        ["憤怒使者"] = "2",
        ["血之谷"] = "2",
        ["日落沼澤"] = "1",
        ["霜之哀傷"] = "2",
        ["銀翼要塞"] = "2",
        ["屠魔山谷"] = "2",
        ["阿薩斯"] = "2",
        ["天空之牆"] = "1",
        ["語風"] = "2",
        ["眾星之子"] = "2",
        ["雷鱗"] = "1",
        ["狂熱之刃"] = "1",
        ["巴納札爾"] = "1",
        ["夜空之歌"] = "2",
        ["諾姆瑞根"] = "2",
        ["亞雷戈斯"] = "2",
    }
    Glory.BGServerType = {
        ["尖石"] = "PvP",
        ["聖光之願"] = "Normal",
        ["暗影之月"] = "Normal",
        ["鬼霧峰"] = "PvP",
        ["地獄吼"] = "PvP",
        ["世界之樹"] = "Normal",
        ["米奈希爾"] = "PvP",
        ["奧妮克希亞"] = "Normal",
        ["冰霜之刺"] = "PvP",
        ["巨龍之喉"] = "PvP",
        ["寒冰皇冠"] = "PvP",
        ["暴風祭壇"] = "Normal",
        ["水晶之刺"] = "PvP",
        ["冰風崗哨"] = "PvP",
        ["戰歌"] = "PvP",
        ["血頂部族"] = "PvP",
        ["憤怒使者"] = "PvP",
        ["血之谷"] = "PvP",
        ["日落沼澤"] = "PvP",
        ["霜之哀傷"] = "PvP",
        ["銀翼要塞"] = "PvP",
        ["屠魔山谷"] = "PvP",
        ["阿薩斯"] = "PvP",
        ["天空之牆"] = "Normal",
        ["語風"] = "Normal",
        ["眾星之子"] = "Normal",
        ["雷鱗"] = "PvP",
        ["狂熱之刃"] = "PvP",
        ["巴納札爾"] = "Normal",
        ["夜空之歌"] = "PvP",
        ["諾姆瑞根"] = "PvP",
        ["亞雷戈斯"] = "Normal",
    }
    Glory.BGBattleGroups = {
        ["嗜血"] = "1",
        ["暴怒"] = "2",
    }
end
if GetCVar("realmList"):match("eu") then
    Glory.BGBattleGroups = {
        ["Némésis"] = "22",
        ["Todbringer"] = "18",
        ["Blackout"] = "1",
        ["Ruin"] = "9",
        ["Raserei"] = "15",
        ["Blutdurst"] = "12",
        ["Rampage"] = "7",
        ["Crueldad"] = "11",
        ["Férocité"] = "21",
        ["Glutsturm"] = "13",
        ["Misery"] = "5",
        ["Vengeance"] = "24",
        ["Représailles"] = "23",
        ["Conviction"] = "3",
        ["Vindication"] = "10",
        ["Bloodlust"] = "2",
        ["Cataclysme"] = "20",
        ["Verderbnis"] = "19",
        ["Sturmangriff"] = "17",
        ["Schattenbrand"] = "16",
        ["Reckoning"] = "8",
        ["Hinterhalt"] = "14",
        ["Nightfall"] = "6",
        ["Cyclone"] = "4",
    }
    Glory.BGServerBattleGroup = {
        ["Dragonblight"] = "1",
        ["Temple noir"] = "23",
        ["Silvermoon"] = "4",
        ["Hyjal"] = "20",
        ["Darkspear"] = "6",
        ["Tyrande"] = "11",
        ["Terokkar"] = "9",
        ["Bloodhoof"] = "1",
        ["Mug'thol"] = "16",
        ["Karazhan"] = "10",
        ["Frostwolf"] = "12",
        ["Kirin Tor"] = "20",
        ["Echsenkessel"] = "17",
        ["Bronze Dragonflight"] = "6",
        ["Vol'jin"] = "22",
        ["Taerar"] = "16",
        ["Ysondre"] = "24",
        ["Deathwing"] = "2",
        ["Gilneas"] = "19",
        ["The Sha'tar"] = "10",
        ["Thrall"] = "13",
        ["Agamaggan"] = "1",
        ["Twilight's Hammer"] = "1",
        ["Aerie Peak"] = "5",
        ["Dalvengyr"] = "16",
        ["Eldre'Thalas"] = "24",
        ["Quel'Thalas"] = "3",
        ["Chamber of the Aspects"] = "5",
        ["Blackhand"] = "18",
        ["Kil'Jaeden"] = "12",
        ["Destromath"] = "12",
        ["Kult der Verdammten"] = "15",
        ["Burning Steppes"] = "6",
        ["Stormrage"] = "4",
        ["Zul'Jin"] = "11",
        ["Nathrezim"] = "12",
        ["Der Mithrilorden"] = "14",
        ["Eonar"] = "5",
        ["Naxxramas"] = "23",
        ["Marécage de Zangar"] = "23",
        ["Neptulon"] = "7",
        ["Dethecus"] = "14",
        ["Runetotem"] = "4",
        ["Trollbane"] = "8",
        ["Nethersturm"] = "17",
        ["Chants éternels"] = "23",
        ["Uldaman"] = "22",
        ["Stonemaul"] = "5",
        ["Daggerspine"] = "2",
        ["Shadow Moon"] = "4",
        ["Medivh"] = "22",
        ["Boulderfist"] = "5",
        ["Spinebreaker"] = "4",
        ["Sinstralis"] = "20",
        ["Executus"] = "8",
        ["Bloodfeather"] = "7",
        ["Garona"] = "22",
        ["Lordaeron"] = "16",
        ["Dentarg"] = "8",
        ["Confrérie du Thorium"] = "22",
        ["Eitrigg"] = "22",
        ["Dun Modr"] = "11",
        ["Arathor"] = "1",
        ["Theradras"] = "15",
        ["Los Errantes"] = "11",
        ["Azshara"] = "13",
        ["Throk'Feroth"] = "21",
        ["Rashgarroth"] = "21",
        ["Defias Brotherhood"] = "7",
        ["Nozdormu"] = "12",
        ["Dragonmaw"] = "2",
        ["Burning Blade"] = "1",
        ["Les Sentinelles"] = "21",
        ["Khaz Modan"] = "21",
        ["Drek'Thar"] = "21",
        ["Blackrock"] = "13",
        ["Sargeras"] = "20",
        ["Kor'gall"] = "6",
        ["Molten Core"] = "6",
        ["Ner'zhul"] = "20",
        ["Talnivarr"] = "8",
        ["Archimonde"] = "20",
        ["Sylvanas"] = "7",
        ["Baelgun"] = "18",
        ["Kael'thas"] = "20",
        ["Turalyon"] = "4",
        ["Darkmoon Faire"] = "6",
        ["Elune"] = "20",
        ["Kel'Thuzad"] = "12",
        ["Nera'thor"] = "15",
        ["Dalaran"] = "20",
        ["Gul'dan"] = "12",
        ["Cho'gall"] = "20",
        ["Khadgar"] = "8",
        ["Ysera"] = "19",
        ["Mannoroth"] = "12",
        ["Blade's Edge"] = "9",
        ["Lothar"] = "19",
        ["Frostwhisper"] = "7",
        ["Kul Tiras"] = "8",
        ["Doomhammer"] = "1",
        ["Hellfire"] = "10",
        ["Khaz'goroth"] = "19",
        ["Thunderhorn"] = "4",
        ["Kargath"] = "19",
        ["Grim Batol"] = "5",
        ["Malfurion"] = "12",
        ["Terrordar"] = "15",
        ["Malorne"] = "16",
        ["Forscherliga"] = "14",
        ["Todeswache"] = "14",
        ["Nagrand"] = "10",
        ["Minahonda"] = "11",
        ["Festung der Stürme"] = "17",
        ["Die Aldor"] = "17",
        ["Das Konsortium"] = "17",
        ["Blutkessel"] = "17",
        ["Wrathbringer"] = "15",
        ["Terenas"] = "4",
        ["Tirion"] = "16",
        ["Rajaxx"] = "16",
        ["Kilrogg"] = "5",
        ["Ahn'Qiraj"] = "8",
        ["Alonsus"] = "6",
        ["Anachronos"] = "6",
        ["Alexstrasza"] = "18",
        ["Skullcrusher"] = "4",
        ["Die Nachtwache"] = "16",
        ["Der abyssische Rat"] = "16",
        ["The Venture Co."] = "7",
        ["Krasus"] = "24",
        ["Stormreaver"] = "4",
        ["Darksorrow"] = "7",
        ["Lightbringer"] = "6",
        ["Anetheron"] = "13",
        ["Ambossar"] = "16",
        ["Arak-arahm"] = "22",
        ["Drak'thul"] = "8",
        ["Xavius"] = "9",
        ["Ravencrest"] = "4",
        ["Draenor"] = "1",
        ["Alleria"] = "18",
        ["Sen'jin"] = "15",
        ["Arthas"] = "13",
        ["Twisting Nether"] = "7",
        ["Culte de la Rive noire"] = "24",
        ["Krag'jin"] = "15",
        ["Dun Morogh"] = "15",
        ["Der Rat von Dalaran"] = "15",
        ["Perenolde"] = "12",
        ["Aegwynn"] = "12",
        ["Das Syndikat"] = "15",
        ["Teldrassil"] = "14",
        ["Anub'arak"] = "15",
        ["Vashj"] = "7",
        ["Durotan"] = "13",
        ["Aman'Thul"] = "15",
        ["Gorgonnash"] = "12",
        ["Auchindoun"] = "10",
        ["Nazjatar"] = "13",
        ["Balnazzar"] = "3",
        ["Norgannon"] = "14",
        ["Shattrath"] = "17",
        ["Haomarush"] = "7",
        ["Hakkar"] = "9",
        ["C'Thun"] = "11",
        ["Bronzebeard"] = "8",
        ["Tichondrius"] = "13",
        ["Suramar"] = "24",
        ["La Croisade écarlate"] = "22",
        ["Un'Goro"] = "14",
        ["Burning Legion"] = "2",
        ["Die Todeskrallen"] = "13",
        ["Vek'nilash"] = "5",
        ["Eredar"] = "12",
        ["Magtheridon"] = "3",
        ["Die ewige Wacht"] = "13",
        ["Azjol-Nerub"] = "1",
        ["Crushridge"] = "2",
        ["Moonglade"] = "8",
        ["Die Arguswacht"] = "13",
        ["Aggramar"] = "1",
        ["Genjuros"] = "3",
        ["Zirkel des Cenarius"] = "12",
        ["Conseil des Ombres"] = "21",
        ["Shattered Halls"] = "10",
        ["Shadowsong"] = "4",
        ["Vek'lor"] = "16",
        ["Shen'dralar"] = "11",
        ["Zuluhed"] = "12",
        ["Kazzak"] = "5",
        ["Bladefist"] = "1",
        ["Varimathras"] = "21",
        ["Onyxia"] = "15",
        ["Proudmoore"] = "12",
        ["Dunemaul"] = "2",
        ["Frostmourne"] = "12",
        ["Arathi"] = "24",
        ["Tarren Mill"] = "5",
        ["Bloodscalp"] = "1",
        ["Laughing Skull"] = "3",
        ["Rexxar"] = "19",
        ["Antonidas"] = "18",
        ["Scarshield Legion"] = "9",
        ["Frostmane"] = "5",
        ["Madmortem"] = "12",
        ["Earthen Ring"] = "4",
        ["Nordrassil"] = "3",
        ["Malygos"] = "19",
        ["Wildhammer"] = "5",
        ["Die Silberne Hand"] = "12",
        ["The Maelstrom"] = "7",
        ["Aszune"] = "1",
        ["Jaedenar"] = "5",
        ["Les Clairvoyants"] = "23",
        ["Zenedar"] = "1",
        ["Ghostlands"] = "10",
        ["Nefarian"] = "13",
        ["Uldum"] = "11",
        ["Hellscream"] = "3",
        ["Al'Akir"] = "1",
        ["Sporeggar"] = "10",
        ["Ragnaros"] = "7",
        ["Blackmoore"] = "13",
        ["Warsong"] = "1",
        ["Mal'Ganis"] = "12",
        ["Steamwheedle Cartel"] = "9",
        ["Arygos"] = "14",
        ["Argent Dawn"] = "2",
        ["Sunstrider"] = "1",
        ["Outland"] = "5",
        ["Emeriss"] = "8",
        ["Mazrigos"] = "8",
        ["Illidan"] = "20",
        ["Stormscale"] = "4",
        ["Emerald Dream"] = "1",
        ["Ravenholdt"] = "5",
        ["Shattered Hand"] = "4",
        ["Chromaggus"] = "8",
        ["Lightning's Blade"] = "7",
    }
    Glory.BGServerType = {
        ["Dragonblight"] = "Normal",
        ["Temple noir"] = "PvP",
        ["Silvermoon"] = "Normal",
        ["Hyjal"] = "Normal",
        ["Darkspear"] = "Normal",
        ["Tyrande"] = "Normal",
        ["Terokkar"] = "Normal",
        ["Bloodhoof"] = "Normal",
        ["Mug'thol"] = "PvP",
        ["Karazhan"] = "PvP",
        ["Frostwolf"] = "PvP",
        ["Kirin Tor"] = "RP",
        ["Echsenkessel"] = "PvP",
        ["Bronze Dragonflight"] = "Normal",
        ["Vol'jin"] = "Normal",
        ["Taerar"] = "PvP",
        ["Ysondre"] = "PvP",
        ["Deathwing"] = "PvP",
        ["Gilneas"] = "Normal",
        ["The Sha'tar"] = "RP",
        ["Thrall"] = "Normal",
        ["Agamaggan"] = "PvP",
        ["Twilight's Hammer"] = "PvP",
        ["Aerie Peak"] = "Normal",
        ["Dalvengyr"] = "PvP",
        ["Eldre'Thalas"] = "PvP",
        ["Quel'Thalas"] = "Normal",
        ["Chamber of the Aspects"] = "Normal",
        ["Blackhand"] = "Normal",
        ["Kil'Jaeden"] = "PvP",
        ["Destromath"] = "PvP",
        ["Kult der Verdammten"] = "RP-PvP",
        ["Burning Steppes"] = "PvP",
        ["Stormrage"] = "Normal",
        ["Zul'Jin"] = "PvP",
        ["Nathrezim"] = "PvP",
        ["Der Mithrilorden"] = "RP",
        ["Eonar"] = "Normal",
        ["Naxxramas"] = "PvP",
        ["Marécage de Zangar"] = "Normal",
        ["Neptulon"] = "PvP",
        ["Dethecus"] = "PvP",
        ["Runetotem"] = "Normal",
        ["Trollbane"] = "PvP",
        ["Nethersturm"] = "Normal",
        ["Chants éternels"] = "Normal",
        ["Uldaman"] = "Normal",
        ["Stonemaul"] = "PvP",
        ["Daggerspine"] = "PvP",
        ["Shadow Moon"] = "PvP",
        ["Medivh"] = "Normal",
        ["Boulderfist"] = "PvP",
        ["Spinebreaker"] = "PvP",
        ["Sinstralis"] = "PvP",
        ["Executus"] = "PvP",
        ["Bloodfeather"] = "PvP",
        ["Garona"] = "PvP",
        ["Lordaeron"] = "Normal",
        ["Dentarg"] = "PvP",
        ["Confrérie du Thorium"] = "RP",
        ["Eitrigg"] = "Normal",
        ["Dun Modr"] = "PvP",
        ["Arathor"] = "Normal",
        ["Theradras"] = "PvP",
        ["Los Errantes"] = "RP",
        ["Azshara"] = "PvP",
        ["Throk'Feroth"] = "PvP",
        ["Rashgarroth"] = "PvP",
        ["Defias Brotherhood"] = "RP-PvP",
        ["Nozdormu"] = "Normal",
        ["Dragonmaw"] = "PvP",
        ["Burning Blade"] = "PvP",
        ["Les Sentinelles"] = "RP",
        ["Khaz Modan"] = "Normal",
        ["Drek'Thar"] = "Normal",
        ["Blackrock"] = "PvP",
        ["Sargeras"] = "PvP",
        ["Kor'gall"] = "PvP",
        ["Molten Core"] = "PvP",
        ["Ner'zhul"] = "PvP",
        ["Talnivarr"] = "PvP",
        ["Archimonde"] = "PvP",
        ["Sylvanas"] = "PvP",
        ["Baelgun"] = "Normal",
        ["Kael'thas"] = "PvP",
        ["Turalyon"] = "Normal",
        ["Darkmoon Faire"] = "RP",
        ["Elune"] = "Normal",
        ["Kel'Thuzad"] = "PvP",
        ["Nera'thor"] = "PvP",
        ["Dalaran"] = "Normal",
        ["Gul'dan"] = "PvP",
        ["Cho'gall"] = "PvP",
        ["Khadgar"] = "Normal",
        ["Ysera"] = "Normal",
        ["Mannoroth"] = "PvP",
        ["Blade's Edge"] = "Normal",
        ["Lothar"] = "Normal",
        ["Frostwhisper"] = "PvP",
        ["Kul Tiras"] = "Normal",
        ["Doomhammer"] = "Normal",
        ["Hellfire"] = "Normal",
        ["Khaz'goroth"] = "Normal",
        ["Thunderhorn"] = "Normal",
        ["Kargath"] = "Normal",
        ["Grim Batol"] = "PvP",
        ["Malfurion"] = "Normal",
        ["Terrordar"] = "PvP",
        ["Malorne"] = "Normal",
        ["Forscherliga"] = "RP",
        ["Todeswache"] = "RP",
        ["Nagrand"] = "Normal",
        ["Minahonda"] = "Normal",
        ["Festung der Stürme"] = "PvP",
        ["Die Aldor"] = "RP",
        ["Das Konsortium"] = "RP-PvP",
        ["Blutkessel"] = "PvP",
        ["Wrathbringer"] = "PvP",
        ["Terenas"] = "Normal",
        ["Tirion"] = "Normal",
        ["Rajaxx"] = "PvP",
        ["Kilrogg"] = "Normal",
        ["Ahn'Qiraj"] = "PvP",
        ["Alonsus"] = "Normal",
        ["Anachronos"] = "Normal",
        ["Alexstrasza"] = "Normal",
        ["Skullcrusher"] = "PvP",
        ["Die Nachtwache"] = "RP",
        ["Der abyssische Rat"] = "RP-PvP",
        ["The Venture Co."] = "RP-PvP",
        ["Krasus"] = "Normal",
        ["Stormreaver"] = "PvP",
        ["Darksorrow"] = "PvP",
        ["Lightbringer"] = "Normal",
        ["Anetheron"] = "PvP",
        ["Ambossar"] = "Normal",
        ["Arak-arahm"] = "PvP",
        ["Drak'thul"] = "PvP",
        ["Xavius"] = "PvP",
        ["Ravencrest"] = "PvP",
        ["Draenor"] = "Normal",
        ["Alleria"] = "Normal",
        ["Sen'jin"] = "Normal",
        ["Arthas"] = "PvP",
        ["Twisting Nether"] = "PvP",
        ["Culte de la Rive noire"] = "RP-PvP",
        ["Krag'jin"] = "PvP",
        ["Dun Morogh"] = "Normal",
        ["Der Rat von Dalaran"] = "RP",
        ["Perenolde"] = "Normal",
        ["Aegwynn"] = "PvP",
        ["Das Syndikat"] = "RP-PvP",
        ["Teldrassil"] = "Normal",
        ["Anub'arak"] = "PvP",
        ["Vashj"] = "PvP",
        ["Durotan"] = "Normal",
        ["Aman'Thul"] = "Normal",
        ["Gorgonnash"] = "PvP",
        ["Auchindoun"] = "PvP",
        ["Nazjatar"] = "PvP",
        ["Balnazzar"] = "PvP",
        ["Norgannon"] = "Normal",
        ["Shattrath"] = "Normal",
        ["Haomarush"] = "PvP",
        ["Hakkar"] = "PvP",
        ["C'Thun"] = "PvP",
        ["Bronzebeard"] = "Normal",
        ["Tichondrius"] = "PvP",
        ["Suramar"] = "Normal",
        ["La Croisade écarlate"] = "RP-PvP",
        ["Un'Goro"] = "PvP",
        ["Burning Legion"] = "PvP",
        ["Die Todeskrallen"] = "RP-PvP",
        ["Vek'nilash"] = "PvP",
        ["Eredar"] = "PvP",
        ["Magtheridon"] = "PvP",
        ["Die ewige Wacht"] = "RP",
        ["Azjol-Nerub"] = "Normal",
        ["Crushridge"] = "PvP",
        ["Moonglade"] = "RP",
        ["Die Arguswacht"] = "RP-PvP",
        ["Aggramar"] = "Normal",
        ["Genjuros"] = "PvP",
        ["Zirkel des Cenarius"] = "RP",
        ["Conseil des Ombres"] = "RP-PvP",
        ["Shattered Halls"] = "PvP",
        ["Shadowsong"] = "Normal",
        ["Vek'lor"] = "PvP",
        ["Shen'dralar"] = "RP-PvP",
        ["Zuluhed"] = "PvP",
        ["Kazzak"] = "PvP",
        ["Bladefist"] = "PvP",
        ["Varimathras"] = "PvP",
        ["Onyxia"] = "PvP",
        ["Proudmoore"] = "Normal",
        ["Dunemaul"] = "PvP",
        ["Frostmourne"] = "PvP",
        ["Arathi"] = "PvP",
        ["Tarren Mill"] = "PvP",
        ["Bloodscalp"] = "PvP",
        ["Laughing Skull"] = "PvP",
        ["Rexxar"] = "Normal",
        ["Antonidas"] = "Normal",
        ["Scarshield Legion"] = "RP-PvP",
        ["Frostmane"] = "PvP",
        ["Madmortem"] = "Normal",
        ["Earthen Ring"] = "RP",
        ["Nordrassil"] = "Normal",
        ["Malygos"] = "Normal",
        ["Wildhammer"] = "Normal",
        ["Die Silberne Hand"] = "RP",
        ["The Maelstrom"] = "PvP",
        ["Aszune"] = "Normal",
        ["Jaedenar"] = "PvP",
        ["Les Clairvoyants"] = "RP",
        ["Zenedar"] = "PvP",
        ["Ghostlands"] = "Normal",
        ["Nefarian"] = "PvP",
        ["Uldum"] = "PvP",
        ["Hellscream"] = "Normal",
        ["Al'Akir"] = "PvP",
        ["Sporeggar"] = "RP-PvP",
        ["Ragnaros"] = "PvP",
        ["Blackmoore"] = "PvP",
        ["Warsong"] = "PvP",
        ["Mal'Ganis"] = "PvP",
        ["Steamwheedle Cartel"] = "RP",
        ["Arygos"] = "Normal",
        ["Argent Dawn"] = "RP",
        ["Sunstrider"] = "PvP",
        ["Outland"] = "PvP",
        ["Emeriss"] = "PvP",
        ["Mazrigos"] = "PvP",
        ["Illidan"] = "PvP",
        ["Stormscale"] = "PvP",
        ["Emerald Dream"] = "Normal",
        ["Ravenholdt"] = "RP-PvP",
        ["Shattered Hand"] = "PvP",
        ["Chromaggus"] = "PvP",
        ["Lightning's Blade"] = "PvP",
    }
end
if GetCVar("realmList"):match("us") then
    Glory.BGBattleGroups = {
        ["Vengeance"] = "11",
        ["Reckoning"] = "6",
        ["Whirlwind"] = "13",
        ["Vindication"] = "12",
        ["Bloodlust"] = "1",
        ["Retaliation"] = "7",
        ["Ruin"] = "8",
        ["Shadowburn"] = "9",
        ["Emberstorm"] = "3",
        ["Stormstrike"] = "10",
        ["Rampage"] = "5",
        ["Nightfall"] = "4",
        ["Cyclone"] = "2",
    }
    Glory.BGServerBattleGroup = {
        ["Dragonblight"] = "2",
        ["Silvermoon"] = "6",
        ["Akama"] = "11",
        ["Hyjal"] = "13",
        ["Kael'thas"] = "5",
        ["Terokkar"] = "7",
        ["Bloodhoof"] = "8",
        ["Mug'thol"] = "11",
        ["Andorhal"] = "10",
        ["Frostwolf"] = "1",
        ["Kirin Tor"] = "5",
        ["Boulderfist"] = "2",
        ["Feathermoon"] = "2",
        ["Ysondre"] = "10",
        ["Deathwing"] = "4",
        ["Sentinels"] = "4",
        ["Elune"] = "8",
        ["Agamaggan"] = "9",
        ["Aerie Peak"] = "4",
        ["Blackwing Lair"] = "4",
        ["Azgalor"] = "8",
        ["Scarlet Crusade"] = "6",
        ["Kil'Jaeden"] = "1",
        ["Destromath"] = "5",
        ["Exodar"] = "7",
        ["Eonar"] = "12",
        ["Skywall"] = "6",
        ["Madoran"] = "8",
        ["Dethecus"] = "5",
        ["Thaurissan"] = "1",
        ["Trollbane"] = "8",
        ["Stonemaul"] = "2",
        ["Daggerspine"] = "2",
        ["Kargath"] = "12",
        ["Vashj"] = "13",
        ["Spinebreaker"] = "5",
        ["Nazgrel"] = "3",
        ["Executus"] = "10",
        ["Nazjatar"] = "9",
        ["The Forgotten Coast"] = "13",
        ["Anvilmar"] = "4",
        ["Dentarg"] = "10",
        ["Shu'halo"] = "13",
        ["Ravenholdt"] = "13",
        ["Misha"] = "13",
        ["Arathor"] = "6",
        ["Malfurion"] = "9",
        ["Lightbringer"] = "13",
        ["Lightninghoof"] = "9",
        ["Korialstrasz"] = "13",
        ["Fenris"] = "13",
        ["Echo Isles"] = "13",
        ["Blade's Edge"] = "7",
        ["Dragonmaw"] = "6",
        ["Burning Blade"] = "12",
        ["Gnomeregan"] = "4",
        ["Cenarius"] = "13",
        ["Cenarion Circle"] = "13",
        ["Moon Guard"] = "3",
        ["Blackwater Raiders"] = "13",
        ["Cho'gall"] = "5",
        ["Norgannon"] = "10",
        ["Anub'arak"] = "13",
        ["Altar of Storms"] = "4",
        ["Windrunner"] = "6",
        ["Thunderlord"] = "12",
        ["Baelgun"] = "9",
        ["Aggramar"] = "12",
        ["Area 52"] = "7",
        ["Shadow Moon"] = "12",
        ["Malygos"] = "12",
        ["Kel'Thuzad"] = "4",
        ["Stormreaver"] = "5",
        ["Lightning's Blade"] = "12",
        ["Gul'dan"] = "5",
        ["Laughing Skull"] = "12",
        ["Khadgar"] = "10",
        ["Stormrage"] = "8",
        ["Gilneas"] = "12",
        ["Maelstrom"] = "9",
        ["Earthen Ring"] = "12",
        ["Hakkar"] = "11",
        ["Kul Tiras"] = "11",
        ["Doomhammer"] = "4",
        ["Medivh"] = "8",
        ["Durotan"] = "8",
        ["Thunderhorn"] = "12",
        ["Thorium Brotherhood"] = "11",
        ["Runetotem"] = "11",
        ["Nordrassil"] = "3",
        ["Muradin"] = "11",
        ["Barthilas"] = "1",
        ["Dark Iron"] = "9",
        ["Aman'Thul"] = "1",
        ["Nagrand"] = "1",
        ["The Venture Co"] = "4",
        ["Malorne"] = "11",
        ["Korgath"] = "11",
        ["Bleeding Hollow"] = "8",
        ["Khaz Modan"] = "11",
        ["Coilfang"] = "7",
        ["Jubei'Thos"] = "11",
        ["Garithos"] = "11",
        ["Spirestone"] = "6",
        ["Blackrock"] = "1",
        ["Velen"] = "7",
        ["Khaz'goroth"] = "1",
        ["The Underbog"] = "7",
        ["Alexstrasza"] = "5",
        ["Sen'Jin"] = "1",
        ["Eitrigg"] = "11",
        ["Draka"] = "11",
        ["Gorefiend"] = "12",
        ["Sisters of Elune"] = "13",
        ["Lothar"] = "8",
        ["Shadowsong"] = "6",
        ["Tanaris"] = "4",
        ["Anetheron"] = "10",
        ["Dawnbringer"] = "7",
        ["Undermine"] = "4",
        ["Drak'thul"] = "11",
        ["Garona"] = "5",
        ["Ravencrest"] = "5",
        ["Draenor"] = "2",
        ["Alleria"] = "5",
        ["Kalecgos"] = "9",
        ["Ysera"] = "10",
        ["Hydraxis"] = "3",
        ["Bronzebeard"] = "2",
        ["Thrall"] = "10",
        ["Steamwheedle Cartel"] = "10",
        ["Scilla"] = "10",
        ["Perenolde"] = "2",
        ["Aegwynn"] = "11",
        ["Archimonde"] = "10",
        ["The Scryers"] = "7",
        ["Lethon"] = "4",
        ["Llane"] = "12",
        ["Eldre'Thalas"] = "6",
        ["Dalvengyr"] = "10",
        ["Gorgonnash"] = "5",
        ["Terenas"] = "6",
        ["Dalaran"] = "10",
        ["Balnazzar"] = "5",
        ["Drenden"] = "3",
        ["Smolderthorn"] = "6",
        ["Haomarush"] = "10",
        ["Farstriders"] = "3",
        ["Ursin"] = "9",
        ["Uldum"] = "2",
        ["Twisting Nether"] = "9",
        ["Suramar"] = "2",
        ["Staghelm"] = "9",
        ["Sargeras"] = "9",
        ["Burning Legion"] = "12",
        ["Maiev"] = "13",
        ["Vek'nilash"] = "1",
        ["Eredar"] = "12",
        ["Magtheridon"] = "8",
        ["Tichondrius"] = "1",
        ["Azjol-Nerub"] = "2",
        ["Crushridge"] = "2",
        ["Nathrezim"] = "6",
        ["Emerald Dream"] = "9",
        ["Demon Soul"] = "4",
        ["Detheroc"] = "9",
        ["Azshara"] = "9",
        ["Zul'jin"] = "8",
        ["Shattered Halls"] = "7",
        ["Shandris"] = "3",
        ["Gurubashi"] = "6",
        ["Warsong"] = "8",
        ["Zuluhed"] = "10",
        ["Azuremyst"] = "7",
        ["Bladefist"] = "13",
        ["Skullcrusher"] = "8",
        ["Onyxia"] = "4",
        ["Shattered Hand"] = "8",
        ["Dunemaul"] = "2",
        ["Frostmourne"] = "1",
        ["Black Dragonflight"] = "10",
        ["Arthas"] = "8",
        ["Bloodscalp"] = "2",
        ["Stormscale"] = "2",
        ["Rexxar"] = "11",
        ["Antonidas"] = "3",
        ["Silver Hand"] = "1",
        ["Frostmane"] = "6",
        ["Shadow Council"] = "6",
        ["Kilrogg"] = "1",
        ["Alterac Mountains"] = "4",
        ["Icecrown"] = "4",
        ["Wildhammer"] = "9",
        ["Darkspear"] = "2",
        ["Mannoroth"] = "8",
        ["Duskwood"] = "10",
        ["Jaedenar"] = "4",
        ["Uther"] = "13",
        ["Uldaman"] = "4",
        ["Moonrunner"] = "9",
        ["Zangarmarsh"] = "7",
        ["Blood Furnace"] = "7",
        ["Hellscream"] = "5",
        ["Argent Dawn"] = "8",
        ["Tortheldrin"] = "3",
        ["Blackhand"] = "5",
        ["Whisperwind"] = "5",
        ["Rivendare"] = "3",
        ["Mal'Ganis"] = "10",
        ["Firetree"] = "6",
        ["Arygos"] = "4",
        ["Darrowmere"] = "13",
        ["Turalyon"] = "10",
        ["Bonechewer"] = "6",
        ["Mok'Nathal"] = "3",
        ["Auchindoun"] = "7",
        ["Illidan"] = "5",
        ["Dath'Remar"] = "1",
        ["Ner'zhul"] = "1",
        ["Greymane"] = "9",
        ["Proudmoore"] = "1",
        ["Chromaggus"] = "11",
        ["Quel'dorei"] = "3",
    }
    Glory.BGServerType = {
        ["Dragonblight"] = "Normal",
        ["Silvermoon"] = "Normal",
        ["Akama"] = "PvP",
        ["Hyjal"] = "Normal",
        ["Kael'thas"] = "Normal",
        ["Terokkar"] = "Normal",
        ["Bloodhoof"] = "Normal",
        ["Mug'thol"] = "PvP",
        ["Andorhal"] = "PvP",
        ["Frostwolf"] = "PvP",
        ["Kirin Tor"] = "RP",
        ["Boulderfist"] = "PvP",
        ["Feathermoon"] = "RP",
        ["Ysondre"] = "PvP",
        ["Deathwing"] = "PvP",
        ["Sentinels"] = "RP",
        ["Elune"] = "Normal",
        ["Agamaggan"] = "PvP",
        ["Aerie Peak"] = "Normal",
        ["Blackwing Lair"] = "PvP",
        ["Azgalor"] = "PvP",
        ["Scarlet Crusade"] = "RP",
        ["Kil'Jaeden"] = "PvP",
        ["Destromath"] = "PvP",
        ["Exodar"] = "Normal",
        ["Eonar"] = "Normal",
        ["Skywall"] = "Normal",
        ["Madoran"] = "Normal",
        ["Dethecus"] = "PvP",
        ["Thaurissan"] = "PvP",
        ["Trollbane"] = "Normal",
        ["Stonemaul"] = "PvP",
        ["Daggerspine"] = "PvP",
        ["Kargath"] = "Normal",
        ["Vashj"] = "PvP",
        ["Spinebreaker"] = "PvP",
        ["Nazgrel"] = "Normal",
        ["Executus"] = "PvP",
        ["Nazjatar"] = "PvP",
        ["The Forgotten Coast"] = "PvP",
        ["Anvilmar"] = "Normal",
        ["Dentarg"] = "PvP",
        ["Shu'halo"] = "Normal",
        ["Ravenholdt"] = "RP-PvP",
        ["Misha"] = "Normal",
        ["Arathor"] = "Normal",
        ["Malfurion"] = "Normal",
        ["Lightbringer"] = "Normal",
        ["Lightninghoof"] = "RP-PvP",
        ["Korialstrasz"] = "Normal",
        ["Fenris"] = "Normal",
        ["Echo Isles"] = "Normal",
        ["Blade's Edge"] = "Normal",
        ["Dragonmaw"] = "PvP",
        ["Burning Blade"] = "PvP",
        ["Gnomeregan"] = "Normal",
        ["Cenarius"] = "Normal",
        ["Cenarion Circle"] = "RP",
        ["Moon Guard"] = "RP",
        ["Blackwater Raiders"] = "RP",
        ["Cho'gall"] = "PvP",
        ["Norgannon"] = "Normal",
        ["Anub'arak"] = "PvP",
        ["Altar of Storms"] = "PvP",
        ["Windrunner"] = "Normal",
        ["Thunderlord"] = "PvP",
        ["Baelgun"] = "Normal",
        ["Aggramar"] = "Normal",
        ["Area 52"] = "Normal",
        ["Shadow Moon"] = "PvP",
        ["Malygos"] = "Normal",
        ["Kel'Thuzad"] = "PvP",
        ["Stormreaver"] = "PvP",
        ["Lightning's Blade"] = "PvP",
        ["Gul'dan"] = "PvP",
        ["Laughing Skull"] = "PvP",
        ["Khadgar"] = "Normal",
        ["Stormrage"] = "Normal",
        ["Gilneas"] = "Normal",
        ["Maelstrom"] = "RP-PvP",
        ["Earthen Ring"] = "RP",
        ["Hakkar"] = "PvP",
        ["Kul Tiras"] = "Normal",
        ["Doomhammer"] = "Normal",
        ["Medivh"] = "Normal",
        ["Durotan"] = "Normal",
        ["Thunderhorn"] = "Normal",
        ["Thorium Brotherhood"] = "RP",
        ["Runetotem"] = "Normal",
        ["Nordrassil"] = "Normal",
        ["Muradin"] = "Normal",
        ["Barthilas"] = "PvP",
        ["Dark Iron"] = "PvP",
        ["Aman'Thul"] = "Normal",
        ["Nagrand"] = "Normal",
        ["The Venture Co"] = "RP-PvP",
        ["Malorne"] = "PvP",
        ["Korgath"] = "PvP",
        ["Bleeding Hollow"] = "PvP",
        ["Khaz Modan"] = "Normal",
        ["Coilfang"] = "PvP",
        ["Jubei'Thos"] = "PvP",
        ["Garithos"] = "PvP",
        ["Spirestone"] = "PvP",
        ["Blackrock"] = "PvP",
        ["Velen"] = "Normal",
        ["Khaz'goroth"] = "Normal",
        ["The Underbog"] = "PvP",
        ["Alexstrasza"] = "Normal",
        ["Sen'Jin"] = "Normal",
        ["Eitrigg"] = "Normal",
        ["Draka"] = "Normal",
        ["Gorefiend"] = "PvP",
        ["Sisters of Elune"] = "RP",
        ["Lothar"] = "Normal",
        ["Shadowsong"] = "Normal",
        ["Tanaris"] = "Normal",
        ["Anetheron"] = "PvP",
        ["Dawnbringer"] = "Normal",
        ["Undermine"] = "Normal",
        ["Drak'thul"] = "PvP",
        ["Garona"] = "Normal",
        ["Ravencrest"] = "Normal",
        ["Draenor"] = "Normal",
        ["Alleria"] = "Normal",
        ["Kalecgos"] = "PvP",
        ["Ysera"] = "Normal",
        ["Hydraxis"] = "Normal",
        ["Bronzebeard"] = "Normal",
        ["Thrall"] = "Normal",
        ["Steamwheedle Cartel"] = "RP",
        ["Scilla"] = "PvP",
        ["Perenolde"] = "Normal",
        ["Aegwynn"] = "PvP",
        ["Archimonde"] = "PvP",
        ["The Scryers"] = "Normal",
        ["Lethon"] = "PvP",
        ["Llane"] = "Normal",
        ["Eldre'Thalas"] = "Normal",
        ["Dalvengyr"] = "PvP",
        ["Gorgonnash"] = "PvP",
        ["Terenas"] = "Normal",
        ["Dalaran"] = "Normal",
        ["Balnazzar"] = "PvP",
        ["Drenden"] = "Normal",
        ["Smolderthorn"] = "PvP",
        ["Haomarush"] = "PvP",
        ["Farstriders"] = "RP",
        ["Ursin"] = "PvP",
        ["Uldum"] = "Normal",
        ["Twisting Nether"] = "RP-PvP",
        ["Suramar"] = "Normal",
        ["Staghelm"] = "Normal",
        ["Sargeras"] = "PvP",
        ["Burning Legion"] = "PvP",
        ["Maiev"] = "PvP",
        ["Vek'nilash"] = "Normal",
        ["Eredar"] = "PvP",
        ["Magtheridon"] = "PvP",
        ["Tichondrius"] = "PvP",
        ["Azjol-Nerub"] = "Normal",
        ["Crushridge"] = "PvP",
        ["Nathrezim"] = "PvP",
        ["Emerald Dream"] = "RP-PvP",
        ["Demon Soul"] = "PvP",
        ["Detheroc"] = "PvP",
        ["Azshara"] = "PvP",
        ["Zul'jin"] = "Normal",
        ["Shattered Halls"] = "PvP",
        ["Shandris"] = "Normal",
        ["Gurubashi"] = "PvP",
        ["Warsong"] = "PvP",
        ["Zuluhed"] = "PvP",
        ["Azuremyst"] = "Normal",
        ["Bladefist"] = "Normal",
        ["Skullcrusher"] = "PvP",
        ["Onyxia"] = "PvP",
        ["Shattered Hand"] = "PvP",
        ["Dunemaul"] = "PvP",
        ["Frostmourne"] = "PvP",
        ["Black Dragonflight"] = "PvP",
        ["Arthas"] = "PvP",
        ["Bloodscalp"] = "PvP",
        ["Stormscale"] = "PvP",
        ["Rexxar"] = "Normal",
        ["Antonidas"] = "Normal",
        ["Silver Hand"] = "RP",
        ["Frostmane"] = "PvP",
        ["Shadow Council"] = "RP",
        ["Kilrogg"] = "Normal",
        ["Alterac Mountains"] = "PvP",
        ["Icecrown"] = "Normal",
        ["Wildhammer"] = "PvP",
        ["Darkspear"] = "PvP",
        ["Mannoroth"] = "PvP",
        ["Duskwood"] = "Normal",
        ["Jaedenar"] = "PvP",
        ["Uther"] = "Normal",
        ["Uldaman"] = "Normal",
        ["Moonrunner"] = "Normal",
        ["Zangarmarsh"] = "Normal",
        ["Blood Furnace"] = "PvP",
        ["Hellscream"] = "Normal",
        ["Argent Dawn"] = "RP",
        ["Tortheldrin"] = "PvP",
        ["Blackhand"] = "Normal",
        ["Whisperwind"] = "Normal",
        ["Rivendare"] = "PvP",
        ["Mal'Ganis"] = "PvP",
        ["Firetree"] = "PvP",
        ["Arygos"] = "Normal",
        ["Darrowmere"] = "PvP",
        ["Turalyon"] = "Normal",
        ["Bonechewer"] = "PvP",
        ["Mok'Nathal"] = "Normal",
        ["Auchindoun"] = "PvP",
        ["Illidan"] = "PvP",
        ["Dath'Remar"] = "Normal",
        ["Ner'zhul"] = "PvP",
        ["Greymane"] = "Normal",
        ["Proudmoore"] = "Normal",
        ["Chromaggus"] = "PvP",
        ["Quel'dorei"] = "Normal",
    }
end
if GetCVar("realmList"):match("ko") then
    Glory.BGServerBattleGroup = {
        ["렉사르"] = "3",
        ["카라잔"] = "3",
        ["알라르"] = "2",
        ["달라란"] = "1",
        ["굴단"] = "2",
        ["알레리아"] = "2",
        ["세나리우스"] = "3",
        ["우서"] = "1",
        ["아즈샤라"] = "2",
        ["엘룬"] = "3",
        ["메카나르"] = "4",
        ["신록의 정원"] = "4",
        ["레인"] = "3",
        ["알렉스트라자"] = "1",
        ["알카트라즈"] = "4",
        ["메디브"] = "2",
        ["하이잘"] = "3",
        ["데스윙"] = "3",
        ["이오나"] = "3",
        ["윈드러너"] = "2",
        ["헬스크림"] = "1",
        ["스톰레이지"] = "3",
        ["폭풍우 요새"] = "4",
        ["말리고스"] = "2",
        ["블랙무어"] = "3",
        ["가로나"] = "1",
        ["말퓨리온"] = "1",
        ["라그나로스"] = "1",
        ["쿨 티라스"] = "3",
        ["티리온"] = "1",
        ["불타는 군단"] = "1",
        ["줄진"] = "3",
        ["와일드해머"] = "3",
        ["노르간논"] = "2",
        ["에이그윈"] = "2",
        ["카르가스"] = "1",
        ["듀로탄"] = "2",
    }
    Glory.BGServerType = {
        ["렉사르"] = "Normal",
        ["카라잔"] = "PvP",
        ["알라르"] = "PvP",
        ["달라란"] = "PvP",
        ["굴단"] = "PvP",
        ["알레리아"] = "PvP",
        ["세나리우스"] = "PvP",
        ["우서"] = "PvP",
        ["아즈샤라"] = "PvP",
        ["엘룬"] = "PvP",
        ["메카나르"] = "PvP",
        ["신록의 정원"] = "PvP",
        ["레인"] = "PvP",
        ["알렉스트라자"] = "PvP",
        ["알카트라즈"] = "PvP",
        ["메디브"] = "PvP",
        ["하이잘"] = "PvP",
        ["데스윙"] = "PvP",
        ["이오나"] = "PvP",
        ["윈드러너"] = "Normal",
        ["헬스크림"] = "PvP",
        ["스톰레이지"] = "Normal",
        ["폭풍우 요새"] = "PvP",
        ["말리고스"] = "PvP",
        ["블랙무어"] = "PvP",
        ["가로나"] = "PvP",
        ["말퓨리온"] = "PvP",
        ["라그나로스"] = "PvP",
        ["쿨 티라스"] = "PvP",
        ["티리온"] = "PvP",
        ["불타는 군단"] = "Normal",
        ["줄진"] = "PvP",
        ["와일드해머"] = "Normal",
        ["노르간논"] = "PvP",
        ["에이그윈"] = "PvP",
        ["카르가스"] = "PvP",
        ["듀로탄"] = "PvP",
    }
    Glory.BGBattleGroups = {
        ["야성의 전장"] = "3",
        ["격노의 전장"] = "1",
        ["징벌의 전장"] = "2",
    }
end

if( not Glory.BGServerBattleGroup ) then
    Glory.BGServerBattleGroup = {}
    Glory.BGServerType = {}
    Glory.BGBattleGroups = {}
end

