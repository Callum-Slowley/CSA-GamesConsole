using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(HealthAndManaManager))]
public class HeathAndManaInspector : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        HealthAndManaManager script = (HealthAndManaManager)target;

        if (GUILayout.Button("Take 10 Health"))
        {
            script.TakeHealth(10f);
        }

        if (GUILayout.Button("Take 10 Mana"))
        {
            script.TakeMana(10f);
        }
    }
}
