class UevRegistry {
    # Property: Holds name
    [String] $Name
    # Determines how UE-V Settings are applied to the device
    [Flags()] enum ApplicationMethod {
        # Preference is active if UE-V settings are changed via PowerShell or WinRM
        Preference = 1
        # GroupPolicy is active if UE-V Settings are changed via GPO
        GroupPolicy = 2
    }

    # Constructor: Creates a new MyClass object, with the specified name
    MyClass([String] $NewName) {
        # Set name for MyClass
        $this.Name = $NewName
    }

    # Method: Method that changes $Name to the default name
    [void] ChangeNameToDefault() {
        $this.Name = "DefaultName"
    }
}