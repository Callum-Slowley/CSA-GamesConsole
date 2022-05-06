using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Level_Generator_V2 : MonoBehaviour
{
    [Header("Single type prefabs")]
    //Rooms that must be spawned in the world at specific points
    public GameObject startRoom;
    public GameObject endRoom;
    public GameObject blocker;

    [Header("Transient rooms")]
    //The collections of rooms that can be spawned
    public GameObject[] rooms;
    public GameObject[] corridors;
    public GameObject[] stairs;
    public GameObject[] lrgRooms;

    [Header("Generation Rules")]
    [Tooltip("Max number of rooms / corridors that can be spawned")]
    [Range(10, 50)]
    public int maxRooms = 10;

    [Header("Probability scales")]
    [Header("Room Type")]

    [Tooltip("The chance of spawning a block room")]
    [Range(0, 1)]
    public float blockRoomChance;

    [Tooltip("The chance of spawning a corridor instead of a small room")]
    [Range(0, 1)]
    public float corridorChance;

    [Tooltip("The chance of spawning a set of stairs instead of a small room")]
    [Range(0, 1)]
    public float stairChance;

    [Tooltip("The chance of spawning a large room instead of a small room")]
    [Range(0, 1)]
    public float lrgRoomChance;

    //Private generation data
    private float chanceMaxVal;
    private bool noSpawnStairs;
    private List<Transform> tempPointsBuffer = new List<Transform>();
    private List<Transform> openPoints = new List<Transform>();
    private List<Bounds> lastRoomBounds = new List<Bounds>();
    private List<BoxCollider> collidersToDestroy = new List<BoxCollider>();
    private List<Room_Populator> roomPopulators = new List<Room_Populator>();


    public void PopulateAllRoomsWithProps()
    {
        //Go through each room that can have props and trigger their function to self populate
        foreach(Room_Populator _room in roomPopulators)
        {
            _room.SpawnProps();
        }
    }

    public void ClearAllRoomProps()
    {
        //Tell all rooms to destroy props
        foreach(Room_Populator _room in roomPopulators)
        {
            _room.ClearRoomProps();
        }
    }

    private void PopulateTempBufferWithPoints(GameObject _room)
    {
        //Get all of the attach points on the room
        tempPointsBuffer.Clear();
        foreach(Transform _p in _room.GetComponentsInChildren<Transform>())
        {
            if(_p.gameObject.tag == "EntrancePoint")
            {
                tempPointsBuffer.Add(_p);
            }
        }
    }

    void MovetempBufferToOpenPoints()
    {
        //Move the unused temp buffer entrance point to the open points collection for later
        foreach(Transform _p in tempPointsBuffer)
        {
            openPoints.Add(_p);
        }
    }

    bool CheckNewRoomBounds(Bounds _b)
    {
        //Returns false if not colliding with another room
        foreach(Bounds _eB in lastRoomBounds)
        {
            if (_eB.Intersects(_b))
            {
                Debug.Log($"{_eB} is colliding with {_b}");
                return true;
            }
        }
        return false;
    }

    void ClearData()
    {
        //Clear all rooms from scene and the variables that were created to generate that scene
        ClearAllRoomProps();
        tempPointsBuffer.Clear();
        openPoints.Clear();
        lastRoomBounds.Clear();
        collidersToDestroy.Clear();
        roomPopulators.Clear();
        foreach (GameObject _g in GameObject.FindGameObjectsWithTag("Proc_Gen_Room"))
        {
            DestroyImmediate(_g);
        }
    }

    //Clear the generation colliders for the rooms to be ready for play
    public void ClearColliders(){
        foreach(BoxCollider _coll in collidersToDestroy){
            DestroyImmediate(_coll);
        }
    }

    GameObject SelectNewRoomType()
    {
        //First pick what type of room to spawn
        float roomType = Random.Range(0f, chanceMaxVal);
        if(roomType < blockRoomChance)
        {
            //Block room
            return rooms[Random.Range(0, rooms.Length)];
        }
        else if (roomType < blockRoomChance + corridorChance)
        {
            //Corridor
            return corridors[Random.Range(0, corridors.Length)];
        }
        else if (roomType < blockRoomChance + corridorChance + stairChance)
        {
            //Stairs
            if (noSpawnStairs == false)
            {
                return stairs[Random.Range(0, stairs.Length)];
                noSpawnStairs = true;
            }
            else
            {
                return rooms[Random.Range(0, lrgRooms.Length)];
                noSpawnStairs = false;
            }
        }
        else
        {
            //Large room
            return lrgRooms[Random.Range(0, lrgRooms.Length)];
        }
    }

    public void GenerateMap()
    {
        ClearData();
        //Set important values
        chanceMaxVal = blockRoomChance + corridorChance + lrgRoomChance + stairChance;
        //Create the starting room
        GameObject start = Instantiate(startRoom, Vector3.zero, Quaternion.identity);

        //Pull the only entrance out of the starting room into the temp buffer
        PopulateTempBufferWithPoints(start);

        //Move the temp buffer
        MovetempBufferToOpenPoints();

        //Add the start room bounds to the existing bounds list
        Bounds startingBounds = start.GetComponent<BoxCollider>().bounds;
        startingBounds.center = start.transform.position + startingBounds.center;
        lastRoomBounds.Add(startingBounds);

        //Setp the reset rotation for the new room to align the entrance forward vector to the global forward vector
        Vector3 resetRot;
        Transform connectionPointIn;

        //Get the room populator script if possible
        Room_Populator tempRoomPopulator = start.GetComponent<Room_Populator>();
        if(tempRoomPopulator != null)
        {
            roomPopulators.Add(tempRoomPopulator);
            tempRoomPopulator = null;
        }
        //Create the rooms needed
        for (int i = 0; i < maxRooms - 1; i++)
        {
            if(openPoints.Count <= 0)
            {
                Debug.LogError("There are no more open point to work with, exiting generation stage");
                return;
            }
            Transform connectionPointOut = openPoints[0];
            
            GameObject newRoom = Instantiate(SelectNewRoomType(), Vector3.zero, Quaternion.identity);

            //Position room to the connection point
            //First get the connection points into the temp buffer
            PopulateTempBufferWithPoints(newRoom);
            //Select a random point to be in the input connection
            connectionPointIn = tempPointsBuffer[Random.Range(0, tempPointsBuffer.Count)];
            //Delete con point in from the temp buffer
            tempPointsBuffer.Remove(connectionPointIn);
            //Position the new room correctly
            //Align the input connection to become the identity and then align it to the inverse of the output connection
            resetRot = connectionPointIn.eulerAngles;
            newRoom.transform.Rotate(-resetRot);

            Vector3 inverseToOutput = connectionPointOut.eulerAngles;
            inverseToOutput.y += 180;
            newRoom.transform.Rotate(inverseToOutput);

            //Position the room to line up
            Vector3 offset = connectionPointIn.position - newRoom.transform.position;
            newRoom.transform.position = connectionPointOut.position - offset;

            //Check for a collision between the new room and any existing rooms with bounds
            Bounds currentRoomBounds = newRoom.GetComponent<BoxCollider>().bounds;
            currentRoomBounds.center = newRoom.transform.position + currentRoomBounds.center;

            if (CheckNewRoomBounds(currentRoomBounds))
            {
                //The room is colliding with another
                Debug.Log("Room cannot spawn, blocking connection point");
                DestroyImmediate(newRoom);
                //Block off that connection
                Instantiate(blocker, connectionPointOut.position, connectionPointOut.rotation);
                openPoints.Remove(connectionPointOut);
                i--;
            }
            else
            {
                //Room is not colliding with another
                //Clean up for the next itteration
                MovetempBufferToOpenPoints();
                collidersToDestroy.Add(newRoom.GetComponent<BoxCollider>());
                lastRoomBounds.Add(currentRoomBounds);
                openPoints.Remove(connectionPointOut);
                tempRoomPopulator = newRoom.GetComponent<Room_Populator>();
                if(tempRoomPopulator != null)
                {
                    roomPopulators.Add(tempRoomPopulator);
                }
            }

        }
        //Try from furthes away so need to reverse the open points list
        openPoints.Reverse();

        GameObject end = Instantiate(endRoom, Vector3.zero, Quaternion.identity);
        PopulateTempBufferWithPoints(end);
        connectionPointIn = tempPointsBuffer[Random.Range(0, tempPointsBuffer.Count)];
        tempPointsBuffer.Remove(connectionPointIn);

        resetRot = connectionPointIn.eulerAngles;
        end.transform.Rotate(-resetRot);

        bool endPointSituated = false;
        //All rooms but one are added, we can now make the end room and block off any leftover connections
        foreach (Transform _point in openPoints)
        {
            if (!endPointSituated)
            {
                Vector3 inverseToOutput = _point.eulerAngles;
                inverseToOutput.y += 180;
                end.transform.Rotate(inverseToOutput);

                //Position the room to line up
                Vector3 offset = connectionPointIn.position - end.transform.position;
                end.transform.position = _point.position - offset;

                //Check for a collision between the new room and any existing rooms with bounds
                Bounds currentRoomBounds = end.GetComponent<BoxCollider>().bounds;
                currentRoomBounds.center = end.transform.position + currentRoomBounds.center;

                //Check the collider
                if (CheckNewRoomBounds(currentRoomBounds))
                {
                    //The room is colliding with another
                    Debug.Log("End room cannot spawn, blocking connection point");
                    //Block off that connection
                    Instantiate(blocker, _point.position, _point.rotation);
                    //openPoints.Remove(_point);
                }
                else
                {
                    //Room is not colliding with another
                    //Clean up for the next itteration
                    lastRoomBounds.Add(currentRoomBounds);
                    //openPoints.Remove(_point);
                    endPointSituated = true;
                }
            }
            else
            {
                Instantiate(blocker, _point.position, _point.rotation);
                //openPoints.Remove(_point);
            }
        }
    }
}
