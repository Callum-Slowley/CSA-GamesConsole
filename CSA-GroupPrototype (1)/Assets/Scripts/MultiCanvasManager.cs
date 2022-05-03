using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

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

    private MainInputMapping inputMap;

    private void Start()
    {
        inputMap = new MainInputMapping();
        inputMap.Enable();

        //Map the inputs
        //Direction inputs
        inputMap.MainGameInput.DPAD_Up.performed += _ctx => MoveSelection(ButtonDirection.UP);
        inputMap.MainGameInput.DPAD_Down.performed += _ctx => MoveSelection(ButtonDirection.DOWN);
        inputMap.MainGameInput.DPAD_Left.performed += _ctx => MoveSelection(ButtonDirection.LEFT);
        inputMap.MainGameInput.DPAD_Right.performed += _ctx => MoveSelection(ButtonDirection.RIGHT);

        //Actions inputs
        inputMap.MainGameInput.AButton.performed += _ctx => InvokeButtonActions();

        //Set canvas up
        ResetCanvas();
    }

    public void ResetCanvas()
    {
        currentlySelectedButton = startingSelection;
        HighlightSelection();
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

    public void InvokeButtonActions()
    {
        if (!this.enabled) return;

        currentlySelectedButton.onClick.Invoke();
    }
}
