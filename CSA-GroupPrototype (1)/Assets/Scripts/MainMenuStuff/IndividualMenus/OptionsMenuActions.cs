using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OptionsMenuActions : MonoBehaviour
{
    public void SetSwitchResolution(int _res)
    {
        switch (_res)
        {
            case 0:
                Debug.Log($"Setting resolution to 1024x576");
                Screen.SetResolution(1024, 576, FullScreenMode.ExclusiveFullScreen, 60);
                DataManager.optionsData.resWidth = 1024;
                DataManager.optionsData.resHeight = 576;
                break;
            case 1:
                Debug.Log($"Setting resolution to 1152x648");
                Screen.SetResolution(1152, 648, FullScreenMode.ExclusiveFullScreen, 60);
                DataManager.optionsData.resWidth = 1152;
                DataManager.optionsData.resHeight = 648;
                break;
            case 2:
                Debug.Log($"Setting resolution to 1280x720");
                Screen.SetResolution(1280, 720, FullScreenMode.ExclusiveFullScreen, 60);
                DataManager.optionsData.resWidth = 1280;
                DataManager.optionsData.resHeight = 720;
                break;
            case 3:
                Debug.Log($"Setting resolution to 1920x1080");
                Screen.SetResolution(1920, 1080, FullScreenMode.ExclusiveFullScreen, 60);
                DataManager.optionsData.resWidth = 1920;
                DataManager.optionsData.resHeight = 1080;
                break;
        }
    }

    public void LoadVSync()
    {
        SetSwitchFramerate(DataManager.optionsData.vSync);
    }

    public void SetSwitchFramerate(bool _vSync)
    {
        if (_vSync)
        {
            //Set to 30FPS
            Debug.Log("Setting framerate to 30 by turning on vSync");
            DataManager.optionsData.vSync = true;
            QualitySettings.vSyncCount = 2;
        }
        else
        {
            //Set to 60FPS
            Debug.Log("Setting framerate to 60 by turning off vSync (sort of...)");
            DataManager.optionsData.vSync = false;
            QualitySettings.vSyncCount = 1;
        }
    }

    public void ChangeSwitchUIStyle(int _style)
    {
       switch (_style)
        {
            case 0:
                Debug.Log("Setting UI style to Small");
                DataManager.optionsData.UIMode = 0;
                break;
            case 1:
                Debug.Log("Setting UI style to Large");
                DataManager.optionsData.UIMode = 1;
                break;
            case 2:
                Debug.Log("Setting UI style to Simple");
                DataManager.optionsData.UIMode = 2;
                break;
            case 3:
                Debug.Log("Setting UI style to Off");
                DataManager.optionsData.UIMode = 3;
                break;
        }
    }

    public void ChangeSwitchControlLayout(int _style)
    {
        if (_style == 0)
        {
            Debug.Log("Setting control style to 1");
        }
        else if (_style == 1)
        {
            Debug.Log("Setting control style to 2");
        }
    }

    public void CycleSwitchStickSensitivity()
    {
        Debug.Log("Changing stick sensitivity");
    }
}
