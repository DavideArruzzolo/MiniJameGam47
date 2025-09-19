using Godot;
using System;

public partial class Switchable : Node2D
{
    public delegate void StatusChangedHandler(Switchable self, bool status);
    public event StatusChangedHandler OnStatusChangedEvent;

    public bool Status = false;
}
