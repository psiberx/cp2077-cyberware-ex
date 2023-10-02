@addField(HotkeysWidgetController)
private let m_cyberwares: array<wref<inkWidget>>;

@wrapMethod(HotkeysWidgetController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    let panel = inkWidgetRef.Get(this.m_dpadHintsPanel) as inkCompoundWidget;
    let cyberwarePos = panel.GetNumChildren() - 3;

    ArrayPush(this.m_cyberwares, this.m_cyberware);
    ArrayPush(this.m_cyberwares, this.SpawnFromLocal(panel, n"cyberware"));
    ArrayPush(this.m_cyberwares, this.SpawnFromLocal(panel, n"cyberware"));

    let i = 0;
    let cyberwareTypes = [n"Cyberdeck", n"Sandevistan", n"Berserk"];
    while i < ArraySize(cyberwareTypes) {
        this.m_cyberwares[i].SetName(cyberwareTypes[i]);
        if i >= 1 {
            panel.ReorderChild(this.m_cyberwares[i], cyberwarePos + i);
        }
        i += 1;
    }
}
