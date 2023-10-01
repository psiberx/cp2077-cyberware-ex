import CyberwareEx.*

@wrapMethod(RipperdocMetersCapacity)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    if IsExtendedMode() || IsOverrideMode() {
        let margin = this.GetRootWidget().GetMargin();
        margin.left = 240;

        this.GetRootWidget().SetMargin(margin);
    }
}
