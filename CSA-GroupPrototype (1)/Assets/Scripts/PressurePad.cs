using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//When adding this script to a pressurePad make sure you set its collider to is trigger
public class PressurePad : MonoBehaviour
{
    public bool padActivated = false;

    //when object is on the pad is active 
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.GetComponent<Pickupable>())
        {
            padActivated = true;
        }
    }
    //when the object is removed its no longer active
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.GetComponent<Pickupable>())
        {
            padActivated = false;
        }
    }

}
