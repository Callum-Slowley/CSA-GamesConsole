using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EditorModeCheck : MonoBehaviour
{
    public string searchFor;
    public GameObject dataManager;

    // Start is called before the first frame update
    void Start()
    {
#if UNITY_EDITOR
        if (GameObject.Find(searchFor) == null)
        {
            //The persistent data manager does not exist, create it
            Instantiate(dataManager, Vector3.zero, Quaternion.identity);
        }
#endif
    }
}
