module CyberwareEx.Customization
import CyberwareEx.*

public class UserConfig extends DefaultConfig {
    public static func UpgradePrice() -> Int32 = 10000
    public static func ResetPrice() -> Int32 = 5000

    public static func SlotOverrides() -> array<OverrideArea> = [
        OverrideArea.Create(gamedataEquipmentArea.ArmsCW, 1),
        OverrideArea.Create(gamedataEquipmentArea.CardiovascularSystemCW, 6),
        OverrideArea.Create(gamedataEquipmentArea.FrontalCortexCW, 6),
        OverrideArea.Create(gamedataEquipmentArea.HandsCW, 4),
        OverrideArea.Create(gamedataEquipmentArea.IntegumentarySystemCW, 6),
        OverrideArea.Create(gamedataEquipmentArea.LegsCW, 4),
        OverrideArea.Create(gamedataEquipmentArea.MusculoskeletalSystemCW, 6),
        OverrideArea.Create(gamedataEquipmentArea.NervousSystemCW, 6),
        OverrideArea.Create(gamedataEquipmentArea.SystemReplacementCW, 4)
    ];

    public static func ActivateOverclockInFocusMode() -> Bool = false
}
