@addField(HotkeysWidgetController)
private let m_cyberwares: array<wref<inkWidget>>;

@wrapMethod(HotkeysWidgetController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    let container = inkWidgetRef.Get(this.m_dpadHintsPanel) as inkCompoundWidget;
    let cyberwarePos = container.GetNumChildren() - 3;

    ArrayPush(this.m_cyberwares, this.m_cyberware);
    ArrayPush(this.m_cyberwares, this.SpawnFromLocal(container, n"cyberware"));
    ArrayPush(this.m_cyberwares, this.SpawnFromLocal(container, n"cyberware"));

    let i = 0;
    let cyberwareTypes = [n"Cyberdeck", n"Sandevistan", n"Berserk"];
    while i < ArraySize(cyberwareTypes) {
        this.m_cyberwares[i].SetName(cyberwareTypes[i]);
        if i >= 1 {
            container.ReorderChild(this.m_cyberwares[i], cyberwarePos + i);
        }
        i += 1;
    }
}
