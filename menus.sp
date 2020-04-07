#if !defined MENUS_SP
#define MENUS_SP

public Menu GetAwpMenu() {
    Menu AwpMenu = new Menu(MenuGunAwpHandler);
    AwpMenu.SetTitle("Would you like to play with awp?");
    AwpMenu.AddItem("1", "Yes");
    AwpMenu.AddItem("0", "No");
    AwpMenu.ExitButton = false;
    return AwpMenu;
 }

 public Menu GetAwpSecondaryMenu() {
    Menu AwpSecondaryMenu = new Menu(AwpSecondaryMenuHandler);
    AwpSecondaryMenu.SetTitle("Which pistol would you like with awp?");

    char itoa_FiveSeven_Tec9_P250[MAX_INPUT_SIZE];
    IntToString(view_as<int>(FIVESEVEN | TEC9 | P250), itoa_FiveSeven_Tec9_P250, sizeof(itoa_FiveSeven_Tec9_P250));

    char itoa_CZ_P250[MAX_INPUT_SIZE];
    IntToString(view_as<int>(CZ | P250), itoa_CZ_P250, sizeof(itoa_CZ_P250));

    char itoa_P250[MAX_INPUT_SIZE];
    IntToString(view_as<int>(P250), itoa_P250, sizeof(itoa_P250));

    AwpSecondaryMenu.AddItem(itoa_FiveSeven_Tec9_P250, "Five-Seven / Tec-9 / p250");
    AwpSecondaryMenu.AddItem(itoa_CZ_P250, "CZ / p250");
    AwpSecondaryMenu.AddItem(itoa_P250, "p250");
    AwpSecondaryMenu.ExitButton = false;

    return AwpSecondaryMenu;
 }

 public Menu GetPrimaryTMenu() {
    Menu PrimaryTMenu = new Menu(PrimaryTMenuHandler);
    PrimaryTMenu.SetTitle("Select Terrorist weapon:");

    char itoa_ak[MAX_INPUT_SIZE];
    char itoa_sg[MAX_INPUT_SIZE];

    IntToString(view_as<int>(AK47), itoa_ak, sizeof(itoa_ak));
    IntToString(view_as<int>(SG553), itoa_sg, sizeof(itoa_sg));

    PrimaryTMenu.AddItem(itoa_ak, "AK-47");
    PrimaryTMenu.AddItem(itoa_sg, "SG 553");
    PrimaryTMenu.ExitButton = false;

    return PrimaryTMenu;
 }

 public Menu GetPrimaryCTMenu() {
    Menu PrimaryCTMenu = new Menu(PrimaryCTMenuHandler);
    PrimaryCTMenu.SetTitle("Select Counter-Terrorist weapon:");

    char itoa_m4a1[MAX_INPUT_SIZE];
    char itoa_m4a1s[MAX_INPUT_SIZE];

    IntToString(view_as<int>(M4A1), itoa_m4a1, sizeof(itoa_m4a1));
    IntToString(view_as<int>(M4A1S), itoa_m4a1s, sizeof(itoa_m4a1s));

    PrimaryCTMenu.AddItem(itoa_m4a1, "M4A4");
    PrimaryCTMenu.AddItem(itoa_m4a1s, "M4A1-S");
    PrimaryCTMenu.ExitButton = false;

    return PrimaryCTMenu;
 }

/* Hold menus in main because we want to access g_ClientWeaponPref */
public Action MenuGunPref(int client, int argc)
{
    Menu PrimaryTMenu = GetPrimaryTMenu();
    PrimaryTMenu.Display(client, MENU_TIME_FOREVER);
 
    return Plugin_Handled;
}

public int PrimaryTMenuHandler(Menu menu, MenuAction action, int client, int param2)
{
    if (action == MenuAction_Select)
    {
        char input[MAX_INPUT_SIZE];
        bool found = menu.GetItem(param2, input, sizeof(input));
        PrintToChatAll("Primary T client %d - You selected item: %s (found? %d info: %s)", client, param2, found, input);
        g_ClientWeaponPref[client].pref.primary_t = view_as<WeaponTypes>(StringToInt(input));
        g_ClientWeaponPref[client].pref.StoreClientCookies(client);

        Menu PrimaryCTMenu = GetPrimaryCTMenu();
        
        PrimaryCTMenu.Display(client, MENU_TIME_FOREVER);        
    }
    if (action == MenuAction_End)
    {
        delete menu;
    }
}

public int PrimaryCTMenuHandler(Menu menu, MenuAction action, int client, int param2)
{
    if (action == MenuAction_Select)
    {
        char input[MAX_INPUT_SIZE];
        bool found = menu.GetItem(param2, input, sizeof(input));
        PrintToChatAll("Primary CT client %d - You selected item: %s (found? %d info: %s)", client, param2, found, input);
        g_ClientWeaponPref[client].pref.primary_ct = view_as<WeaponTypes>(StringToInt(input));
        g_ClientWeaponPref[client].pref.StoreClientCookies(client);

        Menu AwpMenu = GetAwpMenu();
        AwpMenu.Display(client, MENU_TIME_FOREVER);
    }
    if (action == MenuAction_End)
    {
        delete menu;
    }
}

public int MenuGunAwpHandler(Menu menu, MenuAction action, int client, int param2)
{
    if (action == MenuAction_Select)
    {
        char input[MAX_INPUT_SIZE];
        bool found = menu.GetItem(param2, input, sizeof(input));
        PrintToChatAll("Want awp client %d - You selected item: %s (found? %d info: %s)", client, param2, found, input);
        g_ClientWeaponPref[client].pref.want_awp = view_as<bool>(StringToInt(input));
        g_ClientWeaponPref[client].pref.StoreClientCookies(client);
        if (g_ClientWeaponPref[client].pref.want_awp) {
            Menu AwpSecondaryMenu = GetAwpSecondaryMenu();
            AwpSecondaryMenu.Display(client, MENU_TIME_FOREVER);
        }
    }
    if (action == MenuAction_End)
    {
        delete menu;
    }
}

public int AwpSecondaryMenuHandler(Menu menu, MenuAction action, int client, int param2)
{
    if (action == MenuAction_Select)
    {
        char input[MAX_INPUT_SIZE];
        bool found = menu.GetItem(param2, input, sizeof(input));
        PrintToChatAll("Awp secondary client %d - You selected item: %s (found? %d info: %s)", client, param2, found, input);
        g_ClientWeaponPref[client].pref.awp_secondary = view_as<WeaponTypes>(StringToInt(input));
        g_ClientWeaponPref[client].pref.StoreClientCookies(client);
    }
    if (action == MenuAction_End)
    {
        delete menu;
    }
}

#endif // MENUS_SP