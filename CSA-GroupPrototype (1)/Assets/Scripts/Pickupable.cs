using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//This is placed on the object that we want to pick up
[RequireComponent(typeof(Rigidbody))]
public class Pickupable : MonoBehaviour
{

    //Rigid body used to set the gravity of the object
    private Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        //Setting the rigigd body
        rb = GetComponent<Rigidbody>();

    }


    //this object is being held
    public void setPickedUp( Transform holder)
    {
        //gravity is set to false then the object wont collide with any other objects
        rb.useGravity = false;
        rb.isKinematic = true;
        //object is moved to the hold desitination then set as a child of the parent
        this.transform.parent = holder;
    }  
    //this object is no longer being held
    public void Dropped()
    {
        //has gravity and can collide with other objects again 
        rb.useGravity = true;
        rb.isKinematic = false;
        //No longer has a parent
        this.transform.parent = null;
    }
}
