using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class movement : MonoBehaviour
{
    public float movespeed = 0.5f;
    public CharacterController Char;
    public Camera Cam;
    public float Gravity = 9.81f;
    float vSpeed;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //Char.Move(new Vector3(Input.GetAxis("Horizontal") * movespeed, 0, Input.GetAxis("Vertical") * movespeed));
        GameObject movementCamera = Cam.gameObject;

        float xMagnitude =Input.GetAxis("Horizontal");
        float zMagnitude = -Input.GetAxis("Vertical");

        Vector3 newMovement = new Vector3(movementCamera.transform.forward.x, 0, movementCamera.transform.forward.z) * -zMagnitude +
                              new Vector3(movementCamera.transform.right.x, 0, movementCamera.transform.right.z) * xMagnitude;

        vSpeed -= Gravity * Time.deltaTime;

        if (Char.isGrounded)
        {
            vSpeed = 0; // grounded character has vSpeed = 0
        }

        newMovement.y = vSpeed;

        Char.Move(newMovement.normalized * Time.deltaTime * movespeed);
    }
}
