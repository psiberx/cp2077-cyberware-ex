import CyberwareEx.*

@wrapMethod(RipperDocGameController)
private final func Init() {
    wrappedMethod();

    let text = new inkText();
    text.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    text.SetFontStyle(n"Regular");
    text.SetFontSize(28);
    text.SetOpacity(0.1);
    text.SetAnchor(inkEAnchor.TopRight);
    text.SetAnchorPoint(new Vector2(1.0, 0.0));
    text.SetMargin(new inkMargin(0, 160, 100, 0));
    text.SetHorizontalAlignment(textHorizontalAlignment.Left);
    text.SetVerticalAlignment(textVerticalAlignment.Top);
    text.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    text.BindProperty(n"tintColor", n"MainColors.Red");
    text.SetText("POWERED BY CYBERWARE-EX");
    text.Reparent(this.GetRootCompoundWidget());
}

@replaceMethod(RipperDocGameController)
private final func IsEquipmentAreaRequiringPerk(equipmentArea: gamedataEquipmentArea) -> Bool {
    let playerData = EquipmentSystem.GetData(this.GetPlayerControlledObject());
    let visibleWhenLocked: Bool;
    return playerData.IsSlotLocked(
        this.m_hoveredItemDisplay.GetEquipmentArea(),
        this.m_hoveredItemDisplay.GetSlotIndex(),
        visibleWhenLocked
    );
}

@wrapMethod(RipperDocGameController)
private final func ShowCWPerkTooltip(widget: wref<inkWidget>) {
    if Equals(this.m_dollHoverArea, gamedataEquipmentArea.HandsCW) {
        wrappedMethod(widget);
        return;
    }

    this.m_ripperdocHoverState = RipperdocHoverState.SlotSkeleton;

    let tooltipData = new RipperdocPerkTooltipData();
    tooltipData.equipArea = this.m_hoveredItemDisplay.GetEquipmentArea();
    tooltipData.slotIndex = this.m_hoveredItemDisplay.GetSlotIndex();
    tooltipData.ripperdocHoverState = this.m_ripperdocHoverState;

    this.m_TooltipsManager.ShowTooltipAtWidget(n"RipperdocPerkTooltip", widget, tooltipData,
        gameuiETooltipPlacement.RightTop, false, new inkMargin(this.m_defaultTooltipGap, 0.00, 0.00, 0.00));
}

@wrapMethod(RipperDocGameController)
protected cb func OnSlotHover(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
    this.m_hoveredItemDisplay = evt.display;
    wrappedMethod(evt);
}

@replaceMethod(RipperDocGameController)
private final func GetRequiredPerk(hoverArea: RipperdocHoverState) -> gamedataNewPerkType {
    return CyberwareHelper.GetRequiredPerkType(
        this.m_hoveredItemDisplay.GetEquipmentArea(),
        this.m_hoveredItemDisplay.GetSlotIndex()
    );
}

@replaceMethod(RipperDocGameController)
private final func OpenPerkTree() -> Void {
    let userData = new PerkUserData();
    userData.cyberwareScreenType = this.m_screen;
    userData.statType = CyberwareHelper.GetRequiredPerkStatType(
        this.m_hoveredItemDisplay.GetEquipmentArea(),
        this.m_hoveredItemDisplay.GetSlotIndex()
    );
    userData.perkType = CyberwareHelper.GetRequiredPerkType(
        this.m_hoveredItemDisplay.GetEquipmentArea(),
        this.m_hoveredItemDisplay.GetSlotIndex()
    );

    if Equals(this.m_screen, CyberwareScreenType.Inventory) {
        let evt = new OpenMenuRequest();
        evt.m_menuName = n"new_perks";
        evt.m_isMainMenu = true;
        evt.m_jumpBack = true;
        evt.m_eventData.userData = userData;
        evt.m_eventData.m_overrideDefaultUserData = true;
        this.QueueBroadcastEvent(evt);
    } else {
        this.m_menuEventDispatcher.SpawnEvent(n"OnSwitchToCharacter", userData);
    }
}
