using Godot;
using System;

public partial class Switchable : Node2D
{
    public delegate void StatusChangedHandler(Switchable self, bool status);
    public event StatusChangedHandler OnStatusChangedEvent;

    public bool Status
    {
        get { return status; }
        set
        {
            OnStatusChangedEvent?.Invoke(this, value);
            status = value;
        }  
    }

    private bool status = false;
}
