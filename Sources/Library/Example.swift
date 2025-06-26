public protocol P {
    var value: Int { get }
    func getValue() -> Int
}

extension Int: P {
    public var value: Int { self }
    public func getValue() -> Int { self }
}

public struct S: P {
    public let value: Int = 42
    public func getValue() -> Int { value }
}

public struct S2: P {
    public let value: Int = 42
    public let value2: Int = 42
    public let value3: Int = 42
    public let value4: Int = 42
    public let value5: Int = 42
    // Pushes it over a 40-byte boundary which fits one existential struct
    public let value6: Int = 42
    public func getValue() -> Int { value }
}

public class Box: P {
    public let v: Int
    public var value: Int { v }
    public init(_ v: Int = 42) { self.v = v }
    
    public func getValue() -> Int { v }
}

public func getAnyS() -> any P {
    S()
}

public func getAnyS2() -> any P {
    S2()
}

public func getSomeS() -> some P {
    S()
}

public func getSomeS2() -> some P {
    S2()
}

public func getAnyBox() -> any P {
    Box()
}

public func getAnyInt() -> any P {
    42
}

public func getSomeInt() -> some P {
    42
}

public func getAnyObjectBox() -> AnyObject {
    Box()
}