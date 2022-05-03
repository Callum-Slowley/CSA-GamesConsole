using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MagicSpell : MonoBehaviour
{
    //used to carry along the stats from the spell on the user
    public magicStats thisSpell;
    //used to change the physics of the spell
    private Rigidbody rb;

    public void SendProjectile()
    {
        //grabbing the rigid body of the spell this is used to add or remove gravity on the spell
        rb = this.gameObject.GetComponent<Rigidbody>();
        //sets if the spell uses gravity or not
        rb.useGravity = thisSpell.usesGravity;
        //drag is set to 0 so it works with addforce
        rb.drag = 0;
        //Sets bullet movement direction
        thisSpell.bulletDirection = transform.forward;
        Debug.Log(transform.forward);
        //Force is added to the object
        rb.AddForce(thisSpell.bulletDirection * thisSpell.bulletVelocity, ForceMode.Impulse);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if(collision.gameObject.tag == "Enemy")
        {
            //if an enemy is hit we deal dmg to the enemy based on our spell stats
            collision.gameObject.GetComponent<EnemyStats>().currentHP -= thisSpell.spellDmg;
            Destroy(this.gameObject);
        }
        //destroying the projectile once the spell has hit something
        Destroy(this.gameObject);
    }
}
