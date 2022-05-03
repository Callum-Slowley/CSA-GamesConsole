using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(Level_Generator_V2))]
public class Level_Generator_V2_CustomInspector : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        Level_Generator_V2 link = (Level_Generator_V2)target;

        if (GUILayout.Button("Generate New Map"))
        {
            link.GenerateMap();
        }

        if (GUILayout.Button("Clear box colliders"))
        {
            link.ClearColliders();
        }

        if (GUILayout.Button("Populate Map with Props"))
        {
            link.PopulateAllRoomsWithProps();
        }

        if (GUILayout.Button("Clear all Props"))
        {
            link.ClearAllRoomProps();
        }
    }
}
