using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public enum LevelType
{
    DUNGEON,
    VILLAGE,
    OVERWOLRD
}

public class OverworldTriggerZone : MonoBehaviour
{
    public SpriteRenderer indicatorIconSprite;
    public SpriteRenderer buttonPressSprite;
    public SpriteRenderer lockedSprite;

    public float crossfadeTime = 1f;

    public string playerTag;

    public LevelType lType;
    public int levelID;
    public LevelManager levelManager;

    public bool canBeLocked;
    private bool locked = false;

    MainInputMapping map = null;

    private bool playerInZone = false;

    private void Start()
    {
        Color tempCol = buttonPressSprite.color;
        tempCol.a = 0;
        buttonPressSprite.color = tempCol;
        tempCol = lockedSprite.color;
        tempCol.a = 0;
        lockedSprite.color = tempCol;

        switch (lType)
        {
            case LevelType.DUNGEON:
                locked = levelManager.CheckDungeonLocked(levelID);
                break;
            case LevelType.VILLAGE:
                locked = levelManager.CheckVillageLocked(levelID);
                break;
            default:
                break;
        }
    }

    private void OnEnable()
    {
        map = new MainInputMapping();
        map.Enable();

        map.MainGameInput.AButton.performed += TryOpenLevel;
    }

    private void OnDisable()
    {
        map.MainGameInput.AButton.performed -= TryOpenLevel;
        map.Disable();
    }

    private void TryOpenLevel(InputAction.CallbackContext _ctx)
    {
        if (!playerInZone)
        {
            return;
        }
        if (lType == LevelType.OVERWOLRD)
        {
            Debug.Log("Going to the overworld");
            SceneManager.LoadScene("Overworld");
        }
        else
        {
            if (!canBeLocked || !locked)
            {
                switch (lType)
                {
                    case LevelType.DUNGEON:
                        levelManager.TryLoadDungeon(levelID);
                        break;
                    case LevelType.VILLAGE:
                        levelManager.TryLoadVillage(levelID);
                        break;
                }
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == playerTag)
        {
            //Player entered the zone, fade to activate button and start waiting for button press
            playerInZone = true;

            if (canBeLocked && locked)
            {
                Color lockedCol = lockedSprite.color;
                lockedCol.a = 1;
                buttonPressSprite.color = lockedCol;
            }
            else
            {
                Color buttonCol = buttonPressSprite.color;
                buttonCol.a = 1;
                buttonPressSprite.color = buttonCol;
            }

            Color tempCol = indicatorIconSprite.color;
            tempCol.a = 0;
            indicatorIconSprite.color = tempCol;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == playerTag)
        {
            //Player exited the zone, fade to the indicator and stop waiting
            playerInZone = false;

            if (canBeLocked && locked)
            {
                Color lockedCol = lockedSprite.color;
                lockedCol.a = 0;
                buttonPressSprite.color = lockedCol;
            }
            else
            {
                Color buttonCol = buttonPressSprite.color;
                buttonCol.a = 0;
                buttonPressSprite.color = buttonCol;
            }

            Color tempCol = indicatorIconSprite.color;
            tempCol.a = 1;
            indicatorIconSprite.color = tempCol;
        }
    }
}
