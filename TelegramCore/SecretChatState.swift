import Foundation
#if os(macOS)
    import PostboxMac
#else
    import Postbox
#endif

public enum SecretChatRole: Int32 {
    case creator
    case participant
}

enum SecretChatLayer: Int32 {
    case layer8 = 8
    case layer46 = 46
}

public struct SecretChatKeySha1Fingerprint: Coding, Equatable {
    public let k0: Int64
    public let k1: Int64
    public let k2: Int32
    
    init(digest: Data) {
        assert(digest.count == 20)
        var k0: Int64 = 0
        var k1: Int64 = 0
        var k2: Int32 = 0
        digest.withUnsafeBytes { (bytes: UnsafePointer<Int64>) -> Void in
            k0 = bytes.pointee
            k1 = bytes.advanced(by: 1).pointee
        }
        digest.withUnsafeBytes { (bytes: UnsafePointer<Int32>) -> Void in
            k2 = bytes.advanced(by: 4).pointee
        }
        self.k0 = k0
        self.k1 = k1
        self.k2 = k2
    }
    
    public init(k0: Int64, k1: Int64, k2: Int32) {
        self.k0 = k0
        self.k1 = k1
        self.k2 = k2
    }
    
    public init(decoder: Decoder) {
        self.k0 = decoder.decodeInt64ForKey("k0")
        self.k1 = decoder.decodeInt64ForKey("k1")
        self.k2 = decoder.decodeInt32ForKey("k2")
    }
    
    public func encode(_ encoder: Encoder) {
        encoder.encodeInt64(self.k0, forKey: "k0")
        encoder.encodeInt64(self.k1, forKey: "k1")
        encoder.encodeInt32(self.k2, forKey: "k2")
    }
    
    public func data() -> Data {
        var data = Data()
        data.count = 20
        data.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<Int64>) -> Void in
            bytes.pointee = self.k0
            bytes.advanced(by: 1).pointee = self.k1
        }
        data.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<Int32>) -> Void in
            bytes.advanced(by: 4).pointee = self.k2
        }
        return data
    }
    
    public static func ==(lhs: SecretChatKeySha1Fingerprint, rhs: SecretChatKeySha1Fingerprint) -> Bool {
        if lhs.k0 != rhs.k0 {
            return false
        }
        if lhs.k1 != rhs.k1 {
            return false
        }
        if lhs.k2 != rhs.k2 {
            return false
        }
        return true
    }
}

public struct SecretChatKeySha256Fingerprint: Coding, Equatable {
    public let k0: Int64
    public let k1: Int64
    public let k2: Int64
    public let k3: Int64
    
    init(digest: Data) {
        assert(digest.count == 32)
        var k0: Int64 = 0
        var k1: Int64 = 0
        var k2: Int64 = 0
        var k3: Int64 = 0
        digest.withUnsafeBytes { (bytes: UnsafePointer<Int64>) -> Void in
            k0 = bytes.pointee
            k1 = bytes.advanced(by: 1).pointee
            k2 = bytes.advanced(by: 2).pointee
            k3 = bytes.advanced(by: 3).pointee
        }
        self.k0 = k0
        self.k1 = k1
        self.k2 = k2
        self.k3 = k3
    }
    
    public init(k0: Int64, k1: Int64, k2: Int64, k3: Int64) {
        self.k0 = k0
        self.k1 = k1
        self.k2 = k2
        self.k3 = k3
    }
    
    public init(decoder: Decoder) {
        self.k0 = decoder.decodeInt64ForKey("k0")
        self.k1 = decoder.decodeInt64ForKey("k1")
        self.k2 = decoder.decodeInt64ForKey("k2")
        self.k3 = decoder.decodeInt64ForKey("k3")
    }
    
    public func encode(_ encoder: Encoder) {
        encoder.encodeInt64(self.k0, forKey: "k0")
        encoder.encodeInt64(self.k1, forKey: "k1")
        encoder.encodeInt64(self.k2, forKey: "k2")
        encoder.encodeInt64(self.k3, forKey: "k3")
    }
    
    public func data() -> Data {
        var data = Data()
        data.count = 32
        data.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<Int64>) -> Void in
            bytes.pointee = self.k0
            bytes.advanced(by: 1).pointee = self.k1
            bytes.advanced(by: 2).pointee = self.k2
            bytes.advanced(by: 3).pointee = self.k3
        }
        return data
    }
    
    public static func ==(lhs: SecretChatKeySha256Fingerprint, rhs: SecretChatKeySha256Fingerprint) -> Bool {
        if lhs.k0 != rhs.k0 {
            return false
        }
        if lhs.k1 != rhs.k1 {
            return false
        }
        if lhs.k2 != rhs.k2 {
            return false
        }
        if lhs.k3 != rhs.k3 {
            return false
        }
        return true
    }
}

public struct SecretChatKeyFingerprint: Coding, Equatable {
    public let sha1: SecretChatKeySha1Fingerprint
    public let sha256: SecretChatKeySha256Fingerprint
    
    init(sha1: SecretChatKeySha1Fingerprint, sha256: SecretChatKeySha256Fingerprint) {
        self.sha1 = sha1
        self.sha256 = sha256
    }
    
    public init(decoder: Decoder) {
        self.sha1 = decoder.decodeObjectForKey("1", decoder: { SecretChatKeySha1Fingerprint(decoder: $0) }) as! SecretChatKeySha1Fingerprint
        self.sha256 = decoder.decodeObjectForKey("2", decoder: { SecretChatKeySha256Fingerprint(decoder: $0) }) as! SecretChatKeySha256Fingerprint
    }
    
    public func encode(_ encoder: Encoder) {
        encoder.encodeObject(self.sha1, forKey: "1")
        encoder.encodeObject(self.sha256, forKey: "2")
    }
    
    public static func ==(lhs: SecretChatKeyFingerprint, rhs: SecretChatKeyFingerprint) -> Bool {
        return lhs.sha1 == rhs.sha1 && lhs.sha256 == rhs.sha256
    }
}

public enum SecretChatEmbeddedPeerState: Int32 {
    case terminated = 0
    case handshake = 1
    case active = 2
}

private enum SecretChatEmbeddedStateValue: Int32 {
    case terminated = 0
    case handshake = 1
    case basicLayer = 2
    case sequenceBasedLayer = 3
}

enum SecretChatHandshakeState: Coding, Equatable {
    case accepting
    case requested(g: Int32, p: MemoryBuffer, a: MemoryBuffer)
    
    init(decoder: Decoder) {
        switch decoder.decodeInt32ForKey("r") as Int32 {
            case 0:
                self = .accepting
            case 1:
                self = .requested(g: decoder.decodeInt32ForKey("g"), p: decoder.decodeBytesForKey("p")!, a: decoder.decodeBytesForKey("a")!)
            default:
                self = .accepting
                assertionFailure()
        }
    }
    
    func encode(_ encoder: Encoder) {
        switch self {
            case .accepting:
                encoder.encodeInt32(0, forKey: "r")
            case let .requested(g, p, a):
                encoder.encodeInt32(1, forKey: "r")
                encoder.encodeInt32(g, forKey: "g")
                encoder.encodeBytes(p, forKey: "p")
                encoder.encodeBytes(a, forKey: "a")
        }
    }
    
    static func ==(lhs: SecretChatHandshakeState, rhs: SecretChatHandshakeState) -> Bool {
        switch lhs {
            case .accepting:
                if case .accepting = rhs {
                    return true
                } else {
                    return false
                }
            case let .requested(g, p, a):
                if case .requested(g, p, a) = rhs {
                    return true
                } else {
                    return false
                }
        }
    }
}

struct SecretChatLayerNegotiationState: Coding, Equatable {
    let activeLayer: Int32
    let locallyRequestedLayer: Int32?
    let remotelyRequestedLayer: Int32?
    
    init(activeLayer: Int32, locallyRequestedLayer: Int32?, remotelyRequestedLayer: Int32?) {
        self.activeLayer = activeLayer
        self.locallyRequestedLayer = locallyRequestedLayer
        self.remotelyRequestedLayer = remotelyRequestedLayer
    }
    
    init(decoder: Decoder) {
        self.activeLayer = decoder.decodeInt32ForKey("a")
        self.locallyRequestedLayer = decoder.decodeInt32ForKey("lr")
        self.remotelyRequestedLayer = decoder.decodeInt32ForKey("rr")
    }
    
    func encode(_ encoder: Encoder) {
        encoder.encodeInt32(self.activeLayer, forKey: "a")
        if let locallyRequestedLayer = self.locallyRequestedLayer {
            encoder.encodeInt32(locallyRequestedLayer, forKey: "lr")
        } else {
            encoder.encodeNil(forKey: "lr")
        }
        if let remotelyRequestedLayer = self.remotelyRequestedLayer {
            encoder.encodeInt32(remotelyRequestedLayer, forKey: "rr")
        } else {
            encoder.encodeNil(forKey: "rr")
        }
    }
    
    static func ==(lhs: SecretChatLayerNegotiationState, rhs: SecretChatLayerNegotiationState) -> Bool {
        if lhs.activeLayer != rhs.activeLayer {
            return false
        }
        if lhs.locallyRequestedLayer != rhs.locallyRequestedLayer {
            return false
        }
        if lhs.remotelyRequestedLayer != rhs.remotelyRequestedLayer {
            return false
        }
        return true
    }
    
    func withUpdatedRemotelyRequestedLayer(_ remotelyRequestedLayer: Int32?) -> SecretChatLayerNegotiationState {
        return SecretChatLayerNegotiationState(activeLayer: self.activeLayer, locallyRequestedLayer: self.locallyRequestedLayer, remotelyRequestedLayer: remotelyRequestedLayer)
    }
}

private enum SecretChatRekeySessionDataValue: Int32 {
    case requesting = 0
    case requested = 1
    case accepting = 2
    case accepted = 3
}

enum SecretChatRekeySessionData: Coding, Equatable {
    case requesting
    case requested(a: MemoryBuffer, config: SecretChatEncryptionConfig)
    case accepting
    case accepted(key: MemoryBuffer, keyFingerprint: Int64)
    
    init(decoder: Decoder) {
        switch decoder.decodeInt32ForKey("r") as Int32 {
            case SecretChatRekeySessionDataValue.requesting.rawValue:
                self = .requesting
            case SecretChatRekeySessionDataValue.requested.rawValue:
                self = .requested(a: decoder.decodeBytesForKey("a")!, config: decoder.decodeObjectForKey("c", decoder: { SecretChatEncryptionConfig(decoder: $0) }) as! SecretChatEncryptionConfig)
            case SecretChatRekeySessionDataValue.accepting.rawValue:
                self = .accepting
            case SecretChatRekeySessionDataValue.accepted.rawValue:
                self = .accepted(key: decoder.decodeBytesForKey("k")!, keyFingerprint: decoder.decodeInt64ForKey("f"))
            default:
                preconditionFailure()
        }
    }
    
    func encode(_ encoder: Encoder) {
        switch self {
            case .requesting:
                encoder.encodeInt32(SecretChatRekeySessionDataValue.requesting.rawValue, forKey: "r")
            case let .requested(a, config):
                encoder.encodeInt32(SecretChatRekeySessionDataValue.requested.rawValue, forKey: "r")
                encoder.encodeBytes(a, forKey: "a")
                encoder.encodeObject(config, forKey: "c")
            case .accepting:
                encoder.encodeInt32(SecretChatRekeySessionDataValue.accepting.rawValue, forKey: "r")
            case let .accepted(key, keyFingerprint):
                encoder.encodeInt32(SecretChatRekeySessionDataValue.accepted.rawValue, forKey: "r")
                encoder.encodeBytes(key, forKey: "k")
                encoder.encodeInt64(keyFingerprint, forKey: "f")
        }
    }
    
    static func ==(lhs: SecretChatRekeySessionData, rhs: SecretChatRekeySessionData) -> Bool {
        switch lhs {
            case .requesting:
                if case .requesting = rhs {
                    return true
                } else {
                    return false
                }
            case let .requested(a, _):
                if case .requested(a, _) = rhs {
                    return true
                } else {
                    return false
                }
            case .accepting:
                if case .accepting = rhs {
                    return true
                } else {
                    return false
                }
            case let .accepted(key, keyFingerprint):
                if case .accepted(key, keyFingerprint) = rhs {
                    return true
                } else {
                    return false
                }
        }
    }
}

struct SecretChatRekeySessionState: Coding, Equatable {
    let id: Int64
    let data: SecretChatRekeySessionData
    
    init(id: Int64, data: SecretChatRekeySessionData) {
        self.id = id
        self.data = data
    }
    
    init(decoder: Decoder) {
        self.id = decoder.decodeInt64ForKey("i")
        self.data = decoder.decodeObjectForKey("d", decoder: { SecretChatRekeySessionData(decoder: $0) }) as! SecretChatRekeySessionData
    }
    
    func encode(_ encoder: Encoder) {
        encoder.encodeInt64(self.id, forKey: "i")
        encoder.encodeObject(self.data, forKey: "d")
    }
    
    static func ==(lhs: SecretChatRekeySessionState, rhs: SecretChatRekeySessionState) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.data != rhs.data {
            return false
        }
        return true
    }
}

struct SecretChatSequenceBasedLayerState: Coding, Equatable {
    let layerNegotiationState: SecretChatLayerNegotiationState
    let rekeyState: SecretChatRekeySessionState?
    let baseIncomingOperationIndex: Int32
    let baseOutgoingOperationIndex: Int32
    let topProcessedCanonicalIncomingOperationIndex: Int32?
    
    init(layerNegotiationState: SecretChatLayerNegotiationState, rekeyState: SecretChatRekeySessionState?, baseIncomingOperationIndex: Int32, baseOutgoingOperationIndex: Int32, topProcessedCanonicalIncomingOperationIndex: Int32?) {
        self.layerNegotiationState = layerNegotiationState
        self.rekeyState = rekeyState
        self.baseIncomingOperationIndex = baseIncomingOperationIndex
        self.baseOutgoingOperationIndex = baseOutgoingOperationIndex
        self.topProcessedCanonicalIncomingOperationIndex = topProcessedCanonicalIncomingOperationIndex
    }
    
    init(decoder: Decoder) {
        self.layerNegotiationState = decoder.decodeObjectForKey("ln", decoder: { SecretChatLayerNegotiationState(decoder: $0) }) as! SecretChatLayerNegotiationState
        self.rekeyState = decoder.decodeObjectForKey("rs", decoder: { SecretChatRekeySessionState(decoder: $0) }) as? SecretChatRekeySessionState
        self.baseIncomingOperationIndex = decoder.decodeInt32ForKey("bi")
        self.baseOutgoingOperationIndex = decoder.decodeInt32ForKey("bo")
        if let topProcessedCanonicalIncomingOperationIndex = decoder.decodeInt32ForKey("pi") as Int32? {
            self.topProcessedCanonicalIncomingOperationIndex = topProcessedCanonicalIncomingOperationIndex
        } else {
            self.topProcessedCanonicalIncomingOperationIndex = nil
        }
    }
    
    func encode(_ encoder: Encoder) {
        encoder.encodeObject(self.layerNegotiationState, forKey: "ln")
        if let rekeyState = self.rekeyState {
            encoder.encodeObject(rekeyState, forKey: "rs")
        } else {
            encoder.encodeNil(forKey: "rs")
        }
        encoder.encodeInt32(self.baseIncomingOperationIndex, forKey: "bi")
        encoder.encodeInt32(self.baseOutgoingOperationIndex, forKey: "bo")
        if let topProcessedCanonicalIncomingOperationIndex = self.topProcessedCanonicalIncomingOperationIndex {
            encoder.encodeInt32(topProcessedCanonicalIncomingOperationIndex, forKey: "pi")
        } else {
            encoder.encodeNil(forKey: "pi")
        }
    }
    
    func canonicalIncomingOperationIndex(_ index: Int32) -> Int32 {
        return index - self.baseIncomingOperationIndex
    }
    
    func canonicalOutgoingOperationIndex(_ index: Int32) -> Int32 {
        return index - self.baseOutgoingOperationIndex
    }
    
    func outgoingOperationIndexFromCanonicalOperationIndex(_ index: Int32) -> Int32 {
        return index + self.baseOutgoingOperationIndex
    }
    
    func withUpdatedLayerNegotiationState(_ layerNegotiationState: SecretChatLayerNegotiationState) -> SecretChatSequenceBasedLayerState {
        return SecretChatSequenceBasedLayerState(layerNegotiationState: layerNegotiationState, rekeyState: self.rekeyState, baseIncomingOperationIndex: self.baseIncomingOperationIndex, baseOutgoingOperationIndex: self.baseOutgoingOperationIndex, topProcessedCanonicalIncomingOperationIndex: self.topProcessedCanonicalIncomingOperationIndex)
    }
    
    func withUpdatedRekeyState(_ rekeyState: SecretChatRekeySessionState?) -> SecretChatSequenceBasedLayerState {
        return SecretChatSequenceBasedLayerState(layerNegotiationState: self.layerNegotiationState, rekeyState: rekeyState, baseIncomingOperationIndex: self.baseIncomingOperationIndex, baseOutgoingOperationIndex: self.baseOutgoingOperationIndex, topProcessedCanonicalIncomingOperationIndex: self.topProcessedCanonicalIncomingOperationIndex)
    }
    
    func withUpdatedTopProcessedCanonicalIncomingOperationIndex(_ topProcessedCanonicalIncomingOperationIndex: Int32?) -> SecretChatSequenceBasedLayerState {
        return SecretChatSequenceBasedLayerState(layerNegotiationState: self.layerNegotiationState, rekeyState: self.rekeyState, baseIncomingOperationIndex: self.baseIncomingOperationIndex, baseOutgoingOperationIndex: self.baseOutgoingOperationIndex, topProcessedCanonicalIncomingOperationIndex: topProcessedCanonicalIncomingOperationIndex)
    }
    
    static func ==(lhs: SecretChatSequenceBasedLayerState, rhs: SecretChatSequenceBasedLayerState) -> Bool {
        if lhs.layerNegotiationState != rhs.layerNegotiationState {
            return false
        }
        if lhs.rekeyState != rhs.rekeyState {
            return false
        }
        if lhs.baseIncomingOperationIndex != rhs.baseIncomingOperationIndex || lhs.baseOutgoingOperationIndex != rhs.baseOutgoingOperationIndex {
            return false
        }
        if lhs.topProcessedCanonicalIncomingOperationIndex != rhs.topProcessedCanonicalIncomingOperationIndex {
            return false
        }
        return true
    }
}

enum SecretChatEmbeddedState: Coding, Equatable {
    case terminated
    case handshake(SecretChatHandshakeState)
    case basicLayer
    case sequenceBasedLayer(SecretChatSequenceBasedLayerState)
    
    var peerState: SecretChatEmbeddedPeerState {
        switch self {
            case .terminated:
                return .terminated
            case .handshake:
                return .handshake
            case .basicLayer, .sequenceBasedLayer:
                return .active
        }
    }
    
    init(decoder: Decoder) {
        switch decoder.decodeInt32ForKey("r") as Int32 {
            case SecretChatEmbeddedStateValue.terminated.rawValue:
                self = .terminated
            case SecretChatEmbeddedStateValue.handshake.rawValue:
                self = .handshake(decoder.decodeObjectForKey("s", decoder: { SecretChatHandshakeState(decoder: $0) }) as! SecretChatHandshakeState)
            case SecretChatEmbeddedStateValue.basicLayer.rawValue:
                self = .basicLayer
            case SecretChatEmbeddedStateValue.sequenceBasedLayer.rawValue:
                self = .sequenceBasedLayer(decoder.decodeObjectForKey("s", decoder: { SecretChatSequenceBasedLayerState(decoder: $0) }) as! SecretChatSequenceBasedLayerState)
            default:
                assertionFailure()
                self = .terminated
        }
    }
    
    func encode(_ encoder: Encoder) {
        switch self {
            case .terminated:
                encoder.encodeInt32(SecretChatEmbeddedStateValue.terminated.rawValue, forKey: "r")
            case let .handshake(state):
                encoder.encodeInt32(SecretChatEmbeddedStateValue.handshake.rawValue, forKey: "r")
                encoder.encodeObject(state, forKey: "s")
            case .basicLayer:
                encoder.encodeInt32(SecretChatEmbeddedStateValue.basicLayer.rawValue, forKey: "r")
            case let .sequenceBasedLayer(state):
                encoder.encodeInt32(SecretChatEmbeddedStateValue.sequenceBasedLayer.rawValue, forKey: "r")
                encoder.encodeObject(state, forKey: "s")
        }
    }
    
    static func ==(lhs: SecretChatEmbeddedState, rhs: SecretChatEmbeddedState) -> Bool {
        switch lhs {
            case .terminated:
                if case .terminated = rhs {
                    return true
                } else {
                    return false
                }
            case let .handshake(state):
                if case .handshake(state) = rhs {
                    return true
                } else {
                    return false
                }
            case .basicLayer:
                if case .basicLayer = rhs {
                    return true
                } else {
                    return false
                }
            case let .sequenceBasedLayer(state):
                if case .sequenceBasedLayer(state) = rhs {
                    return true
                } else {
                    return false
                }
        }
    }
}

public protocol SecretChatKeyState {
    var keyFingerprint: SecretChatKeyFingerprint? { get }
}

final class SecretChatState: PeerChatState, SecretChatKeyState, Equatable {
    let role: SecretChatRole
    let embeddedState: SecretChatEmbeddedState
    let keychain: SecretChatKeychain
    let keyFingerprint: SecretChatKeyFingerprint?
    let messageAutoremoveTimeout: Int32?
    
    init(role: SecretChatRole, embeddedState: SecretChatEmbeddedState, keychain: SecretChatKeychain, keyFingerprint: SecretChatKeyFingerprint?, messageAutoremoveTimeout: Int32?) {
        self.role = role
        self.embeddedState = embeddedState
        self.keychain = keychain
        self.keyFingerprint = keyFingerprint
        self.messageAutoremoveTimeout = messageAutoremoveTimeout
    }
    
    init(decoder: Decoder) {
        self.role = SecretChatRole(rawValue: decoder.decodeInt32ForKey("r"))!
        self.embeddedState = decoder.decodeObjectForKey("s", decoder: { return SecretChatEmbeddedState(decoder: $0) }) as! SecretChatEmbeddedState
        self.keychain = decoder.decodeObjectForKey("k", decoder: { return SecretChatKeychain(decoder: $0) }) as! SecretChatKeychain
        self.keyFingerprint = decoder.decodeObjectForKey("f", decoder: { return SecretChatKeyFingerprint(decoder: $0) }) as? SecretChatKeyFingerprint
        self.messageAutoremoveTimeout = decoder.decodeInt32ForKey("a")
    }
    
    func encode(_ encoder: Encoder) {
        encoder.encodeInt32(self.role.rawValue, forKey: "r")
        encoder.encodeObject(self.embeddedState, forKey: "s")
        encoder.encodeObject(self.keychain, forKey: "k")
        if let keyFingerprint = self.keyFingerprint {
            encoder.encodeObject(keyFingerprint, forKey: "f")
        } else {
            encoder.encodeNil(forKey: "f")
        }
        if let messageAutoremoveTimeout = self.messageAutoremoveTimeout {
            encoder.encodeInt32(messageAutoremoveTimeout, forKey: "a")
        } else {
            encoder.encodeNil(forKey: "a")
        }
    }
    
    func equals(_ other: PeerChatState) -> Bool {
        if let other = other as? SecretChatState, other == self {
            return true
        }
        return false
    }
    
    static func ==(lhs: SecretChatState, rhs: SecretChatState) -> Bool {
        return lhs.role == rhs.role && lhs.embeddedState == rhs.embeddedState && lhs.keychain == rhs.keychain && lhs.messageAutoremoveTimeout == rhs.messageAutoremoveTimeout
    }
    
    func withUpdatedKeyFingerprint(_ keyFingerprint: SecretChatKeyFingerprint?) -> SecretChatState {
        return SecretChatState(role: self.role, embeddedState: self.embeddedState, keychain: self.keychain, keyFingerprint: keyFingerprint, messageAutoremoveTimeout: self.messageAutoremoveTimeout)
    }
    
    func withUpdatedEmbeddedState(_ embeddedState: SecretChatEmbeddedState) -> SecretChatState {
        return SecretChatState(role: self.role, embeddedState: embeddedState, keychain: self.keychain, keyFingerprint: self.keyFingerprint, messageAutoremoveTimeout: self.messageAutoremoveTimeout)
    }
    
    func withUpdatedKeychain(_ keychain: SecretChatKeychain) -> SecretChatState {
        return SecretChatState(role: self.role, embeddedState: self.embeddedState, keychain: keychain, keyFingerprint: self.keyFingerprint, messageAutoremoveTimeout: self.messageAutoremoveTimeout)
    }
    
    func withUpdatedMessageAutoremoveTimeout(_ messageAutoremoveTimeout: Int32?) -> SecretChatState {
        return SecretChatState(role: self.role, embeddedState: self.embeddedState, keychain: self.keychain, keyFingerprint: self.keyFingerprint, messageAutoremoveTimeout: messageAutoremoveTimeout)
    }
}
