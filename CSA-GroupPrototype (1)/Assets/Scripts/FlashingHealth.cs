using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlashingHealth : MonoBehaviour
{
    public bool isDmged;
    public Material tintMat;
    public float tintAmount;
    public float flashMultipler = 2f;

    // Update is called once per frame
    void Update()
    {
        if(isDmged){
            tintAmount -= flashMultipler * Time.deltaTime;
            tintMat.SetFloat("_tintAmount", tintAmount);
            if(tintAmount <= 0)
            {
                tintAmount = 1f;
            }
        }
        else
        {
            tintAmount =0;
            tintMat.SetFloat("_tintAmount", tintAmount);
        }
    }
}
