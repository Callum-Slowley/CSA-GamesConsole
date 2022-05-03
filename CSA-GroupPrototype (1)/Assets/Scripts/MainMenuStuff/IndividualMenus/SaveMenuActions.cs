using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SaveMenuActions : MonoBehaviour
{
    [Header("UI references")]
    public Image profileOneActiveImage;
    public Image profileTwoActiveImage;
    public Image profileThreeActiveImage;

    public Sprite inactiveImage;
    public Sprite activeImage;

    public void UpdateProfileUI()
    {
        switch (DataManager.playerData.profileSelected)
        {
            case 0:
                //Selecting profile 1
                profileOneActiveImage.sprite = activeImage;
                profileTwoActiveImage.sprite = inactiveImage;
                profileThreeActiveImage.sprite = inactiveImage;
                break;
            case 1:
                //Selecting Profile 2
                profileOneActiveImage.sprite = inactiveImage;
                profileTwoActiveImage.sprite = activeImage;
                profileThreeActiveImage.sprite = inactiveImage;
                break;
            case 2:
                //Selecting profle 3
                profileOneActiveImage.sprite = inactiveImage;
                profileTwoActiveImage.sprite = inactiveImage;
                profileThreeActiveImage.sprite = activeImage;
                break;
        }
    }

    public void SelectProfile(int _id)
    {
        DataManager.playerData.profileSelected = _id;
        UpdateProfileUI();
    }

    public void ClearProfile(int _id)
    {
        switch (_id)
        {
            case 0:
                DataManager.playerData.p1levelsUnlocked = new List<int>();
                DataManager.playerData.p1villagesUnlocked = new List<int>();
                DataManager.playerData.p1items = new List<int>();
                break;
            case 1:
                DataManager.playerData.p2levelsUnlocked = new List<int>();
                DataManager.playerData.p2villagesUnlocked = new List<int>();
                DataManager.playerData.p2items = new List<int>();
                break;
            case 2:
                DataManager.playerData.p3levelsUnlocked = new List<int>();
                DataManager.playerData.p3villagesUnlocked = new List<int>();
                DataManager.playerData.p3items = new List<int>();
                break;
        }
        DataManager.SavePlayerData();
    }
}
