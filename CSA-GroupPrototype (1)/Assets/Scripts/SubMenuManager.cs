using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SubMenuManager : MonoBehaviour
{
    [Header("Submenu panels")]
    public GameObject[] panels;

    public void SwitchToPanel(int _index)
    {
        DeactivateAllPanels();
        panels[_index].SetActive(true);
    }

    private void DeactivateAllPanels()
    {
        foreach (GameObject _o in panels)
        {
            _o.SetActive(false);
        }
    }

    public int GetCurrentSubMenuID()
    {
        int id = 0;
        foreach (GameObject _panel in panels)
        {
            if (_panel.activeSelf)
            {
                return id;
            }
            id++;
        }
        return -1;
    }
}
