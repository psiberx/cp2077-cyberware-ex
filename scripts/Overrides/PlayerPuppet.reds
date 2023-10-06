import CyberwareEx.*

@replaceMethod(PlayerPuppet)
private final func ActivateIconicCyberware() {
	let statsSystem = GameInstance.GetStatsSystem(this.GetGame());
	let playerStatsId = Cast<StatsObjectID>(this.GetEntityID());

	let hasBerserk = statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasBerserk);
	let hasSandevistan = statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasSandevistan);
	let hasOverclock = statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasCyberdeck)
	    && PlayerDevelopmentSystem.GetData(this).IsNewPerkBought(gamedataNewPerkType.Intelligence_Central_Milestone_3) == 3;

    let numberOfAbilities = (hasBerserk ? 1 : 0) + (hasSandevistan ? 1 : 0) + (hasOverclock ? 1 : 0);
	if numberOfAbilities == 0 {
	    return;
	}

    let isOnlyOneAbility = numberOfAbilities == 1;
    let isCombinedAbilityMode = IsCombinedAbilityMode();

    let psmBlackboard = this.GetPlayerStateMachineBlackboard();
    let isFocusMode = Equals(IntEnum<gamePSMVision>(psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vision)), gamePSMVision.Focus);
    let isBlocking = Equals(IntEnum<gamePSMMeleeWeapon>(psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon)), gamePSMMeleeWeapon.Block);
    let isInVehicle = psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.MountedToVehicle);

    let attempted = false;
    let activated = false;

    if hasOverclock && (isFocusMode || isOnlyOneAbility || isCombinedAbilityMode) {
        attempted = true;
        if QuickHackableHelper.TryToCycleOverclockedState(this) {
            activated = true;
        }
    }

    if hasBerserk && (isBlocking || isOnlyOneAbility || isCombinedAbilityMode) {
        if !isInVehicle {
            let playerData = EquipmentSystem.GetData(this);
            let berserkItem = playerData.GetTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Berserk");

            attempted = true;
            if ItemActionsHelper.UseItem(this, berserkItem) {
                activated = true;
            }
        }
    }

    if hasSandevistan && ((!isFocusMode && !isBlocking) || isOnlyOneAbility || isCombinedAbilityMode) {
        if TimeDilationHelper.CanUseTimeDilation(this) {
            let playerData = EquipmentSystem.GetData(this);
            let sandevistanItem = playerData.GetTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Sandevistan");

            attempted = true;
            if ItemActionsHelper.UseItem(this, sandevistanItem) {
                activated = true;
            }
        }
    }

    if attempted {
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
