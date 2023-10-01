// Overrides how the active item is resolved for the system replacement slot so that
// it returns a Cyberdeck installed in any slot, not just in the first.
@wrapMethod(EquipmentSystemPlayerData)
public final const func GetActiveItem(equipArea: gamedataEquipmentArea) -> ItemID {
	if Equals(equipArea, gamedataEquipmentArea.SystemReplacementCW) {
		return this.GetTaggedItem(equipArea, n"Cyberdeck");
	}

	return wrappedMethod(equipArea);
}

// Overrides equip method to automatically unequip conflicting items.
@wrapMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) {
	this.UnequipConflictingItems(itemID);

	wrappedMethod(itemID, slotIndex, blockActiveSlotsUpdate, forceEquipWeapon);
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

// Unequips conflicting items.
// Sandevistan and Berserk are considered to be conflicting items.
@addMethod(EquipmentSystemPlayerData)
private func UnequipConflictingItems(itemID: ItemID) {
	let equipArea = EquipmentSystem.GetEquipAreaType(itemID);

	if Equals(equipArea, gamedataEquipmentArea.SystemReplacementCW) {
		if this.CheckTagsInItem(itemID, [n"Sandevistan"]) {
			this.UnequipTaggedItems(equipArea, n"Sandevistan");
		} else {
            if this.CheckTagsInItem(itemID, [n"Berserk"]) {
                this.UnequipTaggedItems(equipArea, n"Berserk");
            }
        }
	}
}

// Unequips items that has the specified tag.
@addMethod(EquipmentSystemPlayerData)
private func UnequipTaggedItems(equipArea: gamedataEquipmentArea, requiredTag: CName) {
	let requiredTags: array<CName>;
	ArrayPush(requiredTags, requiredTag);

	let equipAreaIndex = this.GetEquipAreaIndex(equipArea);
	let numSlots = ArraySize(this.m_equipment.equipAreas[equipAreaIndex].equipSlots);
	let slotIndex = 0;

	while slotIndex < numSlots {
		let itemID = this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID;

		if ItemID.IsValid(itemID) && this.CheckTagsInItem(itemID, requiredTags) {
			this.UnequipItem(equipAreaIndex, slotIndex);
		}

		slotIndex += 1;
	}
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
            if i <= ArraySize(equipSlots) {
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
