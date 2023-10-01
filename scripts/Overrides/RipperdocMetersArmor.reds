import CyberwareEx.*

@wrapMethod(RipperdocMetersArmor)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    if IsExtendedMode() || IsOverrideMode() {
        let margin = this.GetRootWidget().GetMargin();
        margin.right = 370;

        this.GetRootWidget().SetMargin(margin);
    }
}
