using Godot;
using System;
using Godot.Collections;

public partial class Door : Node2D
{
    // Assign only Switchable - Godot does not allow exporting custom classes, but non-switchable won't work!
    [Export] private Array<Node2D> SwitchesToOpen { get; set; } = new();
    private Dictionary<Switchable, bool> statuses = new();

    public override void _Ready()
    {
        foreach (var node in SwitchesToOpen)
        {
            Switchable switchable = (Switchable)node;
            switchable.OnStatusChangedEvent += onStatusChanged;

            statuses.Add(switchable, switchable.Status);
        }
    }

    private void onStatusChanged(Switchable changingStatus, bool status)
    {
        statuses[changingStatus] = status;
        checkOpen();
    }

    private void checkOpen()
    {
        bool shouldOpen = true;
        foreach (var pair in statuses)
        {
            if (pair.Value == false)
            {
                shouldOpen = false;
            }
        }

        if (shouldOpen)
        {
            // TODO Change sprite
            GetNode<CollisionShape2D>("Hitbox").SetDeferred("disabled", true); // Either this or change layer
        }
        else
        {
            // TODO Change sprite
            GetNode<CollisionShape2D>("Hitbox").SetDeferred("disabled", false);
        }
    }
}
