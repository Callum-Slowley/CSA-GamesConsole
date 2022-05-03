using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public struct SpawnPoint{
    public Transform position;
    public GameObject[] objects;
}

public class Room_Populator : MonoBehaviour
{
    [Header("Spawn points and prop collections")]
    [Tooltip("These will be the potential spawn points for the room's props")]
    public SpawnPoint[] spawnPoints;

    [Header("Spawning values")]
    [Tooltip("The chance of spawning a prop in any given spawnPoint")]
    [Range(0, 1)]
    public float spawnChance = 0.5f;

    [Tooltip("How far the objects can be rotated either way on the y axis to add interesting angle")]
    [Range(0, 179)]
    public float maxAngleOffset = 30f;

    //Private variables
    List<GameObject> propsInRoom = new List<GameObject>();

    public void SpawnProps()
    {
        //Go through all of the spawn locations in the room
        foreach(SpawnPoint _p in spawnPoints)
        {
            if(Random.Range(0f, 1f) <= spawnChance)
            {
                //The spawn chance has passed we need to spawn a prop in this location
                //First we need to just spawn it and set its position to the spawn point's position
                GameObject newProp = Instantiate(_p.objects[Random.Range(0, _p.objects.Length)], _p.position.position, _p.position.rotation);
                Quaternion randomYRotation = Quaternion.Euler(0, (Random.Range(-1f, 1f) * maxAngleOffset), 0);
                newProp.transform.rotation = randomYRotation;
                propsInRoom.Add(newProp);
            }
        }
    }

    public void ClearRoomProps()
    {
        //Destroy all of the objects in the propsInRoom list, then clear the list
        foreach(GameObject _g in propsInRoom)
        {
            DestroyImmediate(_g);
        }
        propsInRoom.Clear();
    }
}
