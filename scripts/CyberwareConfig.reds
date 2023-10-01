module CyberwareEx

public struct ExpansionArea {
    public let equipmentArea: gamedataEquipmentArea;
    public let extraSlots: array<ExtraSlot>;
}

public struct ExtraSlot {
    public let requiredPerk: gamedataNewPerkType;
    public let requiredLevel: Int32;
}

public abstract class CyberwareConfig {
    public static func Expansions() -> array<ExpansionArea> = [
        new ExpansionArea(gamedataEquipmentArea.SystemReplacementCW, [
            new ExtraSlot(gamedataNewPerkType.Tech_Central_Milestone_3, 3),
            new ExtraSlot(gamedataNewPerkType.Tech_Master_Perk_3, 1)
        ]),
        new ExpansionArea(gamedataEquipmentArea.FrontalCortexCW, [
            new ExtraSlot(gamedataNewPerkType.Intelligence_Central_Milestone_3, 1),
            new ExtraSlot(gamedataNewPerkType.Intelligence_Central_Milestone_3, 2)
        ]),
        new ExpansionArea(gamedataEquipmentArea.CardiovascularSystemCW, [
            new ExtraSlot(gamedataNewPerkType.Body_Central_Perk_1_4, 1)
        ]),
        new ExpansionArea(gamedataEquipmentArea.NervousSystemCW, [
            new ExtraSlot(gamedataNewPerkType.Tech_Central_Milestone_3, 2)
        ]),
        new ExpansionArea(gamedataEquipmentArea.IntegumentarySystemCW, [
            new ExtraSlot(gamedataNewPerkType.Tech_Central_Milestone_3, 1),
            new ExtraSlot(gamedataNewPerkType.Tech_Central_Perk_3_3, 1)
        ]),
        new ExpansionArea(gamedataEquipmentArea.HandsCW, [
            new ExtraSlot(gamedataNewPerkType.Tech_Central_Perk_3_2, 1)
        ]),
        new ExpansionArea(gamedataEquipmentArea.LegsCW, [
            new ExtraSlot(gamedataNewPerkType.Reflexes_Central_Perk_1_3, 1)
        ])
    ];
}
