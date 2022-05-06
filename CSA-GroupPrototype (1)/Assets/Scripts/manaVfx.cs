using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.VFX;

public class manaVfx : MonoBehaviour
{
    public VisualEffect manaEffect;
    [SerializeField, Range(0, 10)]
    public float particleAmount;
    // Update is called once per frame
    void Update()
    {
        manaEffect.SetFloat("particleAmount", particleAmount);
    }
}
