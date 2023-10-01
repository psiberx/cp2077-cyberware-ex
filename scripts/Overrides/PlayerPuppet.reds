@replaceMethod(PlayerPuppet)
private final func ActivateIconicCyberware() {
    let activated = false;

    if this.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vision) == 1 {
        if QuickHackableHelper.TryToCycleOverclockedState(this) {
            activated = true;
        }
        return;
    }

	let statsSystem = GameInstance.GetStatsSystem(this.GetGame());
	let playerStatsId = Cast<StatsObjectID>(this.GetEntityID());

    if statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasBerserk) {
        let playerData = EquipmentSystem.GetData(this);
        let cyberwareItem = playerData.GetTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Berserk");
        if ItemActionsHelper.UseItem(this, cyberwareItem) {
            activated = true;
        }
    }

    if statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasSandevistan) {
        if TimeDilationHelper.CanUseTimeDilation(this) {
            let playerData = EquipmentSystem.GetData(this);
            let cyberwareItem = playerData.GetTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Sandevistan");
            if ItemActionsHelper.UseItem(this, cyberwareItem) {
                activated = true;
            }
        }
    }

    if activated {
        this.IconicCyberwareActivated();
    } else {
        let audioEvent = new SoundPlayEvent();
        audioEvent.soundName = n"ui_grenade_empty";

        this.QueueEvent(audioEvent);
    }

    let dpadAction = new DPADActionPerformed();
    dpadAction.action = EHotkey.LBRB;
    dpadAction.state = EUIActionState.COMPLETED;
    dpadAction.successful = activated;

    GameInstance.GetUISystem(this.GetGame()).QueueEvent(dpadAction);
}

// Overrides the time dilation cleanup routine so that it can handle several active effects at the same time,
// Sandevistan + Focus Mode in particular.
@wrapMethod(PlayerPuppet)
protected cb func OnCleanUpTimeDilationEvent(evt: ref<CleanUpTimeDilationEvent>) -> Bool {
	let timeSystem = GameInstance.GetTimeSystem(this.GetGame());
    if !timeSystem.IsTimeDilationActive() {
    	wrappedMethod(evt);
    }
}
