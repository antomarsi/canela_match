public enum BonusType
{
    None,
    DestroyWholeRowColumn
}

public static class BonusTypeUtilities
{
    public static bool ContainsDestroyWholeRowColumn (BonusType bt)
    {
        return (bt & BonusType.DestroyWholeRowColumn) == BonusType.DestroyWholeRowColumn;
    }
}

public enum GameState
{
    None,
    SelectionStarted,
    Animating
}

public static class Constants
{
    public static readonly int Rows = 12;
    public static readonly int Columns = 8;
    public static readonly float AnimationDuration = 0.2f;

    public static readonly float MoveAnimationMinDuration 0.05f;
    public static readonly float ExplosionDuration = 0.3f;

    public static readonly float WaitBeforePotentialMatchesCheck = 2f;
    public static readonly float OpacityAnimationFrameDelay = 0.05f;

    public static readonly int MinimumMatches = 3;
    public static readonly int MinimumMatchesForBonus = 4;

    public static readonly int Match3Score = 60;
    public static readonly int SubsequentMatchScore = 1000;
}
