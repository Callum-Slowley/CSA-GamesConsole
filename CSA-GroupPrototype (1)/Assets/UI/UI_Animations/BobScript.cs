using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BobScript : MonoBehaviour
{
    public AnimationCurve bobCurve;
    public float yOffset = 0.5f;
    public float cycleTime = 1f;

    private Vector3 startingPos;
    private Vector3 maxBob;

    [SerializeField]
    private float currentTime = 0;
    private void Start()
    {
        startingPos = transform.position;
        maxBob = startingPos + new Vector3(0, yOffset, 0);
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = Vector3.Lerp(startingPos, maxBob, bobCurve.Evaluate(currentTime / cycleTime));

        currentTime += Time.deltaTime;
        if (currentTime >= cycleTime)
        {
            currentTime = 0;
        }
    }
}
