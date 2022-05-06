using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class UISettings : MonoBehaviour
{
    public int selectedUI = 0;

    public GameObject smallUI;
    public GameObject largeUI;
    public GameObject simpleUI;

    public Image[] healthBars;
    public Image[] manaBars;
    public TMPro.TMP_Text[] scoreTexts;

    // Start is called before the first frame update
    void Start()
    {
        selectedUI = DataManager.optionsData.UIMode;

        switch (selectedUI)
        {
            case 0:
                smallUI.SetActive(true);
                largeUI.SetActive(false);
                simpleUI.SetActive(false);
                break;
            case 1:
                smallUI.SetActive(false);
                largeUI.SetActive(true);
                simpleUI.SetActive(false);
                break;
            case 2:
                smallUI.SetActive(false);
                largeUI.SetActive(false);
                simpleUI.SetActive(true);
                break;
            case 3:
                smallUI.SetActive(false);
                largeUI.SetActive(false);
                simpleUI.SetActive(false);
                break;
        }
    }

    public void ChangeHealth(float _amount)
    {
        healthBars[selectedUI].fillAmount = _amount;
    }

    public void ChangeMana(float _amount)
    {
        manaBars[selectedUI].fillAmount = _amount;
    }

    public void ChangeScore(float _amount)
    {
        scoreTexts[selectedUI].text = "Score: " + _amount;
    }
}
