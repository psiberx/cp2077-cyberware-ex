import CyberwareEx.*

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    wrappedMethod();

    if this.IsControlledByLocalPeer() || IsHost() {
        this.RegisterInputListener(this, n"ToggleSprint");
    }
}

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if Equals(ListenerAction.GetName(action), n"IconicCyberware") {
    	let isFocusMode = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_Scanner).GetBool(GetAllBlackboardDefs().UI_Scanner.UIVisible);

    	if Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
			let equipmentData = EquipmentSystem.GetData(this);
			let characterData = PlayerDevelopmentSystem.GetData(this);

			let hasBerserk = equipmentData.HasTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Berserk");
			let hasSandevistan = equipmentData.HasTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Sandevistan");
			let hasOverclock = equipmentData.HasTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Cyberdeck")
				&& characterData.IsNewPerkBought(gamedataNewPerkType.Intelligence_Central_Milestone_3) == 3;

			let numberOfAbilities = (hasBerserk ? 1 : 0) + (hasSandevistan ? 1 : 0) + (hasOverclock ? 1 : 0);
			if numberOfAbilities > 1 && hasOverclock {
				this.m_CWMaskInVehicleInputHeld = true;
			} else {
				if !isFocusMode {
					this.ActivateIconicCyberware();
				}
			}

			return true;
        }

		if Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_HOLD_COMPLETE) {
			this.m_CWMaskInVehicleInputHeld = false;
			this.ExecuteCWMask();

			return true;
		}

		if Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
			if this.m_CWMaskInVehicleInputHeld {
				this.m_CWMaskInVehicleInputHeld = false;
				if !isFocusMode {
					this.ActivateIconicCyberware();
				}
			}

			return true;
		}
    } else {
        wrappedMethod(action, consumer);
    }
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

    let statsSystem = GameInstance.GetStatsSystem(this.GetGame());
    let playerStatsId = Cast<StatsObjectID>(this.GetEntityID());
    let canUseBerserk = statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasBerserk);
    let canUseSandevistan = statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasSandevistan);

    let psmBlackboard = this.GetPlayerStateMachineBlackboard();
    let meleeWeaponState = IntEnum<gamePSMMeleeWeapon>(psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));

    let isFocusMode = Equals(IntEnum<gamePSMVision>(psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vision)), gamePSMVision.Focus);
    let isBlocking = Equals(meleeWeaponState, gamePSMMeleeWeapon.Block) || Equals(meleeWeaponState, gamePSMMeleeWeapon.BlockAttack)
        || Equals(meleeWeaponState, gamePSMMeleeWeapon.Deflect) || Equals(meleeWeaponState, gamePSMMeleeWeapon.DeflectAttack);
    let isInVehicle = psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.MountedToVehicle);

    let wasAttempted = false;
    let wasActivated = false;

    if hasOverclock && !isFocusMode && isOnlyOneAbility {
        wasAttempted = true;
        if QuickHackableHelper.TryToCycleOverclockedState(this) {
            wasActivated = true;
        }
    }

    if hasBerserk && !isFocusMode && (isOnlyOneAbility || isBlocking || !hasSandevistan) {
        if canUseBerserk && !isInVehicle {
            let berserkItem = equipmentData.GetTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Berserk");

            wasAttempted = true;
            if ItemActionsHelper.UseItem(this, berserkItem) {
                wasActivated = true;
            }
        }
    }

    if hasSandevistan && !isFocusMode && (isOnlyOneAbility || !isBlocking || !hasBerserk) {
        if canUseSandevistan && TimeDilationHelper.CanUseTimeDilation(this) {
            let sandevistanItem = equipmentData.GetTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Sandevistan");

            wasAttempted = true;
            if ItemActionsHelper.UseItem(this, sandevistanItem) {
                wasActivated = true;
            }
        }
    }

    if wasAttempted {
        if wasActivated {
            this.IconicCyberwareActivated();
        } else {
            let audioEvent = new SoundPlayEvent();
            audioEvent.soundName = n"ui_grenade_empty";

            this.QueueEvent(audioEvent);
        }

        let dpadAction = new DPADActionPerformed();
        dpadAction.action = EHotkey.LBRB;
        dpadAction.state = EUIActionState.COMPLETED;
        dpadAction.successful = wasActivated;

        GameInstance.GetUISystem(this.GetGame()).QueueEvent(dpadAction);
    }
}

@replaceMethod(PlayerPuppet)
private final func ExecuteCWMask() {
    let equipmentData = EquipmentSystem.GetData(this);
    let characterData = PlayerDevelopmentSystem.GetData(this);

	let hasMask = this.HasCWMask();
    let hasOverclock = equipmentData.HasTaggedItem(gamedataEquipmentArea.SystemReplacementCW, n"Cyberdeck")
        && characterData.IsNewPerkBought(gamedataNewPerkType.Intelligence_Central_Milestone_3) == 3;

    let wasAttempted = false;
    let wasActivated = false;
    let isAbility = false;

    if hasOverclock {
        isAbility = true;
        wasAttempted = true;
        if QuickHackableHelper.TryToCycleOverclockedState(this) {
            wasActivated = true;
        }
    }

	if hasMask && !isAbility {
		wasAttempted = true;
		wasActivated = ItemActionsHelper.UseItem(this, this.GetCWMaskID());
	}

    if wasAttempted {
        if isAbility {
			if wasActivated {
				this.IconicCyberwareActivated();
			} else {
				let audioEvent = new SoundPlayEvent();
				audioEvent.soundName = n"ui_grenade_empty";

				this.QueueEvent(audioEvent);
			}
        }

        let dpadAction = new DPADActionPerformed();
		dpadAction.action = isAbility ? EHotkey.LBRB : EHotkey.RB;
		dpadAction.state = EUIActionState.COMPLETED;
		dpadAction.successful = wasActivated;

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
