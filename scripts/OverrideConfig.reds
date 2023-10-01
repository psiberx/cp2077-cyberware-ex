module CyberwareEx

public struct OverrideArea {
    public let areaType: gamedataEquipmentArea;
    public let defaultSlots: Int32;
    public let maxSlots: Int32;

    public static func None() -> OverrideArea = new OverrideArea(gamedataEquipmentArea.Invalid, 0, 0)
    public static func IsValid(slot: OverrideArea) -> Bool = NotEquals(slot.areaType, gamedataEquipmentArea.Invalid)
}

public abstract class OverrideConfig {
    public static func Overrides() -> array<OverrideArea> = [
        new OverrideArea(gamedataEquipmentArea.FrontalCortexCW, 3, 6),
        new OverrideArea(gamedataEquipmentArea.CardiovascularSystemCW, 3, 6),
        new OverrideArea(gamedataEquipmentArea.ImmuneSystemCW, 2, 6),
        new OverrideArea(gamedataEquipmentArea.NervousSystemCW, 3, 6),
        new OverrideArea(gamedataEquipmentArea.IntegumentarySystemCW, 3, 6),
        new OverrideArea(gamedataEquipmentArea.SystemReplacementCW, 1, 3),
        new OverrideArea(gamedataEquipmentArea.MusculoskeletalSystemCW, 3, 6),
        new OverrideArea(gamedataEquipmentArea.HandsCW, 2, 4),
        new OverrideArea(gamedataEquipmentArea.ArmsCW, 1, 4),
        new OverrideArea(gamedataEquipmentArea.LegsCW, 1, 2)
    ];

    public static func UpgradePrice() -> Int32 = 10000
    public static func ResetPrice() -> Int32 = 5000
}
