import CyberwareEx.*

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    if this.IsControlledByLocalPeer() || IsHost() {
        this.RegisterInputListener(this, n"ToggleSprint");
    }
}

@addField(PlayerPuppet)
private let cj_scanner_CyberwareAction_Pressed: Bool;

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_Scanner).GetBool(GetAllBlackboardDefs().UI_Scanner.UIVisible) {
        if Equals(ListenerAction.GetName(action), n"IconicCyberware") {
            let inputType:gameinputActionType = ListenerAction.GetType(action);
            if Equals(inputType, gameinputActionType.BUTTON_RELEASED) || Equals(inputType, gameinputActionType.BUTTON_HOLD_COMPLETE) {
                this.cj_scanner_CyberwareAction_Pressed = false;
            } else if Equals(inputType, gameinputActionType.BUTTON_PRESSED) || !this.cj_scanner_CyberwareAction_Pressed {    // BUTTON_HOLD_PROGRESS
                this.cj_scanner_CyberwareAction_Pressed = true;
                this.ActivateIconicCyberware();
                return true;
            }
        }
    } else {
        this.cj_scanner_CyberwareAction_Pressed = false;
    }
    
    wrappedMethod(action, consumer);
}

@replaceMethod(PlayerPuppet)
private final func ActivateIconicCyberware() {
    let equipmentData = EquipmentSystem.GetData(this);
    let characterData = PlayerDevelopmentSystem.GetData(this);

    let hasBerserk = equipmentData.HasTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Berserk");
    let hasSandevistan = equipmentData.HasTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Sandevistan");
    let hasOverclock = equipmentData.HasTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Cyberdeck")
        && characterData.IsNewPerkBought(gamedataNewPerkType.Intelligence_Central_Milestone_3) == 3;

    let numberOfAbilities = (hasBerserk ? 1 : 0) + (hasSandevistan ? 1 : 0) + (hasOverclock ? 1 : 0);
    if numberOfAbilities == 0 {
        return;
    }

    let isOnlyOneAbility = numberOfAbilities == 1;
    let isCombinedAbilityMode = IsCombinedAbilityMode();

    let statsSystem = GameInstance.GetStatsSystem(this.GetGame());
    let playerStatsId = Cast<StatsObjectID>(this.GetEntityID());
    let canUseOverclock = statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.CanUseOverclock);
    let canUseBerserk = statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasBerserk);
    let canUseSandevistan = statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasSandevistan);

    let psmBlackboard = this.GetPlayerStateMachineBlackboard();
    let meleeWeaponState = IntEnum<gamePSMMeleeWeapon>(psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    let rangedWeaponState = IntEnum<gamePSMUpperBodyStates>(psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody));

    let isFocusMode = Equals(IntEnum<gamePSMVision>(psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vision)), gamePSMVision.Focus);
    let isBlocking = Equals(meleeWeaponState, gamePSMMeleeWeapon.Block) || Equals(meleeWeaponState, gamePSMMeleeWeapon.BlockAttack) || Equals(meleeWeaponState, gamePSMMeleeWeapon.Deflect) || Equals(meleeWeaponState, gamePSMMeleeWeapon.DeflectAttack) || (Equals(rangedWeaponState, gamePSMUpperBodyStates.Aim) && equipmentData.HasTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"VultureBerserk"));
    let isInVehicle = psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.MountedToVehicle);

    let attempted = false;
    let activated = false;
    let charging = true;

    if hasOverclock && (isOnlyOneAbility || isFocusMode || isCombinedAbilityMode) {
        if canUseOverclock {
            attempted = true;
            if QuickHackableHelper.IsOverclockedStateActive(this) {
                charging = false;
            }
            if QuickHackableHelper.TryToCycleOverclockedState(this) || !charging {
                activated = true;
            }
        }
    }

    if hasBerserk && !isFocusMode && (isOnlyOneAbility || ((isBlocking || !hasSandevistan)) || isCombinedAbilityMode) {
        if canUseBerserk && !isInVehicle {
            let berserkItem = equipmentData.GetTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Berserk");

            attempted = true;
            if ItemActionsHelper.UseItem(this, berserkItem) {
                activated = true;
            }
        }
    }

    if hasSandevistan && !isFocusMode && (isOnlyOneAbility || ((!isBlocking || !hasBerserk)) || isCombinedAbilityMode) {
        if canUseSandevistan && TimeDilationHelper.CanUseTimeDilation(this) {
            let sandevistanItem = equipmentData.GetTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Sandevistan");

            attempted = true;
            if ItemActionsHelper.UseItem(this, sandevistanItem) {
                activated = true;
            }
        }
    }

    if attempted {
        if activated {
            this.IconicCyberwareActivated();
        } else if charging {
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
