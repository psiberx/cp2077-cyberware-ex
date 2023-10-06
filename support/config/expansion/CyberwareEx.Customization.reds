module CyberwareEx.Customization
import CyberwareEx.*

public class UserConfig extends DefaultConfig {
    public static func SlotExpansions() -> array<ExpansionArea> = [
        ExpansionArea.Create(gamedataEquipmentArea.SystemReplacementCW, [
            ExpansionSlot.Create(gamedataNewPerkType.Tech_Central_Milestone_3, 3),
            ExpansionSlot.Create(gamedataNewPerkType.Tech_Master_Perk_3, 1)
        ]),
        ExpansionArea.Create(gamedataEquipmentArea.FrontalCortexCW, [
            ExpansionSlot.Create(gamedataNewPerkType.Intelligence_Central_Milestone_3, 1),
            ExpansionSlot.Create(gamedataNewPerkType.Intelligence_Central_Milestone_3, 2)
        ]),
        ExpansionArea.Create(gamedataEquipmentArea.CardiovascularSystemCW, [
            ExpansionSlot.Create(gamedataNewPerkType.Body_Central_Perk_1_4, 1)
        ]),
        ExpansionArea.Create(gamedataEquipmentArea.NervousSystemCW, [
            ExpansionSlot.Create(gamedataNewPerkType.Tech_Central_Milestone_3, 2)
        ]),
        ExpansionArea.Create(gamedataEquipmentArea.IntegumentarySystemCW, [
            ExpansionSlot.Create(gamedataNewPerkType.Tech_Central_Milestone_3, 1),
            ExpansionSlot.Create(gamedataNewPerkType.Tech_Central_Perk_3_3, 1)
        ]),
        ExpansionArea.Create(gamedataEquipmentArea.HandsCW, [
            ExpansionSlot.Create(gamedataNewPerkType.Tech_Central_Perk_3_2, 1)
        ]),
        ExpansionArea.Create(gamedataEquipmentArea.LegsCW, [
            ExpansionSlot.Create(gamedataNewPerkType.Reflexes_Central_Perk_1_3, 1)
        ])
    ];

    public static func CombinedAbilityMode() -> Bool = false
}
