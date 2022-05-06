using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;

public enum ButtonDirection
{
    UP,
    DOWN,
    LEFT,
    RIGHT
}

[System.Serializable]
public struct ButtonDirectionMap
{
    public int subMenuID;
    public ButtonDirection buttonDirection;
    public Button targetButton;

    ButtonDirectionMap(int _subMenuID, ButtonDirection _dir, Button _butt)
    {
        subMenuID = _subMenuID;
        buttonDirection = _dir;
        targetButton = _butt;
    }
}

[System.Serializable]
public struct ButtonNavMapping
{
    public Button thisButton;
    public List<ButtonDirectionMap> directionalMappings;

    ButtonNavMapping(Button _butt, List<ButtonDirectionMap> _mappings)
    {
        thisButton = _butt;
        directionalMappings = _mappings;
    }
}

public class MultiCanvasManager : MonoBehaviour
{
    public Button startingSelection;
    public Button currentlySelectedButton;

    public Color normalButtonTint;
    public Color highlightedButtonTint;

    public bool supportSubMenus = false;
    public SubMenuManager subManager;

    public List<ButtonNavMapping> buttonNavigationalMappings = new List<ButtonNavMapping>();

    MainInputMapping inputMap = null;

    private void Start()
    {
        //Set canvas up
        ResetCanvas();
    }

    private void OnEnable()
    {
        inputMap = new MainInputMapping();
        inputMap.Enable();

        //Map the inputs
        //Direction inputs
        inputMap.MainGameInput.DPAD_Up.performed += MoveUp;
        inputMap.MainGameInput.DPAD_Down.performed += MoveDown;
        inputMap.MainGameInput.DPAD_Left.performed += MoveLeft;
        inputMap.MainGameInput.DPAD_Right.performed += MoveRight;

        //Actions inputs
        inputMap.MainGameInput.AButton.performed += InvokeButtonActions;

    }

    private void OnDisable()
    {
        //Unsubsribe from all input actions
        //Direction inputs
        inputMap.MainGameInput.DPAD_Up.performed -= MoveUp;
        inputMap.MainGameInput.DPAD_Down.performed -= MoveDown;
        inputMap.MainGameInput.DPAD_Left.performed -= MoveLeft;
        inputMap.MainGameInput.DPAD_Right.performed -= MoveRight;

        //Actions inputs
        inputMap.MainGameInput.AButton.performed -= InvokeButtonActions;

        inputMap.Disable();
    }

    public void ResetCanvas()
    {
        currentlySelectedButton = startingSelection;
        HighlightSelection();
    }

    private void MoveUp(InputAction.CallbackContext _ctx)
    {
        MoveSelection(ButtonDirection.UP);
    }

    private void MoveDown(InputAction.CallbackContext _ctx)
    {
        MoveSelection(ButtonDirection.DOWN);
    }

    private void MoveLeft(InputAction.CallbackContext _ctx)
    {
        MoveSelection(ButtonDirection.LEFT);
    }

    private void MoveRight(InputAction.CallbackContext _ctx)
    {
        MoveSelection(ButtonDirection.RIGHT);
    }

    public void MoveSelection(ButtonDirection _dir)
    {
        if (!this.enabled) return;

        Button target = FindTargetButton(_dir);
        Debug.Log("Looking for the button");

        if (target != null)
        {
            Debug.Log("Found the button");
            DehighlightSelection();
            currentlySelectedButton = target;
            HighlightSelection();
        }
    }

    private Button FindTargetButton(ButtonDirection _dir)
    {
        foreach(ButtonNavMapping _butt in buttonNavigationalMappings)
        {
            if (_butt.thisButton == currentlySelectedButton)
            {
                if (!supportSubMenus)
                {
                    //Found the right button
                    foreach (ButtonDirectionMap _buttDirMap in _butt.directionalMappings)
                    {
                        if (_buttDirMap.buttonDirection == _dir)
                        {
                            return _buttDirMap.targetButton;
                        }
                    }
                }
                else
                {
                    //Found the right button
                    foreach (ButtonDirectionMap _buttDirMap in _butt.directionalMappings)
                    {
                        if (_buttDirMap.buttonDirection == _dir && (_buttDirMap.subMenuID == -1 || _buttDirMap.subMenuID == subManager.GetCurrentSubMenuID()))
                        {
                            return _buttDirMap.targetButton;
                        }
                    }
                }
            }
        }
        return null;
    }

    public void DehighlightSelection()
    {
        currentlySelectedButton.image.color = normalButtonTint;
    }

    public void HighlightSelection()
    {
        currentlySelectedButton.image.color = highlightedButtonTint;
    }

    public void InvokeButtonActions(InputAction.CallbackContext _ctx)
    {
        if (!this.enabled) return;

        currentlySelectedButton.onClick.Invoke();
    }
}
