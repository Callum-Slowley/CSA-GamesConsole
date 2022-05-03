using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Movement_V3 : MonoBehaviour
{
    [Header("Component references")]
    public CharacterController controller;
    public Camera cam;
    public GameObject aimThing;
    public GameObject facingThing;
    public GameObject playerGFX;
    public float movespeed = 0.5f;
    public float Gravity = 9.81f;
    public GameObject projectile;
    public Shooting shooting;

    //Private variables
    private MainInputMapping input;
    private float vSpeed;
    private Vector2 aimInput;

    private void Start()
    {
        input = new MainInputMapping();
        input.Enable();

        input.MainGameInput.Shoot.performed += Shoot;
    }

    void MoveCharacter()
    {
        Vector2 moveInput = input.MainGameInput.Move.ReadValue<Vector2>();
        aimInput = input.MainGameInput.AimMove.ReadValue<Vector2>()*100;
        Quaternion camYRot = Quaternion.Euler(0, cam.transform.eulerAngles.y, 0);

        Vector3 moveDir = camYRot * new Vector3(moveInput.x, 0, moveInput.y);
        Vector3 aimDir = camYRot * new Vector3(aimInput.x/100, 0, aimInput.y/100);
        
        facingThing.transform.localPosition = new Vector3(moveDir.x, moveDir.y, moveDir.z);
        aimThing.transform.localPosition = new Vector3(aimDir.x, aimDir.y, aimDir.z);
        Vector3 facing = aimThing.transform.position - playerGFX.transform.position;
        aimThing.transform.LookAt(aimThing.transform.position + facing.normalized);
        playerGFX.transform.LookAt(facingThing.transform.position + facing.normalized);
        playerGFX.transform.LookAt(aimThing.transform.position + facing.normalized);
        controller.Move(moveDir * Time.deltaTime * movespeed);
        controller.Move(Vector3.down * Time.deltaTime * Gravity);
        


    }

    void Shoot(InputAction.CallbackContext _ctx)
    {
        //Debug.Log("Shot!");
        //Rigidbody instantiatedRB = Instantiate(projectile, aimThing.transform.position, aimThing.transform.rotation).GetComponent<Rigidbody>();
        //instantiatedRB.AddForce(Vector3.forward * 1000);
        if(aimInput != Vector2.zero)
        {
            shooting.FireSpell();
        }
        
    }

    private void LateUpdate()
    {
        MoveCharacter();
    }
}
