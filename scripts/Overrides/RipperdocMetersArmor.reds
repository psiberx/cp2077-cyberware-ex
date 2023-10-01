@wrapMethod(RipperdocMetersArmor)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    let margin = this.GetRootWidget().GetMargin();
    margin.right = 370;

    this.GetRootWidget().SetMargin(margin);
}
