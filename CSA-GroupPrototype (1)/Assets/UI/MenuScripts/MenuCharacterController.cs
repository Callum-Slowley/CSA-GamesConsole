using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class MenuCharacterController : MonoBehaviour
{
    public float playerMoveSpeed = 2f;

    public Camera cam;
    public Quaternion camY;

    private Vector3 playerMoveInput = Vector3.zero;
    private float inputSqrMagnitude;
    private MainInputMapping inputMap;

    private void Start()
    {
        if (cam == null)
        {
            cam = Camera.main;
        }

        inputMap = new MainInputMapping();
        inputMap.Enable();
    }

    private void Update()
    {
        ReadInput();
        TurnStep();
        MoveStep();
    }

    void MoveStep()
    {
        inputSqrMagnitude = playerMoveInput.sqrMagnitude;

        if (inputSqrMagnitude >= 0.01f)
        {
            Vector3 newPosition = transform.position + playerMoveInput * Time.deltaTime * playerMoveSpeed;
            NavMeshHit hit;
            bool isValid = NavMesh.SamplePosition(newPosition, out hit, 0.3f, NavMesh.AllAreas);

            if (isValid)
            {
                transform.position = hit.position;
            }
        }
    }

    void TurnStep()
    {
        transform.LookAt(transform.position + playerMoveInput, Vector3.up);
    }

    void ReadInput()
    {
        Vector2 stickInput = inputMap.MainGameInput.Move.ReadValue<Vector2>();
        playerMoveInput.x = stickInput.x;
        playerMoveInput.z = stickInput.y;

        camY = Quaternion.Euler(new Vector3(0, cam.transform.eulerAngles.y, 0));
        playerMoveInput = camY * playerMoveInput;
    }
}
