using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Pickup : MonoBehaviour
{
    //pos where the player will hold it
    public GameObject holdPos;
    //Length allowing pickup
    public float pickupLength = 1.5f;
    //allowing the input system controlls
    MainInputMapping controls;
    //bool used to check if we are holding an object or not
    public bool isHolding;
    // Start is called before the first frame update
    void Awake()
    {
        //start of by holding nothing
        isHolding = false;
        //referace to the character controls
        controls = new MainInputMapping();

        controls.Enable();
        //actions if the Y button is pressed
        controls.MainGameInput.YButton.performed += CheckForPickup;
    }

    // Update is called once per frame
    void Update()
    {
        //used for debug purposes a ray is shooting forwards from where the player is looking
        Debug.DrawRay(transform.position, transform.TransformDirection(Vector3.forward) * pickupLength, Color.green);
    }

    //this script runs when the right button is pressed
    void CheckForPickup(InputAction.CallbackContext _ctx)
    {
        //Send out a raycast
        RaycastHit hit;
        //sending out the raycast with the same parameters as the one in the debug
        if (Physics.Raycast(transform.position, transform.TransformDirection(Vector3.forward), out hit, pickupLength))
        {
            //If we are holding an object
            if (isHolding)
            {
                //this object
                if (hit.transform.GetComponent<Pickupable>())
                {
                    //drop the object
                    hit.transform.gameObject.GetComponent<Pickupable>().Dropped();
                    //no longer holding anything
                    isHolding = false;
                }
            }

            //if we arent holding an object
            else if (!isHolding)
            {
                //if we target an object we can pick up
                if (hit.transform.gameObject.GetComponent<Pickupable>())
                {
                    Debug.Log("pickup");
                    //pickup
                    hit.transform.gameObject.GetComponent<Pickupable>().setPickedUp(holdPos.transform);
                    //now holding an object
                    isHolding = true;
                }
            }
        }
    }
}
