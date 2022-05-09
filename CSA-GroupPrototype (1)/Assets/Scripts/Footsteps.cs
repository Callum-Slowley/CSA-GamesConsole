using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMODUnity;

public class Footsteps : MonoBehaviour
{
    public StudioEventEmitter Emitter;

    public void Start(){
        Emitter = GetComponent<StudioEventEmitter>();
    }

    public void Footstep(){
        Emitter.Play();
    }
}
