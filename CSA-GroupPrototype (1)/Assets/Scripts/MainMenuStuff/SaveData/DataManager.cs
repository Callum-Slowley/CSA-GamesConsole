using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine;

public class DataManager : MonoBehaviour
{
    public static OptionsSaveData optionsData;
    public static PlayerSaveData playerData;

    public static void SaveOptionsData()
    {
        //Create a binary formatter to encode the data
        BinaryFormatter formatter = new BinaryFormatter();

        //Create a path for this specific application and add the filrname
        string path = Application.persistentDataPath + "OptionsData.thingo";
        //Open a data stream
        FileStream stream = new FileStream(path, FileMode.Create);

        //Serialize the data and save it to the binary file
        formatter.Serialize(stream, optionsData);
        stream.Close();
    }

    public static void TryLoadOptionsData()
    {
        //Try to open the file at the path
        string path = Application.persistentDataPath + "OptionsData.thingo";

        //If save data exists, load it, deserialize it and return it
        if (File.Exists(path))
        {
            BinaryFormatter formatter = new BinaryFormatter();
            FileStream stream = new FileStream(path, FileMode.Open);

            OptionsSaveData progData = formatter.Deserialize(stream) as OptionsSaveData;
            stream.Close();
            optionsData = progData;
        }
        else
        {
            Debug.LogWarning("options save data does not exist!");
            //Options do not exist. Make a new file with default values
            optionsData = new OptionsSaveData();
            optionsData.resWidth = 1280;
            optionsData.resHeight = 720;
            optionsData.vSync = true;
            optionsData.UIMode = 0;
            optionsData.controlScheme = 0;
            optionsData.stickSensitivity = 1.0f;
            SaveOptionsData();
        }
    }

    public static void SavePlayerData()
    {
        //Create a binary formatter to encode the data
        BinaryFormatter formatter = new BinaryFormatter();

        //Create a path for this specific application and add the filrname
        string path = Application.persistentDataPath + "PlayerData.thingo";
        //Open a data stream
        FileStream stream = new FileStream(path, FileMode.Create);

        //Serialize the data and save it to the binary file
        formatter.Serialize(stream, playerData);
        stream.Close();
    }

    public static void TryLoadPlayerData()
    {
        //Try to open the file at the path
        string path = Application.persistentDataPath + "PlayerData.thingo";

        //If save data exists, load it, deserialize it and return it
        if (File.Exists(path))
        {
            BinaryFormatter formatter = new BinaryFormatter();
            FileStream stream = new FileStream(path, FileMode.Open);

            PlayerSaveData progData = formatter.Deserialize(stream) as PlayerSaveData;
            stream.Close();
            playerData = progData;
        }
        else
        {
            Debug.LogWarning("player save data does not exist!");
            //Options do not exist. Make a new file with default values
            playerData = new PlayerSaveData();
            SavePlayerData();
        }
    }

    private void Start()
    {
        DontDestroyOnLoad(this);
        TryLoadOptionsData();
        TryLoadPlayerData();
    }
}
