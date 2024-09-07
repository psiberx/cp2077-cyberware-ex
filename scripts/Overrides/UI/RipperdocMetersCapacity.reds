import CyberwareEx.*

@wrapMethod(RipperdocMetersCapacity)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    if IsExtendedMode() || IsOverrideMode() || IsCustomMode() {
        let root = this.GetRootWidget();

        let margin = root.GetMargin();
        margin.left = 240;
        root.SetMargin(margin);
    }
}

@wrapMethod(RipperdocMetersCapacity)
protected cb func OnIntroAnimationFinished_METER(proxy: ref<inkAnimProxy>) -> Bool {
    wrappedMethod(proxy);

    if IsExtendedMode() || IsOverrideMode() || IsCustomMode() {
        let root = this.GetRootWidget();
        let parent = root.parentWidget as inkCompoundWidget;

        parent.ReorderChild(root, 0);
    }
}

@wrapMethod(RipperdocMetersCapacity)
private final func ConfigureBar(currentCapacity: Int32, addedCapacity: Int32, maxCapacity: Int32, overclockCapacity: Int32, isChange: Bool) {
    let finalCapacity = currentCapacity + addedCapacity;
    if (finalCapacity > Cast<Int32>(this.m_maxCapacityPossible)) {
        this.m_maxCapacityPossible = Cast<Float>(finalCapacity);
    }

    wrappedMethod(currentCapacity, addedCapacity, maxCapacity, overclockCapacity, isChange);
}
