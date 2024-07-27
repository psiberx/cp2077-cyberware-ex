module CyberwareEx

public abstract class CompatibilityManager {
    public static func RequiredTweakXL() -> String = "1.10.2";
    public static func RequiredCodeware() -> String = "1.12.0";

    public static func CheckRequirements() -> Bool {
        return Codeware.Require(CompatibilityManager.RequiredCodeware())
            && TweakXL.Require(CompatibilityManager.RequiredTweakXL());
    }

    public static func CheckConflicts(game: GameInstance, out conflicts: array<String>) -> Bool {
        let itemController = new InventoryItemDisplayController();
        itemController.SetLocked(true, false);
        if !itemController.m_isLocked {
            ArrayPush(conflicts, "No Special Outfit Lock");
        }

        return ArraySize(conflicts) == 0;
    }

    public static func CheckConflicts(game: GameInstance) -> Bool {
        let conflicts: array<String>;
        return CompatibilityManager.CheckConflicts(game, conflicts);
    }

    public static func IsUserNotified() -> Bool {
        return TweakDBInterface.GetBool(t"CyberwareEx.isUserNotified", false);
    }

    public static func MarkAsNotified() {
        TweakDBManager.SetFlat(t"CyberwareEx.isUserNotified", true);
    }
}
