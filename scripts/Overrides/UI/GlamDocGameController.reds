// The 2.5 Glamdoc assumes one arms slot and reads the first arms item (GetPlayerAreaItems(ArmsCW)[0]).
// With extra arm slots that can be a different arm from the active one, so the Glamdoc doesn't recognise
// the arm in use. The preview and the customization system already use GetActiveItem(ArmsCW); these use it too.
// With a single arms slot the active item is the first item, so vanilla behaviour is unchanged.

@addMethod(GlamDocGameController)
private final func GetCurrentArmItem() -> wref<UIInventoryItem> {
    let items = this.m_uiInventorySystem.GetPlayerAreaItems(gamedataEquipmentArea.ArmsCW);
    if ArraySize(items) == 0 {
        return null;
    }
    let active = EquipmentSystem.GetInstance(this.m_player).GetPlayerData(this.m_player)
        .GetActiveItem(gamedataEquipmentArea.ArmsCW);
    for item in items {
        if item.GetID() == active {
            return item;
        }
    }
    return items[0];
}

@replaceMethod(GlamDocGameController)
private final func CheckIfCanApply(itemData: wref<gameItemData>) -> Bool {
    let arm = this.GetCurrentArmItem();
    if !IsDefined(arm) {
        return false;
    }
    return this.ItemTagMatch(itemData, IntEnum<ArmsWareType>(EnumInt(arm.GetItemType()) - 15));
}

@replaceMethod(GlamDocGameController)
private final func GetCurrentArmsWareType() -> ArmsWareType {
    let arm = this.GetCurrentArmItem();
    if IsDefined(arm) {
        return IntEnum<ArmsWareType>(EnumInt(arm.GetItemType()) - 15);
    }
    return ArmsWareType.Launcher;
}

@replaceMethod(GlamDocGameController)
private final func InitializeEquippedCyberArm() {
    let arm = this.GetCurrentArmItem();
    if IsDefined(arm) {
        this.m_equippedArmItem = arm;
    }
}
