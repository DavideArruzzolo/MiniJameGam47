using Godot;
using System;

public partial class Lever : Switchable
{
    private void onInteract()
    {
        if (Status)
        {
            Status = false;
            // TODO Change Sprite
        }
        else
        {
            Status = true;
            // TODO Change Sprite
        }

    }

    private void onAreaEntered(Node player)
    {
        // player.InteractEvent += onInteract
    }

    private void onAreaExited(Node player)
    {
        // player.InteractEvent -= onInteract
    }
}
