@replaceMethod(gameuiInventoryGameController)
private final func RefreshPlayerCyberware() {
    let playerData = EquipmentSystem.GetData(this.GetPlayerControlledObject());

    let cyberwareAreas: array<gamedataEquipmentArea>;
    ArrayPush(cyberwareAreas, gamedataEquipmentArea.SystemReplacementCW);
    ArrayPush(cyberwareAreas, gamedataEquipmentArea.ArmsCW);
    ArrayPush(cyberwareAreas, gamedataEquipmentArea.HandsCW);

    let maxSlotWidgets = 3;
    let requiredSlotWidgets = 0;

    ArrayClear(this.m_cyberwareItems);

    let i = 0;
    while i < ArraySize(cyberwareAreas) {
        let areaIndex = playerData.GetEquipAreaIndex(cyberwareAreas[i]);
        let slotIndex = 0;
        let numberOfSlots = ArraySize(playerData.m_equipment.equipAreas[areaIndex].equipSlots);
        while slotIndex < numberOfSlots {
            let itemID = playerData.m_equipment.equipAreas[areaIndex].equipSlots[slotIndex].itemID;
            if ItemID.IsValid(itemID) {
                let itemData = this.m_InventoryManager.GetItemDataFromIDInLoadout(itemID);
                ArrayPush(this.m_cyberwareItems, itemData);
                requiredSlotWidgets = ArraySize(this.m_cyberwareItems);
                if requiredSlotWidgets == maxSlotWidgets {
                    break;
                }
            }
            slotIndex += 1;
        }
        if requiredSlotWidgets == maxSlotWidgets {
            break;
        }
        i += 1;
    }

    inkCompoundRef.RemoveAllChildren(this.m_cyberwareSlotRootRefs);
    inkWidgetRef.SetVisible(this.m_cyberwareHolder, requiredSlotWidgets > 0);

    if requiredSlotWidgets > 0 {
        i = 0;
        while i < requiredSlotWidgets {
            let slotSpawnData = new CyberwareSlotSpawnData();
            slotSpawnData.index = i;
            ItemDisplayUtils.SpawnCommonSlotAsync(this, this.m_cyberwareSlotRootRefs, n"itemDisplay", n"OnSlotSpawned", slotSpawnData);
            i += 1;
        }
    }
}

@replaceMethod(gameuiInventoryGameController)
protected cb func OnSlotSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    let controller = widget.GetController() as InventoryItemDisplayController;
    let data = userData as CyberwareSlotSpawnData;
    let itemData = this.m_cyberwareItems[data.index];
    controller.Setup(itemData, InventoryItemData.GetEquipmentArea(itemData), "", InventoryItemData.GetSlotIndex(itemData));
}
