using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using TMPro;

public class DebugInputUI : MonoBehaviour
{
    //Public Variables
    public TMP_Text Text;

    //Private variables
    private MainInputMapping input;
    private float vSpeed;

    // Start is called before the first frame update
    void Start()
    {
        input = new MainInputMapping();
        input.Enable();
    }

    // Update is called once per frame
    void Update()
    {
        Vector2 MoveValue = input.MainGameInput.Move.ReadValue<Vector2>();
        Vector2 CamValue = input.MainGameInput.CamMove.ReadValue<Vector2>();

        Text.text = ("Move Value: " + MoveValue + 
                     "\n Cam Value: " + CamValue);
    }
}
