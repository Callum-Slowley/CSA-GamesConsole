using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuManager : MonoBehaviour
{
    [Header("Camera")]
    public Camera camera;

    [Header("Camera transforms")]
    public Transform mainTransform;
    public Transform saveTransform;
    public Transform optionsTransform;
    public Transform quitTransform;

    [Header("Camera Movement")]
    public float transitionTime = 2f;

    [Header("UI components")]
    public GameObject savesCanvas;
    public GameObject optionsCanvas;
    public GameObject quitCanvas;

    public GameObject saveBubble;
    public GameObject optionsBubble;
    public GameObject quitBubble;

    [Header("MultiCanvasManagers")]
    public MultiCanvasManager saveMenuManager;
    public MultiCanvasManager optionsMenuManager;
    public MultiCanvasManager quitMenuManager;

    [Header("Scene loading stuff")]
    public string gameLevelName;

    float coolDown = 0f;
    MainInputMapping inputMap;

    //Methods
    private void Start()
    {
        DOTween.Init();
        //If the camera is null try to get the main camera
        if (camera == null)
        {
            camera = Camera.main;
        }

        //If the transforms are null, throw a warning
        if (mainTransform == null || saveTransform == null || optionsTransform == null || quitTransform == null)
        {
            Debug.LogWarning("One or more camera transforms are not set, this will cause breakages");
        }

        //Also check for the canvases that are needed for the menu
        if (savesCanvas == null || optionsCanvas == null || quitCanvas == null)
        {
            Debug.LogWarning("One or more canvases are not set, this will cause breakages");
        }

        savesCanvas.SetActive(false);
        optionsCanvas.SetActive(false);
        quitCanvas.SetActive(false);

        saveMenuManager.enabled = false;
        optionsMenuManager.enabled = false;
        quitMenuManager.enabled = false;

        //Map the inputs
        inputMap = new MainInputMapping();
        inputMap.Enable();
        inputMap.MainGameInput.BackButton.performed += _ctx => GoBackToMain();
    }

    public void ChangeBubbleVisibility(bool _flag)
    {
        saveBubble.SetActive(_flag);
        optionsBubble.SetActive(_flag);
        quitBubble.SetActive(_flag);
    }

    public void OpenSavesMenu()
    {
        coolDown = 0.5f;
        //Enable the canvas for that menu
        savesCanvas.SetActive(true);
        camera.transform.DOMove(saveTransform.position, transitionTime);
        camera.transform.DORotate(saveTransform.rotation.eulerAngles, transitionTime);
        ChangeBubbleVisibility(false);

        saveMenuManager.enabled = true;
    }

    public void OpenOptionsMenu()
    {
        coolDown = 0.5f;
        //Enable the canvas for that menu
        optionsCanvas.SetActive(true);
        camera.transform.DOMove(optionsTransform.position, transitionTime);
        camera.transform.DORotate(optionsTransform.rotation.eulerAngles, transitionTime);
        ChangeBubbleVisibility(false);

        optionsMenuManager.enabled = true;
    }

    public void OpenQuitMenu()
    {
        coolDown = 0.5f;
        //Enable the canvas for that menu
        quitCanvas.SetActive(true);
        camera.transform.DOMove(quitTransform.position, transitionTime);
        camera.transform.DORotate(quitTransform.rotation.eulerAngles, transitionTime);
        ChangeBubbleVisibility(false);

        quitMenuManager.enabled = true;
    }

    public void GoBackToMain()
    {
        if (coolDown > 0f)
        {
            return;
        }
        Debug.Log("Going back");
        //Find which canvas was open
        if (savesCanvas.activeSelf)
        {
            //Saves canvas was open
            Debug.Log("Closing the saves menu...");
            savesCanvas.SetActive(false);
            //Need to do stuff to do with player saves
        }
        else if (optionsCanvas.activeSelf)
        {
            //Options canvas open
            Debug.Log("Closing the options menu...");
            optionsCanvas.SetActive(false);
            //Save any changes to the disk
            DataManager.SaveOptionsData();
        }
        else if (quitCanvas.activeSelf)
        {
            //Quit canvas open
            Debug.Log("Closing the quit menu...");
            quitCanvas.SetActive(false);
        }
        camera.transform.DOMove(mainTransform.position, transitionTime);
        camera.transform.DORotate(mainTransform.rotation.eulerAngles, transitionTime);
        ChangeBubbleVisibility(true);

        saveMenuManager.enabled = false;
        optionsMenuManager.enabled = false;
        quitMenuManager.enabled = false;
    }

    public void StartGameLevel()
    {
        SceneManager.LoadScene(gameLevelName);
    }

    public void Update()
    {
        if (coolDown > 0f)
        {
            coolDown -= Time.deltaTime;
        }
    }
}
