using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;

public class HealthAndManaManager : MonoBehaviour
{
    [Header("UI references")]
    public Image[] healthBars;
    public Image[] manaBars;

    public GameObject[] deathPanels;

    MainInputMapping inputMap;

    private float health;
    private float mana;

    private bool dead = false;

    [Header("Max values and recovery")]
    public float maxHealth = 100f;
    public float maxMana = 70f;
    public float healthRecoverPerSecond = 1.5f;
    public float manaRecoveryPerSecond = 0.6f;

    private void Start()
    {
        health = maxHealth;
        mana = maxMana;

        foreach (Image _bar in healthBars)
        {
            _bar.fillAmount = 1f;
        }

        foreach (Image _bar in manaBars)
        {
            _bar.fillAmount = 1f;
        }

        foreach (GameObject _panel in deathPanels)
        {
            _panel.SetActive(false);
        }
    }

    private void OnEnable()
    {
        inputMap = new MainInputMapping();
        inputMap.Enable();
        inputMap.MainGameInput.AButton.performed += RestartLevel;
        inputMap.MainGameInput.BackButton.performed += GoToOverworld;
    }

    private void OnDisable()
    {
        inputMap.MainGameInput.AButton.performed -= RestartLevel;
        inputMap.MainGameInput.BackButton.performed -= GoToOverworld;
        inputMap.Enable();
    }

    private void UpdateHealthBars()
    {
        foreach (Image _bar in healthBars)
        {
            _bar.fillAmount = health / maxHealth;
        }
    }

    private void UpdateManaBars()
    {
        foreach (Image _bar in manaBars)
        {
            _bar.fillAmount = mana / maxMana;
        }
    }

    public bool TakeHealth(float _amount)
    {
        health = Mathf.Max(0, health - _amount);
        UpdateHealthBars();
        if (health <= 0)
        {
            Die();
        }
        return health > 0f;
    }

    public bool TakeMana(float _amount)
    {
        if (mana - _amount > 0)
        {
            mana -= _amount;
            UpdateManaBars();
            return true;
        }
        else
        {
            return false;
        }
    }

    private void Update()
    {
        if (health < maxHealth)
        {
            health += healthRecoverPerSecond * Time.deltaTime;
            UpdateHealthBars();
        }

        if (mana < maxMana)
        {
            mana += manaRecoveryPerSecond * Time.deltaTime;
            UpdateManaBars();
        }
    }

    private void Die()
    {
        dead = true;
        foreach (GameObject _panel in deathPanels)
        {
            _panel.SetActive(true);
        }
    }

    private void RestartLevel(InputAction.CallbackContext _ctx)
    {
        if (!dead)
        {
            return;
        }
        Debug.Log("Death menu restart triggered");
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    private void GoToOverworld(InputAction.CallbackContext _ctx)
    {
        if (!dead)
        {
            return;
        }
        Debug.Log("Death menu go back triggered");
        SceneManager.LoadScene("Overworld");
    }

    public void RestartButton()
    {
        if (!dead)
        {
            return;
        }
        Debug.Log("Death menu restart triggered");
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    public void OverworldButton()
    {
        if (!dead)
        {
            return;
        }
        Debug.Log("Death menu go back triggered");
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }
}
