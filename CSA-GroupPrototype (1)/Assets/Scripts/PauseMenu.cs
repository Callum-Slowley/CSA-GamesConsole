using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class PauseMenu : MonoBehaviour
{
    MainInputMapping inputMapping;
    public GameObject[] pauseUIPanels;
    bool isPaused = false;
    public bool isDungeon = true;

    private void OnEnable()
    {
        ClosePauseMenuButton();
        inputMapping = new MainInputMapping();
        inputMapping.Enable();
        inputMapping.MainGameInput.PauseGame.performed += OpenPauseMenu;
        inputMapping.MainGameInput.AButton.performed += GoBack;
        inputMapping.MainGameInput.BackButton.performed += ClosePauseMenu;
    }

    private void OnDisable()
    {
        inputMapping.MainGameInput.PauseGame.performed -= OpenPauseMenu;
        inputMapping.MainGameInput.AButton.performed -= GoBack;
        inputMapping.MainGameInput.BackButton.performed -= ClosePauseMenu;
        inputMapping.Enable();
    }

    public void OpenPauseMenu(InputAction.CallbackContext _ctx)
    {
        isPaused = !isPaused;
        foreach (GameObject _panel in pauseUIPanels)
        {
            _panel.SetActive(isPaused);
        }
    }

    public void ClosePauseMenu(InputAction.CallbackContext _ctx)
    {
        if (isPaused)
        {
            isPaused = false;
            foreach (GameObject _panel in pauseUIPanels)
            {
                _panel.SetActive(isPaused);
            }
        }
    }

    public void ClosePauseMenuButton()
    {
        isPaused = false;
        foreach (GameObject _panel in pauseUIPanels)
        {
            _panel.SetActive(isPaused);
        }
    }

    public void GoBack(InputAction.CallbackContext _ctx)
    {
        if (isPaused)
        {
            Debug.Log("Pause menu go back triggered");
            if (isDungeon)
            {
                SceneManager.LoadScene("Overworld");
            }
            else
            {
                SceneManager.LoadScene("MainMenu");
            }
        }
    }

    public void GoBackButton()
    {
        Debug.Log("Pause menu go back triggered");
        if (isDungeon)
        {
            SceneManager.LoadScene("Overworld");
        }
        else
        {
            SceneManager.LoadScene("MainMenu");
        }
    }
}
