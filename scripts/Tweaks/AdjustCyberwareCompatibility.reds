module CyberwareEx

class AdjustCyberwareCompatibility extends ScriptableTweak {
    protected func OnApply() {
        // Enable Sandevistan + Berserk combination
        TweakDBManager.SetFlat(t"BaseStatusEffect.BerserkTimeDilationEffector.effectorClassName", n"");
        TweakDBManager.UpdateRecord(t"BaseStatusEffect.BerserkTimeDilationEffector");

        // Allow double jump after charge jump
        let chargeJumpTransitions = TweakDBInterface.GetStringArray(t"playerStateMachineLocomotion.chargeJump.transitionTo");
        let chargeJumpConditions = TweakDBInterface.GetStringArray(t"playerStateMachineLocomotion.chargeJump.transitionCondition");
        if !ArrayContains(chargeJumpTransitions, "doubleJump") {
            ArrayPush(chargeJumpTransitions, "doubleJump");
            ArrayPush(chargeJumpConditions, "");
            TweakDBManager.SetFlat(t"playerStateMachineLocomotion.chargeJump.transitionTo", chargeJumpTransitions);
            TweakDBManager.SetFlat(t"playerStateMachineLocomotion.chargeJump.transitionCondition", chargeJumpConditions);
        }
    }
}
