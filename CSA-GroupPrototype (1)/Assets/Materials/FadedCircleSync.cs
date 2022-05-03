using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FadedCircleSync : MonoBehaviour
{
    public static int posID = Shader.PropertyToID("_PositionPlayer");
    public static int sizeID = Shader.PropertyToID("_Size");

    public Material[] materialsAffected;
    public Camera cam;
    public LayerMask mask;

    // Update is called once per frame
    void Update()
    {
        Vector3 direction = cam.transform.position - transform.position;
        Ray ray = new Ray(transform.position, direction.normalized);
        
        if (Physics.Raycast(ray, 3000, mask))
        {
            foreach (Material _m in materialsAffected)
            {
                _m.SetFloat(sizeID, 1f);
            }
        }
        else
        {
            foreach (Material _m in materialsAffected)
            {
                _m.SetFloat(sizeID, 1f);
            }
        }

        Vector3 view = cam.WorldToViewportPoint(transform.position);

        foreach (Material _m in materialsAffected)
        {
            _m.SetVector(posID, view);
        }
    }
}
