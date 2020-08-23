--[[
    Database of all minipets and mounts
    $Revision: 202 $
]]--

--[[
Copyright (c) 2008-2010, LordFarlander
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]--

if( not LibStub( "LibPeriodicTable-3.1", true ) ) then
    error( "PT3 must be loaded before data" );
end--if
    LibStub( "LibPeriodicTable-3.1" ):AddData( "PetAndMountDatabase", tostring( tonumber( ("$Rev: 202 $"):match( "%d+" ) ) + 90000 ), {
        ["PetAndMountDatabase.Spells.Travel.Ground.Shaman"] = "-2645",
        ["PetAndMountDatabase.Mounts.Flying.Fast"] = "33176:160|0|250|1|R225,-44153:160|0|250|1|R225;E350,-61451:160|0|250|1|R225;T410,-32235:160|0|250|1|R225,-32243:160|0|250|1|R225,-32244:160|0|250|1|R225,-32245:160|0|250|1|R225,44229:160|0|250|1,-46197:160|0|250|1|R225,44221:160|0|250|1,-32239:160|0|250|1|R225,-32240:160|0|250|1|R225",
        ["PetAndMountDatabase.Mounts.Underwater.VeryFast"] = "-75207:100|380|0|1|R300",
        ["PetAndMountDatabase.Spells.Travel.Aquatic.Druid"] = "-1066",
        ["PetAndMountDatabase.Mounts.Ground.Fast"] = "-17453:160|100|0|1|R75,-34795:160|100|0|1|R75,-6653:160|100|0|1|R75,-64977:160|100|0|1|R75,-17454:160|100|0|1|R75,-17462:160|100|0|1|R75,-35020:160|100|0|1|R75,-43899:160|100|0|1|R75,-6777:160|100|0|1|R75,-17463:160|100|0|1|R75,-69820:200|100|0|1|R75,-35022:160|100|0|1|R75,-6899:160|100|0|1|R75,-18989:160|100|0|1|R75,-17464:160|100|0|1|R75,-10796:160|100|0|1|R75,-35711:160|100|0|1|R75,-34769:160|100|0|1|R75,-18990:160|100|0|1|R75,-73629:160|100|0|1|R75,-6648:160|100|0|1|R75,-6654:160|100|0|1|R75,-13819:160|100|0|1|R75,-10793:160|100|0|1|R75,-34406:160|100|0|1|R75,-10969:160|100|0|1|R75,-5784:160|100|0|1|R75,-10873:160|100|0|1|R75,-8395:160|100|0|1|R75,-64657:160|100|0|1|R75,-580:160|100|0|1|R75,-472:160|100|0|1|R75,-470:160|100|0|1|R75,33183:160|100|0|1|R75,-35018:160|100|0|1|R75,-6898:160|100|0|1|R75,-42776:160|100|0|1|R75,-64658:160|100|0|1|R75,-8394:160|100|0|1|R75,-10789:160|100|0|1|R75,-35710:160|100|0|1|R75,8628:160|100|0|1,-10799:160|100|0|1|R75,-458:160|100|0|1|R75,-66847:160|100|0|1|R75",
        ["PetAndMountDatabase.Critters.Reagented.Snowball"] = "-26533:17202,-26541:17202,-26529:17202,-26045:17202",
        ["PetAndMountDatabase.Spells.Teleport.Home"] = "-54318,-70195,-75136,-11365,-39937,-54401,-8690",
        ["PetAndMountDatabase.Mounts.Flying.VeryFast"] = "-32296:200|0|380|1|R300,-59961:200|0|380|1|R300,-60025:200|0|380|1|R300,33182:200|0|380|1|R300,-75596:200|0|380|1|R225;T425,-32289:200|0|380|1|R300,-32297:200|0|380|1|R300,-63844:200|0|380|1|R300,-59996:200|0|380|1|R300,-32242:200|0|380|1|R300,-32290:200|0|380|1|R300,-59567:200|0|380|1|R300,-39798:200|0|380|1|R300,-66087:200|0|380|1|R300,-59568:200|0|380|1|R300,-61229:200|0|380|1|R300,-61309:200|0|380|1|R300;T425,-61996:200|0|380|1|R300,-59569:200|0|380|1|R300,-61230:200|0|380|1|R300,-39800:200|0|380|1|R300,-61294:200|0|380|1|R300,-32292:200|0|380|1|R300,-61997:200|0|380|1|R300,-59570:200|0|380|1|R300,-59650:200|0|380|1|R300,-60002:200|0|380|1|R300,-59571:200|0|380|1|R300,-39802:200|0|380|1|R300,-39803:200|0|380|1|R300,-39801:200|0|380|1|R300,-46199:200|0|380|1|R300,-32246:200|0|380|1|R300,-41513:200|0|380|1|R300,-66088:200|0|380|1|R300,-41514:200|0|380|1|R300,-43927:200|0|380|1|R300,-41515:200|0|380|1|R300,-32295:200|0|380|1|R300,-41518:200|0|380|1|R300,-41516:200|0|380|1|R300,-41517:200|0|380|1|R300,-44151:200|0|380|1|R300;E375",
        ["PetAndMountDatabase.Critters.Equipment.Head"] = "38506:HEADSLOT,12185:HEADSLOT",
        ["PetAndMountDatabase.Spells.Travel.Ground.Hunter"] = "-13159,-5118",
        ["PetAndMountDatabase.Critters.Quest"] = "12565,34253,36936",
        ["PetAndMountDatabase.Mounts.Variable.Ground"] = "49289:-1|100|0|1,49288:-1|100|0|1,-58983:-1|100|0|1|R75",
        ["PetAndMountDatabase.Mounts.Ground.Slow"] = "-30174:100|100|0|1,-73630:200|100|0|1|R150,33189:100|100|0|1",
        ["PetAndMountDatabase.Mounts.Passenger.Variable.Flying"] = "-75973:-1|100|-3|2|R225",
        ["PetAndMountDatabase.Spells.Teleport.Mage"] = "-53140,-32272,-3561,-3562,-3563,-3565,-3566,-49358,-33690,-35715,-3567,-49359,-32271",
        ["PetAndMountDatabase.Spells.Teleport.Druid"] = "-18960",
        ["PetAndMountDatabase.Spells.Travel.Flying.Druid"] = "-33943,-40120",
        ["PetAndMountDatabase.Mounts.Variable.Flying"] = "-54729:-1|0|-2|1|R225,-74856:-1|100|-2|1|R225,-75973:-1|100|-3|2|R225",
        ["PetAndMountDatabase.Spells.Teleport.Home.Shaman"] = "-556",
        ["PetAndMountDatabase.Mounts.Flying.ExtremelyFast"] = "-40192:200|0|410|1|R300,-65439:200|0|410|1|R300,-37015:200|0|410|1|R300,-44744:200|0|410|1|R300,25596:200|0|410|1,-63796:200|0|410|1|R300,-63956:200|0|410|1|R300,-71810:200|0|410|1|R300,-63963:200|0|410|1|R300,-49193:200|0|410|1|R300,-58615:200|0|410|1|R300,-64927:200|0|410|1|R300,-60021:200|0|410|1|R300,-72807:200|0|410|1|R300,-67336:200|0|410|1|R300,-72808:200|0|410|1|R300,-59976:200|0|410|1|R300,-60024:200|0|410|1|R300,-69395:200|0|410|1|R300",
        ["PetAndMountDatabase.Critters.Children"] = "31880,18597,46397,46396,31881,18598",
        ["PetAndMountDatabase.Mounts.Ground.VeryFast"] = "-17461:200|100|0|1|R150,-64656:200|100|0|1|R150,-66906:200|100|0|1|R150,-68056:200|100|0|1|R150,-22723:200|100|0|1|R150,-23242:200|100|0|1|R150,-23250:200|100|0|1|R150,-65917:200|100|0|1|R150,-68057:200|100|0|1|R150,-46628:200|100|0|1|R150,-63635:200|100|0|1|R150,-39315:200|100|0|1|R150,-68187:200|100|0|1|R150,-23219:200|100|0|1|R150,-23227:200|100|0|1|R150,-22724:200|100|0|1|R150,-23251:200|100|0|1|R150,-59788:200|100|0|1|R150,-61465:200|100|0|3|R150,-63637:200|100|0|1|R150,-16081:200|100|0|1|R150,-26054:200|100|0|1|R75,-43900:200|100|0|1|R150,-39317:200|100|0|1|R150,-22717:200|100|0|1|R150,-65637:200|100|0|1|R150,-23252:200|100|0|1|R150,-39318:200|100|0|1|R150,-34767:200|100|0|1|R150,-61467:200|100|0|3|R150,-65638:200|100|0|1|R150,-63639:200|100|0|1|R150,-26055:200|100|0|1|R75,-39319:200|100|0|1|R150,-59791:200|100|0|1|R150,-63640:200|100|0|1|R150,-41252:200|100|0|1|R150,-23221:200|100|0|1|R150,-22718:200|100|0|1|R150,-65641:200|100|0|1|R150,-61469:200|100|0|3|R150,-65642:200|100|0|1|R150,-63641:200|100|0|1|R150,16339:200|100|0|1|R150,-65643:200|100|0|1|R150,-59793:200|100|0|1|R150,-17465:200|100|0|1|R150,-34898:200|100|0|1|R150,-65644:200|100|0|1|R150,-63642:200|100|0|1|R150,-23222:200|100|0|1|R150,-24252:200|100|0|1|R150,-65645:200|100|0|1|R150,-67466:200|100|0|1|R150,-15779:200|100|0|1|R150,-34899:200|100|0|1|R150,-65646:200|100|0|1|R150,-25953:200|100|0|1|R75,-63643:200|100|0|1|R150,-60114:200|100|0|1|R150,-55531:200|100|0|2|R150,-73313:200|100|0|1|R75,-35028:200|100|0|1|R150,-51412:200|100|0|1|R150,-23223:200|100|0|1|R150,-22720:200|100|0|1|R150,-23239:200|100|0|1|R150,-23247:200|100|0|1|R150,-48027:200|100|0|1|R150,-61425:200|100|0|3|R150,-16055:200|100|0|1|R150,-16083:200|100|0|1|R150,-49379:200|100|0|1|R150,-65639:200|100|0|1|R150,-23510:200|100|0|1|R150,-23243:200|100|0|1|R150,-59797:200|100|0|1|R150,-17450:200|100|0|1|R150,-66846:200|100|0|1|R150,-35712:200|100|0|1|R150,-18992:200|100|0|1|R150,-49322:200|100|0|1|R150,18791:200|100|0|1|R150,-26056:200|100|0|1|R75,-36702:200|100|0|1|R150,-23228:200|100|0|1|R150,-23509:200|100|0|1|R150,-23338:200|100|0|1|R150,-68188:200|100|0|1|R150,-22721:200|100|0|1|R150,-23240:200|100|0|1|R150,-23214:200|100|0|1|R150,-34896:200|100|0|1|R150,-23248:200|100|0|1|R150,-39316:200|100|0|1|R150,-24242:200|100|0|1|R150,-64659:200|100|0|1|R75,-60118:200|100|0|1|R150,-63232:200|100|0|1|R150,-60116:200|100|0|1|R150,-66090:200|100|0|1|R150,-34790:200|100|0|1|R150,-23229:200|100|0|1|R150,-35027:200|100|0|1|R150,-59799:200|100|0|1|R150,-63638:200|100|0|1|R150,-61470:200|100|0|3|R150,-54753:200|100|0|1|R150,-17460:200|100|0|1|R150,-63636:200|100|0|1|R150,-74918:200|100|0|1|R150,-48778:200|100|0|1|R150,-23161:200|100|0|1|R150,-66091:200|100|0|1|R150,-22719:200|100|0|1|R150,-60119:200|100|0|1|R150,-18991:200|100|0|1|R150,-42777:200|100|0|1|R150,-35714:200|100|0|1|R150,-23225:200|100|0|1|R150,-22722:200|100|0|1|R150,-23241:200|100|0|1|R150,-23249:200|100|0|1|R150,-35713:200|100|0|1|R150,-17459:200|100|0|1|R150,-17481:200|100|0|1|R150,-61447:200|100|0|3|R150,-17229:200|100|0|1|R75,-16056:200|100|0|1|R150,-43688:200|100|0|1|R150,-26656:200|100|0|1|R150,-23238:200|100|0|1|R150,-16080:200|100|0|1|R150,-16084:200|100|0|1|R150,-35025:200|100|0|1|R150,-69826:200|100|0|1|R150,-34897:200|100|0|1|R150,-33660:200|100|0|1|R150,-59785:200|100|0|1|R150,-60424:200|100|0|2|R150,-65640:200|100|0|1|R150",
        ["PetAndMountDatabase.Critters.Normal.Flying"] = "-35907,-36027,-69535,-69536,-36028,-35909,-36029,-35910,-61350,-36031,-35911,-61348,-61349,-45082,-51716,-36034",
        ["PetAndMountDatabase.Spells.Travel.Ground.Druid"] = "-783",
        ["PetAndMountDatabase.Mounts.Flying.Combat"] = "37815:200|0|380|1,37859:200|0|380|1,37860:200|0|380|1",
        ["PetAndMountDatabase.Spells.Teleport"] = "-74969,-26373,-51112,-26409,-26453,-66238,-46149,-71196,-26410,-26450,-26454,-54406,-26455,-82900,-82916,-59317,-68988,-26451,-37778,-26414,-26448,-26412,-26408,-26456,-26452,-26406,-51958",
        ["PetAndMountDatabase.Spells.Teleport.Translocate"] = "-26572,-25652,-32569,-45368,-25143,-35376,-35727,-26566,-29128,-45371,-32571,-30141,-35730,-25140,-25650,-32568,-32572,-25649",
        ["PetAndMountDatabase.Mounts.Aquatic.Fast"] = "-64731:100|160|0|1|R75",
        ["PetAndMountDatabase.Mounts.Passenger.Ground.VeryFast"] = "-61465:200|100|0|3|R150,-61467:200|100|0|3|R150,-61469:200|100|0|3|R150,-55531:200|100|0|2|R150,-61425:200|100|0|3|R150,-61470:200|100|0|3|R150,-61447:200|100|0|3|R150,-60424:200|100|0|2|R150",
        ["PetAndMountDatabase.CompanionEnchant.Critter"] = "44820,43352,35223,37460,43626",
        ["PetAndMountDatabase.CompanionEnchant.Mount"] = "37816,37750,21212,21213",
        ["PetAndMountDatabase.Critters.Normal"] = "-61351,-69677,-67414,-62674,-49964,-45127,-62746,-42609,-45175,-67415,-23811,-17707,-78381,-39709,-28740,-66030,-62508,-62516,-35239,18964,-62564,-61855,-67418,46831,-63712,-59250,-61472,-25162,-62562,-61991,-67416,-53082,-67419,-43918,-65682,-61773,-17708,-10673,-10675,-10677,-19772,-10685,-32298,-67420,-66096,-10695,-10697,-10703,-10707,-10709,-10711,-12243,-10717,-10714,-69541,-40405,-24988,-13548,-33050,-28739,-27570,-10698,-48406,-40634,-55068,-30156,-23530,-39181,-54187,-25849,-40613,-10680,-43697,-17709,-4055,-16450,-64351,-62491,-75906,-63318,-62561,-69002,-45174,-15048,-28738,-24696,-26010,-40549,-28871,-46426,-62510,-40614,-45890,-71840,-52615,-43698,-65381,-74932,-61357,-45125,-62542,-46599,-10679,-48408,-35156,-46425,-70613,-15999,-15049,-23531,-53316,-27241,-62513,-44369,-10683,-28505,-65358,-51851,-65382,-10674,-10676,-10678,-62609,-10682,-10684,-10688,-69452,-68810,-40990,-10696,-68767,-10704,-10706,-61725,-10716,-67413,-15067,-67417,-75134,-10713",
        ["PetAndMountDatabase.Mounts.Variable.All"] = "37011:-2|100|-2|1|R75,-48025:-2|100|-2|1|R75,-75614:-2|100|-3|1|R75,-72286:-2|100|-1|1|R75,-71342:-2|100|-1|1|R75",
        ["PetAndMountDatabase.Spells.Teleport.Items.Engineering.Goblin"] = "-36890:30542,-23442:18984",
        ["PetAndMountDatabase.Spells.Teleport.Items.Engineering.Gnomish"] = "-23452:18986,-30544:30544",
        ["PetAndMountDatabase.Items.CritterEnchant"] = "m,PetAndMountDatabase.CompanionEnchant.Critter",
        ["PetAndMountDatabase.Items.MountEnchant"] = "m,PetAndMountDatabase.CompanionEnchant.Mount",
        ["PetAndMountDatabase.Conversion.Mounts"] = "13321:-17453,13328:-17461,32861:-41517,25532:-32296,44160:-59961,44178:-60025,33176:-42667,46101:-64656,47179:-66906,32458:-40192,49046:-68056,29471:-22723,18789:-23242,18796:-23250,46171:-65439,28927:-34795,49290:-65917,49044:-68057,35513:-46628,34060:-44153,30609:-37015,33182:-42668,33184:-42668,45593:-63635,34092:-44744,5665:-6653,31829:-39315,31830:-39315,54797:-75596,46308:-64977,13322:-17454,13331:-17462,25527:-32289,25533:-32297,49096:-68187,25596:-32345,29220:-35020,18767:-23219,18776:-23227,29469:-22724,45693:-63796,18797:-23251,33976:-43899,45725:-63844,44077:-59788,47100:-66847,45801:-63956,43959:-61465,44151:-59996,45591:-63637,37815:-49345,12351:-16081,5864:-6777,21321:-26054,33977:-43900,31831:-39317,31832:-39317,23720:-30174,25473:-32242,13332:-17463,25528:-32290,29221:-35022,19872:-24242,29468:-22717,46745:-65637,18798:-23252,31833:-39318,31834:-39318,44554:-61451,44083:-61467,46744:-65638,49289:-68768,45590:-63639,43952:-59567,5872:-6899,21324:-26055,32314:-39798,49288:-68769,31835:-39319,31836:-39319,44230:-59791,25470:-32235,25474:-32243,40775:-54729,15277:-18989,13333:-17464,8591:-10796,46813:-66087,46752:-65640,45595:-63640,43953:-59568,32768:-41252,18766:-23221,29466:-22718,44689:-61229,46750:-65641,29743:-35711,44558:-61309,44086:-61469,44843:-61996,46747:-65642,45592:-63641,43951:-59569,16339:-16082,37859:-49461,44690:-61230,46748:-65643,29746:-35712,44707:-61294,44231:-59793,25475:-32244,15290:-18990,13334:-17465,25529:-32292,29104:-34898,29229:-34898,44842:-61997,46743:-65644,45596:-63642,43955:-59570,43986:-59650,18774:-23222,19902:-24252,18786:-23238,18791:-23246,37011:-47977,37012:-48025,47180:-67466,13326:-15779,29105:-34899,29230:-34899,46749:-65646,50435:-71810,44168:-60002,21218:-25953,45597:-63643,43954:-59571,44225:-60114,41508:-55531,5655:-6648,5668:-6654,32318:-39802,25476:-32245,45802:-63963,8632:-10789,8629:-10793,52200:-73313,34129:-35028,49282:-51412,44229:-64762,18773:-23223,29467:-22720,18787:-23239,18793:-23247,32319:-39803,35906:-48027,54811:-75614,44235:-61425,37676:-49193,28481:-34406,12303:-16055,8631:-8394,8595:-10969,12353:-16083,46109:-64731,43516:-58615,44080:-59797,29228:-34790,15293:-18992,32857:-41513,43599:-58983,44175:-60021,37719:-49322,29472:-22721,18785:-23240,51955:-72807,44413:-60424,25472:-32240,32316:-39801,33189:-42692,49286:-46199,29103:-34897,29231:-34897,29223:-35025,5656:-458,49098:-68188,32858:-41514,21176:-26656,29102:-34896,29227:-34896,51954:-72808,28915:-39316,44177:-60024,2411:-470,18902:-23338,33183:-42680,44164:-59976,8592:-10799,5873:-6898,44223:-60118,29222:-35018,44221:-64749,45125:-63232,46099:-64658,46816:-66091,15292:-18991,18777:-23229,46746:-65645,49283:-42776,29744:-35710,49285:-46197,43958:-59799,25471:-32239,44226:-60116,44234:-61447,43962:-54753,13335:-17481,13329:-17460,32859:-41515,25531:-32295,29747:-35714,13327:-17459,8628:-10792,29745:-35713,25477:-32246,54860:-75973,47840:-67336,18778:-23228,45586:-63636,44224:-60119,29465:-22719,49284:-42777,32862:-41518,18772:-23225,29470:-22722,18788:-23241,18794:-23249,46814:-66088,50250:-71342,33999:-43927,43961:-61470,45589:-63638,2414:-472,37860:-49462,29224:-35027,46815:-66090,54465:-75207,32860:-41516,18795:-23248,13086:-17229,46102:-64659,54069:-74856,34061:-44151,12302:-16056,8588:-8395,33809:-43688,49636:-69395,1132:-580,46100:-64657,12330:-16080,8586:-16084,19029:-23509,21323:-26056,8563:-10873,18790:-23243,19030:-23510,32317:-39800,28936:-33660,13317:-17450,47101:-66846,37828:-49379,43956:-59785,46751:-65639,46708:-64927,50818:-72286,30480:-36702",
        ["PetAndMountDatabase.Conversion.Critters"] = "34425:-54187,39898:-61351,49693:-69677,48114:-67414,45002:-62674,29901:-35907,38050:-49964,34493:-45127,45022:-62746,33154:-42609,34519:-45175,48116:-67415,19450:-23811,46397:-65352,49662:-69535,13583:-17707,12565:-15647,32233:-39709,31880:-39478,49663:-69536,23015:-28740,46802:-66030,44738:-61472,44970:-62508,44974:-62516,29364:-35239,18964:-23429,29956:-36028,44982:-62564,44819:-61855,21301:-26533,21305:-26541,48122:-67418,46831:-66175,29902:-35909,45606:-63712,44841:-61991,39656:-53082,48124:-67419,33993:-43918,46767:-65682,43698:-59250,13584:-17708,8485:-10673,8491:-10675,8490:-10677,8489:-10679,15996:-19772,11023:-10685,48126:-67420,10822:-10695,8499:-10697,29903:-35910,11027:-10703,8500:-10707,10394:-10709,8497:-10711,10398:-12243,10392:-10717,44971:-62510,44980:-62542,49665:-69541,32498:-40405,30360:-24988,11110:-13548,27445:-33050,22235:-27570,29904:-35911,41133:-55068,18597:-23012,32588:-40549,19054:-23530,21168:-25849,32617:-40613,29958:-36031,33816:-43697,13582:-17709,4401:-4055,12529:-16450,39896:-61348,44822:-10713,54436:-75134,48120:-67417,11474:-15067,49362:-69002,48118:-67416,44965:-62491,23002:-28738,21277:-26010,54847:-75906,44794:-61725,25535:-32298,11026:-10704,39973:-53316,33818:-43698,38628:-51716,38506:-51149,46820:-66096,46821:-66096,49343:-68810,32616:-40614,32622:-40634,39286:-52615,50446:-71840,46545:-65381,53641:-74932,49912:-70613,10393:-10688,8495:-10684,37297:-48406,39899:-61349,44723:-61357,44998:-62609,31881:-39479,21308:-26529,35504:-46599,21309:-26045,45942:-64351,37298:-48408,29363:-35156,35349:-46425,34478:-45082,34492:-45125,18598:-23013,38658:-51851,19055:-23531,46398:-65358,22781:-28505,44973:-62513,8492:-10683,46707:-44369,22114:-27241,11826:-15049,45180:-63318,44983:-62561,12264:-15999,46544:-65382,8486:-10674,8487:-10676,8488:-10678,8496:-10680,8494:-10682,44721:-61350,11825:-15048,31760:-39181,49646:-69452,36936:-47794,40653:-40990,34535:-10696,8498:-10698,49287:-68767,20769:-25162,23007:-28739,8501:-10706,23083:-28871,34253:-44879,29953:-36027,10360:-10714,10361:-10716,20371:-24696,34518:-45174,48112:-67413,34955:-45890,44810:-61773,12185:-17567,29960:-36034,44984:-62562,35350:-46426,46396:-65353,23713:-30156,29957:-36029",
    } );