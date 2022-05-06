using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine;
using UnityEngine.Events;

public class DataManager : MonoBehaviour
{
    public static OptionsSaveData optionsData;
    public static PlayerSaveData playerData;

    public UnityEvent onLoadOptionsData;
    public UnityEvent onLoadPlayerData;

    private void InitializeData()
    {
        optionsData = new OptionsSaveData();
        optionsData.resWidth = 1280;
        optionsData.resHeight = 720;
        optionsData.vSync = true;
        optionsData.UIMode = 0;
        optionsData.stickSensitivity = 1f;

        playerData = new PlayerSaveData();
        playerData.profileSelected = 0;
        playerData.p1levelsUnlocked = 0;
        playerData.p1villagesUnlocked = 0;
        playerData.p2levelsUnlocked = 0;
        playerData.p2villagesUnlocked = 0;
        playerData.p3levelsUnlocked = 0;
        playerData.p3villagesUnlocked = 0;

    }

    public static bool DungeonExistsInPlayerData(int _ID)
    {
        switch (playerData.profileSelected)
        {
            case 0:
                return playerData.p1levelsUnlocked >= _ID;
            case 1:
                return playerData.p2levelsUnlocked >= _ID;
            case 2:
                return playerData.p3levelsUnlocked >= _ID;
        }
        return false;
    }

    public static bool VillageExistsInPlayerData(int _ID)
    {
        switch (playerData.profileSelected)
        {
            case 0:
                return playerData.p1villagesUnlocked >= _ID;
            case 1:
                return playerData.p2villagesUnlocked >= _ID;
            case 2:
                return playerData.p3villagesUnlocked >= _ID;
        }
        return false;
    }

    private void Start()
    {
        DontDestroyOnLoad(this);
        InitializeData();
        onLoadOptionsData.Invoke();
        onLoadPlayerData.Invoke();
    }
}
