module CyberwareEx

class RegisterCyberwareSlots extends ScriptableTweak {
    protected func OnApply() {
        for expansion in CyberwareConfig.SlotExpansions() {
            if IsOverrideMode() {
                return;
            }

            let equipmentAreaID = TDBID.Create("EquipmentArea." + ToString(expansion.equipmentArea));
            let equipmentAreaSlots = TweakDBInterface.GetForeignKeyArray(equipmentAreaID + t".equipSlots");

            for extraSlot in expansion.extraSlots {
                let equipSlotName = s"EquipmentArea.EquipSlot_\(extraSlot.requiredPerk)_\(extraSlot.requiredLevel)";
                let equipSlotID = TDBID.Create(equipSlotName);

                if !IsDefined(TweakDBInterface.GetEquipSlotRecord(equipSlotID)) {
                    let prereqName = s"EquipmentArea.PerkPrereq_\(extraSlot.requiredPerk)_\(extraSlot.requiredLevel)";
                    let prereqID = TDBID.Create(prereqName);

                    if !IsDefined(TweakDBInterface.GetPrereqRecord(prereqID)) {
                        TweakDBManager.CreateRecord(prereqID, n"PlayerIsNewPerkBoughtPrereq");
                        TweakDBManager.SetFlat(prereqID + t".perkType", ToString(extraSlot.requiredPerk));
                        TweakDBManager.SetFlat(prereqID + t".level", extraSlot.requiredLevel);
                        TweakDBManager.UpdateRecord(prereqID);
                        TweakDBManager.RegisterName(StringToName(prereqName));
                    }

                    TweakDBManager.CreateRecord(equipSlotID, n"EquipSlot");
                    TweakDBManager.SetFlat(equipSlotID + t".unlockPrereqRecord", prereqID);
                    TweakDBManager.SetFlat(equipSlotID + t".visibleWhenLocked", true);
                    TweakDBManager.UpdateRecord(equipSlotID);
                    TweakDBManager.RegisterName(StringToName(equipSlotName));
                }

                ArrayPush(equipmentAreaSlots, equipSlotID);
            }

            TweakDBManager.SetFlat(equipmentAreaID + t".equipSlots", equipmentAreaSlots);
            TweakDBManager.UpdateRecord(equipmentAreaID);
        }
    }
}
