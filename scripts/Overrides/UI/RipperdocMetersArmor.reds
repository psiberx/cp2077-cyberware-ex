import CyberwareEx.*

@wrapMethod(RipperdocMetersArmor)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    if IsExtendedMode() || IsOverrideMode() || IsCustomMode() {
        let root = this.GetRootWidget();

        let margin = root.GetMargin();
        margin.right = 370;
        root.SetMargin(margin);
    }
}

@wrapMethod(RipperdocMetersArmor)
protected cb func OnIntroAnimationFinished_METER(proxy: ref<inkAnimProxy>) -> Bool {
    wrappedMethod(proxy);

    if IsExtendedMode() || IsOverrideMode() || IsCustomMode() {
        let root = this.GetRootWidget();
        let parent = root.parentWidget as inkCompoundWidget;

        parent.ReorderChild(root, 0);
    }
}
