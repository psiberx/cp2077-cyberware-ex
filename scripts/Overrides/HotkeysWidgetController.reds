@addField(HotkeysWidgetController)
private let m_cyberwares: array<wref<inkWidget>>;

@wrapMethod(HotkeysWidgetController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    ArrayPush(this.m_cyberwares, this.m_cyberware);
    ArrayPush(this.m_cyberwares, this.SpawnFromLocal(inkWidgetRef.Get(this.m_dpadHintsPanel), n"cyberware"));
    ArrayPush(this.m_cyberwares, this.SpawnFromLocal(inkWidgetRef.Get(this.m_dpadHintsPanel), n"cyberware"));

    let i = 0;
    let cyberwareTypes = [n"Cyberdeck", n"Sandevistan", n"Berserk"];
    while i < ArraySize(cyberwareTypes) {
        this.m_cyberwares[i].SetName(cyberwareTypes[i]);
        i += 1;
    }
}
