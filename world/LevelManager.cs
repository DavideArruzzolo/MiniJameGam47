using Godot;
using System;

public partial class LevelManager : Node2D
{
    private Node2D currentLevel = null;

    public void ChangeScene(PackedScene newLevel)
    {
        RemoveChild(currentLevel);
        Node2D instance = newLevel.Instantiate<Node2D>();
        AddChild(instance);
        currentLevel = instance;
    }
}
