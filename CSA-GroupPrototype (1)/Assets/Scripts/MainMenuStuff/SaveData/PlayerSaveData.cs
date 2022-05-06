using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class PlayerSaveData
{
    public int profileSelected = 0;

    public List<int> p1levelsUnlocked = new List<int>();
    public List<int> p1villagesUnlocked = new List<int>();
    public List<int> p1items = new List<int>();

    public List<int> p2levelsUnlocked = new List<int>();
    public List<int> p2villagesUnlocked = new List<int>();
    public List<int> p2items = new List<int>();

    public List<int> p3levelsUnlocked = new List<int>();
    public List<int> p3villagesUnlocked = new List<int>();
    public List<int> p3items = new List<int>();
}
