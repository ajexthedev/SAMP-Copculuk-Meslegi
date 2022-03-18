#define FILTERSCRIPT

#include <a_samp>
#include <zcmd>
#include <foreach>
#include <streamer>

#define GARBAGE_POINT_LABEL_TEXT "[Çöp Konteynırı]\nÇöp toplamak için ALT tuşuna basın."
#define GARBAGE_POINT_RANGE (3.0)

//2182.2769,-1207.2877,24.0278
#define GARBAGE_POINT_ONE_X (2182.2769)
#define GARBAGE_POINT_ONE_Y (-1207.2877)
#define GARBAGE_POINT_ONE_Z (24.0278)

//1415.3082,-1300.6676,13.5447
#define GARBAGE_POINT_TWO_X (1415.3082)
#define GARBAGE_POINT_TWO_Y (-1300.6676)
#define GARBAGE_POINT_TWO_Z (13.5447)

#define MAX_PRICE (350)
#define MINIMUM_PRICE (100)

enum e_player_data
{
	bool:GarbageManDuty,
	PlayerCheckpoints
};

new PlayerData[MAX_PLAYERS][e_player_data];

new PlayerText:OnPlayerEnterGarbageTruck[MAX_PLAYERS][1];
new PlayerText:OnPlayerGarbageDuty[MAX_PLAYERS][1];
new PlayerText:OnPlayerRequestJobOnDuty[MAX_PLAYERS][1];

new bool:GarbageCarrying[MAX_PLAYERS];
new bool:GarbageEquipped[MAX_PLAYERS];

#if defined FILTERSCRIPT

#else
#endif

new GarbageTruck[2];

new bool:GarbagePoints[MAX_PLAYERS][2];
 
public OnFilterScriptInit()
{
	CreateDynamic3DTextLabel(GARBAGE_POINT_LABEL_TEXT, -1, GARBAGE_POINT_ONE_X, GARBAGE_POINT_ONE_Y, GARBAGE_POINT_ONE_Z, 15.0);

	CreateDynamic3DTextLabel(GARBAGE_POINT_LABEL_TEXT, -1, GARBAGE_POINT_TWO_X, GARBAGE_POINT_TWO_Y, GARBAGE_POINT_TWO_Z, 15.0);

	//Garbage Trucks
	GarbageTruck[0] = AddStaticVehicle(408, 2210.3020, -2657.7844, 13.5469, 86.8014, -1, -1);
	GarbageTruck[1] = AddStaticVehicle(408, 2211.0945, -2649.3804, 13.5469, 86.8014, -1, -1);

	return 1;
}

public OnPlayerConnect(playerid)
{
	//PlayerTextDrawShow(playerid, OnPlayerEnterGarbageTruck[playerid][0]);
	OnPlayerEnterGarbageTruck[playerid][0] = CreatePlayerTextDraw(playerid, 67.000000, 243.000000, "Copculuk meslegine ait araca bindiniz. Meslege baslamak icin N tusuna basin.");
	PlayerTextDrawFont(playerid, OnPlayerEnterGarbageTruck[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, OnPlayerEnterGarbageTruck[playerid][0], 0.408333, 1.400000);
	PlayerTextDrawTextSize(playerid, OnPlayerEnterGarbageTruck[playerid][0], 302.500000, 118.500000);
	PlayerTextDrawSetOutline(playerid, OnPlayerEnterGarbageTruck[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, OnPlayerEnterGarbageTruck[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, OnPlayerEnterGarbageTruck[playerid][0], 2);
	PlayerTextDrawColor(playerid, OnPlayerEnterGarbageTruck[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, OnPlayerEnterGarbageTruck[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, OnPlayerEnterGarbageTruck[playerid][0], 135);
	PlayerTextDrawUseBox(playerid, OnPlayerEnterGarbageTruck[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, OnPlayerEnterGarbageTruck[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, OnPlayerEnterGarbageTruck[playerid][0], 0);

	//PlayerTextDrawShow(playerid, OnPlayerGarbageDuty[playerid][0]);
	OnPlayerGarbageDuty[playerid][0] = CreatePlayerTextDraw(playerid, 67.000000, 243.000000, "Haritada isaretlenen checkpointe ilerleyin ve copleri toplayin.");
	PlayerTextDrawFont(playerid, OnPlayerGarbageDuty[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, OnPlayerGarbageDuty[playerid][0], 0.408333, 1.400000);
	PlayerTextDrawTextSize(playerid, OnPlayerGarbageDuty[playerid][0], 302.500000, 118.500000);
	PlayerTextDrawSetOutline(playerid, OnPlayerGarbageDuty[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, OnPlayerGarbageDuty[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, OnPlayerGarbageDuty[playerid][0], 2);
	PlayerTextDrawColor(playerid, OnPlayerGarbageDuty[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, OnPlayerGarbageDuty[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, OnPlayerGarbageDuty[playerid][0], 135);
	PlayerTextDrawUseBox(playerid, OnPlayerGarbageDuty[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, OnPlayerGarbageDuty[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, OnPlayerGarbageDuty[playerid][0], 0);

	//PlayerTextDrawShow(playerid, OnPlayerRequestJobOnDuty[playerid][0]);
	OnPlayerRequestJobOnDuty[playerid][0] = CreatePlayerTextDraw(playerid, 67.000000, 243.000000, "Su anda zaten halihazirda bir gorevin var. Yenisine baslamak icin bitirin.");
	PlayerTextDrawFont(playerid, OnPlayerRequestJobOnDuty[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, OnPlayerRequestJobOnDuty[playerid][0], 0.408333, 1.400000);
	PlayerTextDrawTextSize(playerid, OnPlayerRequestJobOnDuty[playerid][0], 302.500000, 118.500000);
	PlayerTextDrawSetOutline(playerid, OnPlayerRequestJobOnDuty[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, OnPlayerRequestJobOnDuty[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, OnPlayerRequestJobOnDuty[playerid][0], 2);
	PlayerTextDrawColor(playerid, OnPlayerRequestJobOnDuty[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, OnPlayerRequestJobOnDuty[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, OnPlayerRequestJobOnDuty[playerid][0], 135);
	PlayerTextDrawUseBox(playerid, OnPlayerRequestJobOnDuty[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, OnPlayerRequestJobOnDuty[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, OnPlayerRequestJobOnDuty[playerid][0], 0);

	GarbageManResetVariables(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	PlayerTextDrawDestroy(playerid, OnPlayerEnterGarbageTruck[playerid][0]);

	PlayerTextDrawDestroy(playerid, OnPlayerGarbageDuty[playerid][0]);

	PlayerTextDrawDestroy(playerid, OnPlayerRequestJobOnDuty[playerid][0]);

	GarbageManResetVariables(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(PlayerData[playerid][GarbageManDuty] == true)
	{
		GarbageManResetVariables(playerid);
		return 1;
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(PlayerData[playerid][GarbageManDuty] == true)
	{
		if(GarbagePoints[playerid][0] == true && !IsPlayerInRangeOfPoint(playerid, 15.0, GARBAGE_POINT_ONE_X, GARBAGE_POINT_ONE_Y, GARBAGE_POINT_ONE_Z))
		{
			new vehid = GetPlayerVehicleID(playerid);
			SetVehicleToRespawn(vehid);
		}
		else if(GarbagePoints[playerid][1] == true && !IsPlayerInRangeOfPoint(playerid, 15.0, GARBAGE_POINT_TWO_X, GARBAGE_POINT_TWO_Y, GARBAGE_POINT_TWO_Z))
		{
			new vehid = GetPlayerVehicleID(playerid);
			SetVehicleToRespawn(vehid);
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
    {
		for(new i = 0; i < sizeof GarbageTruck; i++)
		{
			if(IsPlayerInVehicle(playerid, GarbageTruck[i]))
			{
				if(PlayerData[playerid][GarbageManDuty] == false)
					SetTimerEx("GarbageManDutyTD", 500, false, "d", playerid);
			}
		}
	}
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT) 
    {
		if(PlayerData[playerid][GarbageManDuty] == true)
		{
			if(GarbagePoints[playerid][0] == true && IsPlayerInRangeOfPoint(playerid, 20.0, GARBAGE_POINT_ONE_X, GARBAGE_POINT_ONE_Y, GARBAGE_POINT_ONE_Z))
			{
				GameTextForPlayer(playerid,"Noktaya ulastin!", 2000, 4);
			}
			else if(GarbagePoints[playerid][1] == true && IsPlayerInRangeOfPoint(playerid, 20.0, GARBAGE_POINT_TWO_X, GARBAGE_POINT_TWO_Y, GARBAGE_POINT_TWO_Z))
			{
				GameTextForPlayer(playerid, "Noktaya ulastin!", 2000, 4);
			}
			else
			{
				new vehid = GetPlayerVehicleID(playerid);
				SetVehicleToRespawn(vehid);
				SendClientMessage(playerid, -1, "Çöpçü kamyonundan iniş yaptığın için bütün verilerin sıfırlandı.");
				GarbageManResetVariables(playerid);
			}
		}
    }
	return 1;
}

stock GarbageManResetVariables(playerid)
{
	PlayerData[playerid][GarbageManDuty] = false;
	GarbagePoints[playerid][0] = false;
	GarbagePoints[playerid][1] = false;
	GarbageCarrying[playerid] = false;
	GarbageEquipped[playerid] = false;
	PlayerData[playerid][PlayerCheckpoints] = 0;
	DisablePlayerCheckpoint(playerid);
	RemovePlayerAttachedObject(playerid, 0);

	return 1;
} 

forward GarbageManDutyTD(playerid);
public GarbageManDutyTD(playerid)
{
	PlayerTextDrawShow(playerid, OnPlayerEnterGarbageTruck[playerid][0]);
	SetTimerEx("GarbageManDutyTDClose", 6000, false, "d", playerid);
	return 1;
} 

forward GarbageManDutyTDClose(playerid);
public GarbageManDutyTDClose(playerid)
{
	PlayerTextDrawHide(playerid, OnPlayerEnterGarbageTruck[playerid][0]);
	return 1;
}

forward GarbageManOnDutyTD(playerid);
public GarbageManOnDutyTD(playerid)
{
	PlayerTextDrawShow(playerid, OnPlayerGarbageDuty[playerid][0]);
	SetTimerEx("GarbageManOnDutyTDClose", 6000, false, "d", playerid);
	return 1;
}

forward GarbageManOnDutyTDClose(playerid);
public GarbageManOnDutyTDClose(playerid)
{
	PlayerTextDrawHide(playerid, OnPlayerGarbageDuty[playerid][0]);
	return 1;
}

forward GarbageManOnDutyErrorTD(playerid);
public GarbageManOnDutyErrorTD(playerid)
{
	PlayerTextDrawShow(playerid, OnPlayerRequestJobOnDuty[playerid][0]);
	SetTimerEx("GarbageManOnDutyErrorTDClose", 3000, false, "d", playerid);
	return 1;
} 

forward GarbageManOnDutyErrorTDClose(playerid);
public GarbageManOnDutyErrorTDClose(playerid)
{
	PlayerTextDrawHide(playerid, OnPlayerRequestJobOnDuty[playerid][0]);
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerData[playerid][PlayerCheckpoints] == 1)
	{
		PlayerData[playerid][PlayerCheckpoints] = 0;
		DisablePlayerCheckpoint(playerid);
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if ((newkeys & KEY_NO) && !(oldkeys & KEY_NO))
	{
		for(new i = 0; i < sizeof GarbageTruck; i++)
		{
			if(IsPlayerInVehicle(playerid, GarbageTruck[i]))
			{
				if(PlayerData[playerid][GarbageManDuty] == false)
				{
					PlayerTextDrawHide(playerid, OnPlayerEnterGarbageTruck[playerid][0]);
					SetTimerEx("GarbageManOnDutyTD", 100, false, "d", playerid);
					PlayerData[playerid][GarbageManDuty] = true;
					ShowPlayerGarbagePoints(playerid);
				}
				else
				{
					PlayerTextDrawHide(playerid, OnPlayerGarbageDuty[playerid][0]);
					SetTimerEx("GarbageManOnDutyErrorTD", 100, false, "d", playerid);
				}
			}
		}
	}

	if ((newkeys & KEY_WALK) && !(oldkeys & KEY_WALK))
	{
		if(PlayerData[playerid][GarbageManDuty] == true && GarbageCarrying[playerid] == false)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.0, GARBAGE_POINT_ONE_X, GARBAGE_POINT_ONE_Y, GARBAGE_POINT_ONE_Z) && GarbagePoints[playerid][0] == true)
			{
				SetTimerEx("CarryingGarbage", 100, false, "d", playerid);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 1.0, GARBAGE_POINT_TWO_X, GARBAGE_POINT_TWO_Y, GARBAGE_POINT_TWO_Z) && GarbagePoints[playerid][1] == true)
			{
				SetTimerEx("CarryingGarbage", 100, false, "d", playerid);
			}
 		}

		if(PlayerData[playerid][GarbageManDuty] == true && GarbageEquipped[playerid] == true)
		{
			if(GarbagePoints[playerid][0] == true || GarbagePoints[playerid][1] == true)
			{
				for(new i = 0; i < sizeof GarbageTruck; i++)
				{
					if(IsPlayerNearVehicle(playerid, GarbageTruck[i], 3.0))
					{
						new randmoney = 50 + randomEx(MINIMUM_PRICE, MAX_PRICE);
						RemovePlayerAttachedObject(playerid, 0);
						GarbageCarrying[playerid] = false;
						GivePlayerMoney(playerid, randmoney);
						ShowPlayerGarbagePoints(playerid);
						GarbagePoints[playerid][0] = false;
						GarbagePoints[playerid][1] = false;
						GarbageEquipped[playerid] = false;
						PlayerData[playerid][GarbageManDuty] = false;
						PlayerData[playerid][PlayerCheckpoints] = 0;
						DisablePlayerCheckpoint(playerid);
						SendClientMessageEx(playerid, -1, "Çöpü araca yükledin ve $%d kazandın! Araca bin ve tekrardan N basarak devam et.", randmoney);
					}
				}
			}
		}   
	}
	return 1;
}

forward CarryingGarbage(playerid);
public CarryingGarbage(playerid)
{

	GameTextForPlayer(playerid, "Su anda cop topluyorsunuz, bekleyin.", 3000, 4);
	TogglePlayerControllable(playerid, false);
	ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_CROUCH_IN", 4.1, 0, 0, 0, 1, 1, 0);
	GarbageCarrying[playerid] = true;
	SetTimerEx("GarbageCarried", 3000, false, "d", playerid);
	return 1;
} 

forward GarbageCarried(playerid);
public GarbageCarried(playerid)
{
	SendClientMessage(playerid, -1, "Çöp toplandı, aracın yanına ilerleyin ve ALT tuşuna basarak kamyona yükleyin.");
	TogglePlayerControllable(playerid, true);
	GarbageCarrying[playerid] = false;
	SetPlayerAttachedObject(playerid, 0,1265,6,0.079376,0.037070,0.007706,181.482910,0.000000,0.000000,1.000000,1.000000,1.000000);
	GarbageEquipped[playerid] = true;
	ClearAnimations(playerid);
	return 1;
}

stock ShowPlayerGarbagePoints(playerid)
{
	new randpoints = random(2);

	switch(randpoints)
	{
		case 0:
		{
			SetPlayerCheckpoint(playerid, GARBAGE_POINT_ONE_X, GARBAGE_POINT_ONE_Y, GARBAGE_POINT_ONE_Z, 5.0);
			PlayerData[playerid][PlayerCheckpoints] = 1;
			GarbagePoints[playerid][0] = true;
		}
		case 1:
		{
			SetPlayerCheckpoint(playerid, GARBAGE_POINT_TWO_X, GARBAGE_POINT_TWO_Y, GARBAGE_POINT_ONE_Z, 5.0);
			PlayerData[playerid][PlayerCheckpoints] = 1;
			GarbagePoints[playerid][1] = true;
		}
	}
	return 1;
}

stock SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
    static
        args,
        str[144];

    /*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
    */
    if ((args = numargs()) == 3)
    {
        SendClientMessage(playerid, color, text);
    }
    else
    {
        while (--args >= 3)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 144
        #emit PUSH.C str
        #emit PUSH.S 8
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        SendClientMessage(playerid, color, str);

        #emit RETN
    }
    return 1;
}

stock randomEx(min, max)
{
    new randm = random(max-min)+min;
    return randm;
}

static IsPlayerNearVehicle(playerid, vehicleid, Float:range)
{
	new Float:x, Float:y, Float:z;
	GetVehiclePos(vehicleid, x, y, z);
	return IsPlayerInRangeOfPoint(playerid, range, x, y, z);
}
