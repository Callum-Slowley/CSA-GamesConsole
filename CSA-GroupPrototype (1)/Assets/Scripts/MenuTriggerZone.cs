using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public enum MenuConnection
{
    SAVES,
    OPTIONS,
    QUIT,
    PLAY
}

public class MenuTriggerZone : MonoBehaviour
{
    public SpriteRenderer indicatorIconSprite;
    public SpriteRenderer buttonPressSprite;

    public float crossfadeTime = 1f;

    public string playerTag;

    public MenuManager manager;

    public MenuConnection connectedMenu;

    private MainInputMapping map;

    private bool playerInZone = false;

    private void Start()
    {
        map = new MainInputMapping();
        map.Enable();

        map.MainGameInput.AButton.performed += TryActivateMenu;

        Color tempCol = buttonPressSprite.color;
        tempCol.a = 0;
        buttonPressSprite.color = tempCol;
    }

    private void TryActivateMenu(InputAction.CallbackContext _ctx)
    {
        if (!playerInZone)
        {
            return;
        }
        else
        {
            switch (connectedMenu)
            {
                case MenuConnection.SAVES:
                    manager.OpenSavesMenu();
                    break;
                case MenuConnection.OPTIONS:
                    manager.OpenOptionsMenu();
                    break;
                case MenuConnection.QUIT:
                    manager.OpenQuitMenu();
                    break;
                case MenuConnection.PLAY:
                    manager.StartGameLevel();
                    break;
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == playerTag)
        {
            //Player entered the zone, fade to activate button and start waiting for button press
            playerInZone = true;

            Color tempCol = buttonPressSprite.color;
            tempCol.a = 1;
            buttonPressSprite.color = tempCol;

            tempCol = indicatorIconSprite.color;
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

            Color tempCol = buttonPressSprite.color;
            tempCol.a = 0;
            buttonPressSprite.color = tempCol;

            tempCol = indicatorIconSprite.color;
            tempCol.a = 1;
            indicatorIconSprite.color = tempCol;
        }
    }
}
