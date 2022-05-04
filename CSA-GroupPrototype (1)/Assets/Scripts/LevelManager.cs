using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

[System.Serializable]
public struct LevelIDs
{
    public int ID;
    public string unityLevelName;

    LevelIDs(int _id, string _uln)
    {
        ID = _id;
        unityLevelName = _uln;
    }
}

public class LevelManager : MonoBehaviour
{
    public List<LevelIDs> dungeonIDs = new List<LevelIDs>();
    public List<LevelIDs> villageIDs = new List<LevelIDs>();

    public void TryLoadDungeon(int _ID)
    {
        foreach (LevelIDs lid in dungeonIDs)
        {
            if (lid.ID == _ID)
            {
                //Got the correct level, now load it
                SceneManager.LoadScene(lid.unityLevelName);
            }
        }
    }

    public void TryLoadVillage(int _ID)
    {
        foreach (LevelIDs lid in villageIDs)
        {
            if (lid.ID == _ID)
            {
                //Got the correct level, now load it
                SceneManager.LoadScene(lid.unityLevelName);
            }
        }
    }

    public bool CheckDungeonLocked(int _ID)
    {
        return DataManager.DungeonExistsInPlayerData(_ID);
    }

    public bool CheckVillageLocked(int _ID)
    {
        return DataManager.VillageExistsInPlayerData(_ID);
    }
}
