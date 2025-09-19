using Godot;
using System;

public partial class Button : Switchable
{
    private int clonesInAreaCount = 0;
    
    private void checkSetStatus()
    {
        if (Status && clonesInAreaCount == 0)
        {
            Status = false;
            // TODO Change Sprite   
            
        }
        else if (!Status && clonesInAreaCount > 0)
        {
            Status = true;
            // TODO Change Sprite
        }
    }
    
    private void onAreaEntered(Node player)
    {
        clonesInAreaCount++;    
        checkSetStatus();
    }
    
    private void onAreaExited(Node player)
    {
        clonesInAreaCount--;
        checkSetStatus();
    }

}
