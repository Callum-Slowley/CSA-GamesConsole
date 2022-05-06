using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
//struct to contain the stats of the magic spells
public struct magicStats
{
    //Magics speed
    public int bulletVelocity;
    //Magics cooldown
    public int coolDown;
    //the dmg of the spell
    public int spellDmg;
    //Direction of the spell (useally forwards)
    public Vector3 bulletDirection;
    //Element type fire electric ect
    public string element;
    //Shape of the spell so it could be a beam or a orb 
    public string shape;
    //If the spell is effected by gravity
    public bool usesGravity;
    //If the spell does damage over time
    public bool dot;

    public magicStats(int bulletVelocity, int coolDown,int spellDmg ,Vector3 bulletDirection, string element,string shape ,bool usesGravity, bool dot)
    {
        this.bulletVelocity = bulletVelocity;
        this.coolDown = coolDown;
        this.spellDmg = spellDmg;
        this.bulletDirection = bulletDirection;
        this.element = element;
        this.shape = shape;
        this.usesGravity = usesGravity;
        this.dot = dot;
    }
}

public class Shooting : MonoBehaviour
{
    [Header("Global Spell Shooting Varibles")]
    //firing point of the spell
    public GameObject firingPoint;
    //an array holding all of the differnet magic shapes
    public GameObject[] magicShape;
    //CooldownBetween spells
    public float currentTime = 0;
    [Header("Curret Spell Varibles")]
    //The current spell the user has equiped
    public magicStats currentSpell;

    //last spell gameobject fired used mainly to set it varibles and change its shaders
    private GameObject lastSpellObject;   

    // Start is called before the first frame update
    void Start()
    {
        currentSpell = settingSpell();
    }

    // Update is called once per frame
    void Update()
    {
        currentTime += 1 * Time.deltaTime;
        //If we can cast a spell contntinue 
        
    }

    public void FireSpell()
    {
        if (currentTime >= currentSpell.coolDown)
        {
            //used for debug purposes only
            Debug.Log("Firing Spell");
            //Switch case used across the shape of the spell 
            switch (currentSpell.shape)
            {
                case "ORB":
                    //used for debug purposes only
                    Debug.Log("Orb selected");
                    //Createing the spell game object then passing its stats over
                    lastSpellObject = Instantiate(magicShape[0], firingPoint.transform.position, firingPoint.transform.rotation);
                    lastSpellObject.GetComponent<MagicSpell>().thisSpell = currentSpell;
                    lastSpellObject.GetComponent<MagicSpell>().SendProjectile();
                    //resetting the time
                    currentTime = 0;
                    break;
                case "SHARD":
                    //used for debug purposes only
                    Debug.Log("Shard selected");
                    //Createing the spell game object then passing its stats over
                    lastSpellObject = Instantiate(magicShape[1], firingPoint.transform.position, firingPoint.transform.rotation);
                    lastSpellObject.GetComponent<MagicSpell>().thisSpell = currentSpell;
                    lastSpellObject.GetComponent<MagicSpell>().SendProjectile();
                    //resetting the time
                    currentTime = 0;
                    break;
            }
        }
    }


    //function that creates a brand new spell based on the parameters passed in
    magicStats setttingSpell(int bulletVelocity, int coolDown,int spellDmg , Vector3 bulletDirection,string element,string shape, bool usesgravity,bool dot)
    {
        magicStats spell;
        spell = new magicStats(bulletVelocity, coolDown, spellDmg, bulletDirection,element,shape,usesgravity, dot);
        return spell ;
    }
    //If the function has no parameters we create a basic spell
    magicStats settingSpell()
    {
        magicStats spell;
        spell = new magicStats(5, 2, 3 ,Vector3.forward, "FIRE","ORB",false, false);
        return spell;
    }
}
