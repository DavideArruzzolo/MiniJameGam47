using Godot;
using System;

public partial class LevelExit : Area2D
{
    [Export] private LevelManager levelManager;
    [Export] private PackedScene nextLevel = null;

    private void onAreaEntered(Node player)
    {
        levelManager.ChangeScene(nextLevel);
    }

}
