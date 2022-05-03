using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Movement_V2 : MonoBehaviour
{
    [Header("Component references")]
    public CharacterController controller;
    public Camera cam;
    public float movespeed = 0.5f;
    public float Gravity = 9.81f;

    //Private variables
    private MainInputMapping input;
    private float vSpeed;

    private void Start()
    {
        input = new MainInputMapping();
        input.Enable();
    }

    void MoveCharacter()
    {
        Vector2 moveInput = input.MainGameInput.Move.ReadValue<Vector2>();
        Quaternion camYRot = Quaternion.Euler(0, cam.transform.eulerAngles.y, 0);

        Vector3 moveDir = camYRot * new Vector3(moveInput.x, 0, moveInput.y);
        moveDir *= movespeed;

        if (!controller.isGrounded)
        {
            moveDir.y -= Physics.gravity.y * Time.deltaTime;
        }
        else
        {
            moveDir.y = 0;
        }

        controller.Move(moveDir * Time.deltaTime);
    }

    private void LateUpdate()
    {
        MoveCharacter();
    }
}
