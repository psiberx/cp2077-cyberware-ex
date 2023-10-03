// Overrides how the active item is resolved for the system replacement slot so that
// it returns a Cyberdeck installed in any slot, not just in the first.
@wrapMethod(EquipmentSystemPlayerData)
public final const func GetActiveItem(equipArea: gamedataEquipmentArea) -> ItemID {
	if Equals(equipArea, gamedataEquipmentArea.SystemReplacementCW) {
		return this.GetTaggedItem(equipArea, n"Cyberdeck");
	}

	return wrappedMethod(equipArea);
}

// Gets the active item that has the specified tag.
@addMethod(EquipmentSystemPlayerData)
public func GetTaggedItem(equipArea: gamedataEquipmentArea, requiredTag: CName) -> ItemID {
	return this.GetTaggedItem(equipArea, [requiredTag]);
}

// Gets the active item that has specified tags.
@addMethod(EquipmentSystemPlayerData)
public func GetTaggedItem(equipArea: gamedataEquipmentArea, requiredTags: array<CName>) -> ItemID {
	let equipAreaIndex = this.GetEquipAreaIndex(equipArea);
    let numSlots = ArraySize(this.m_equipment.equipAreas[equipAreaIndex].equipSlots);
    let slotIndex = 0;

	while slotIndex < numSlots {
		let itemID: ItemID = this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID;

		if ItemID.IsValid(itemID) && this.CheckTagsInItem(itemID, requiredTags) {
			return this.GetItemInEquipSlot(equipAreaIndex, slotIndex);
		}

		slotIndex += 1;
	}

	return ItemID.None();
}

@if(ModuleExists("CyberwareEx.OverrideMode"))
@wrapMethod(EquipmentSystemPlayerData)
private final const func IsSlotLocked(slot: SEquipSlot, out visibleWhenLocked: Bool) -> Bool {
    if !slot.visibleWhenLocked {
        return wrappedMethod(slot, visibleWhenLocked);
    }

    visibleWhenLocked = true;
    return false;
}

@if(ModuleExists("CyberwareEx.OverrideMode"))
@replaceMethod(EquipmentSystemPlayerData)
private final func InitializeEquipSlotsFromRecords(slotRecords: array<wref<EquipSlot_Record>>, out equipSlots: array<SEquipSlot>) {
    let numberOfRecords = ArraySize(slotRecords);
    let numberOfSlots = ArraySize(equipSlots);
    let finalSize = Max(numberOfRecords, numberOfSlots);
    let i = 0;
    while i < finalSize {
        if i < numberOfRecords {
            let equipSlot: SEquipSlot;
            this.InitializeEquipSlotFromRecord(slotRecords[i], equipSlot);
            if i < numberOfSlots {
                if !IsDefined(equipSlot.unlockPrereq) || equipSlot.unlockPrereq.IsFulfilled(this.m_owner.GetGame(), this.m_owner) {
                    equipSlot.itemID = equipSlots[i].itemID;
                }
                equipSlots[i] = equipSlot;
            } else {
                ArrayPush(equipSlots, equipSlot);
            }
        } else {
            this.InitializeEquipSlotFromRecord(TDB.GetEquipSlotRecord(t"EquipmentArea.SimpleEquipSlot"), equipSlots[i]);
        }
        i += 1;
    }
}

@if(!ModuleExists("CyberwareEx.OverrideMode"))
@wrapMethod(EquipmentSystemPlayerData)
private final func InitializeEquipSlotsFromRecords(slotRecords: array<wref<EquipSlot_Record>>, out equipSlots: array<SEquipSlot>) {
    wrappedMethod(slotRecords, equipSlots);
    ArrayResize(equipSlots, ArraySize(slotRecords));
}
