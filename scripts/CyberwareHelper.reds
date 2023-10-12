module CyberwareEx

public class CyberwareHelper {
    public static func GetSlotRecord(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> wref<EquipSlot_Record> {
        let equipAreaID = TDBID.Create("EquipmentArea." + ToString(equipArea));
        let equipArea = TweakDBInterface.GetEquipmentAreaRecord(equipAreaID);
        return equipArea.GetEquipSlotsItem(slotIndex);
    }

    public static func GetPrereqRecord(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> wref<IPrereq_Record> {
        let equipSlot = CyberwareHelper.GetSlotRecord(equipArea, slotIndex);
        return equipSlot.UnlockPrereqRecord();
    }

    public static func GetPerkPrereqRecord(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> wref<PlayerIsNewPerkBoughtPrereq_Record> {
        let equipSlot = CyberwareHelper.GetSlotRecord(equipArea, slotIndex);
        return equipSlot.UnlockPrereqRecord() as PlayerIsNewPerkBoughtPrereq_Record;
    }

    public static func GetRequiredPerkAbility(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> gamedataNewPerkType {
        let perkPrereq = CyberwareHelper.GetPerkPrereqRecord(equipArea, slotIndex);
        return IsDefined(perkPrereq)
            ? IntEnum<gamedataNewPerkType>(Cast<Int32>(EnumValueFromString("gamedataNewPerkType", perkPrereq.PerkType())))
            : gamedataNewPerkType.Invalid;
    }

    public static func GetRequiredPerkRecord(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> wref<NewPerk_Record> {
        let perkPrereq = CyberwareHelper.GetPerkPrereqRecord(equipArea, slotIndex);
        if IsDefined(perkPrereq) {
            let perkID = TDBID.Create("NewPerks." + perkPrereq.PerkType());
            return TweakDBInterface.GetNewPerkRecord(perkID);
        } else {
            return null;
        }
    }

    public static func GetRequiredPerkType(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> gamedataNewPerkType {
        let perkRecord = CyberwareHelper.GetRequiredPerkRecord(equipArea, slotIndex);
        return IsDefined(perkRecord) ? perkRecord.Type() : gamedataNewPerkType.Invalid;

        //let perkPrereq = CyberwareHelper.GetPerkPrereqRecord(equipArea, slotIndex);
        //return IsDefined(perkPrereq)
        //    ? IntEnum<gamedataNewPerkType>(Cast<Int32>(EnumValueFromString("gamedataNewPerkType", perkPrereq.PerkType())))
        //    : gamedataNewPerkType.Invalid;
    }

    public static func GetRequiredPerkStatType(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> gamedataStatType {
        let perkRecord = CyberwareHelper.GetRequiredPerkRecord(equipArea, slotIndex);
        return IsDefined(perkRecord) ? perkRecord.Attribute().Attribute().StatType() : gamedataStatType.Invalid;
    }

    public static func GetRequiredPerkLevel(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> Int32 {
        let perkPrereq = CyberwareHelper.GetPerkPrereqRecord(equipArea, slotIndex);
        return IsDefined(perkPrereq) ? perkPrereq.Level() : 0;
    }

    public static func GetRequiredPerkMaxLevel(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> Int32 {
        let perkRecord = CyberwareHelper.GetRequiredPerkRecord(equipArea, slotIndex);
        return IsDefined(perkRecord) ? perkRecord.GetLevelsCount() : 0;
    }

    public static func IsPerkRequired(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> Bool {
        let perkPrereq = CyberwareHelper.GetPerkPrereqRecord(equipArea, slotIndex);
        return IsDefined(perkPrereq);
    }

    public static func IsUnlockRequired(equipArea: gamedataEquipmentArea, slotIndex: Int32) -> Bool {
        let anyPrereq = CyberwareHelper.GetPrereqRecord(equipArea, slotIndex);
        return IsDefined(anyPrereq);
    }

    public static func IsCyberdeckEquipped(owner: ref<GameObject>) -> Bool {
        return GameInstance.GetStatsSystem(owner.GetGame()).GetStatBoolValue(Cast(owner.GetEntityID()), gamedataStatType.HasCyberdeck);
    }
}
