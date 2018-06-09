import ARKit
import SceneKit

class Entity {
    
    init(_ parentNode: SCNNode, _ node: SCNNode, nodeID: Int, isMobile: Bool, mass: CGFloat, isAffectedByGravity: Bool, isTemporary: Bool, physicsBody: SCNPhysicsBody, collisionBitMask: Int, contactBitMask: Int) {
        self.node = node
        self.parentNode = parentNode
        self.isMobile = isMobile
        self.isTemporary = isTemporary
        id = String(nodeID)
        
        node.name = id
        node.physicsBody = physicsBody
        node.physicsBody?.mass = mass
        node.physicsBody?.isAffectedByGravity = isAffectedByGravity
        node.physicsBody?.categoryBitMask = collisionBitMask
        node.physicsBody?.collisionBitMask = collisionBitMask
        node.physicsBody?.contactTestBitMask = contactBitMask
        parentNode.addChildNode(node)
    }
    
    public func dead() -> Bool {
        return isDead
    }
    
    public func die() {
        isDead = true
        node.removeFromParentNode()
    }
    
    public func getID() -> String {
        return id
    }
    
    // The rotating feature is for showcasing the ship, not for gameplay.
    public func startRotating() {
        isRotating = true
    }
    
    public func stopRotating() {
        isRotating = false
    }

    public func update(_ view: ARSCNView) {
        if !dead() {
            // Using a time counter should be okay because the frame rate seems to be capped at sixty FPS.
            // I would prefer to use a timer, but I found Swift's various timer functions to be too inaccurate, perhaps due to user error.
            counter = counter &+ 1
            
            if isRotating {
                node.eulerAngles = SCNVector3Make(0, Float(counter % 360) / 180.0 * Float.pi, 0)
            }
            
            if isMobile, let target = target {
                let nodeCol = node.presentation.position
                let distRaw = SCNVector3(target.x - nodeCol.x, target.y - nodeCol.y, target.z - nodeCol.z - minZDist)
                let dist = (distRaw.x * distRaw.x + distRaw.y * distRaw.y + distRaw.z * distRaw.z).squareRoot()
                let speedFactor = (abs(dist) < distBuffer ? 0.0 : speed / dist)
                if isTemporary && speedFactor == 0.0 {
                    die()
                }
                // TODO: Make moving entity face target.
                node.physicsBody?.velocity = SCNVector3(distRaw.x * speedFactor, distRaw.y * speedFactor, distRaw.z * speedFactor)
            }
        }
    }
    
    // Death
    private var isDead: Bool = false
    private var isTemporary: Bool
    
    // ID
    private var id: String = ""

    // Movement
    private let distBuffer: Float = 0.5
    private var isMobile: Bool = false
    public var minZDist: Float = 2.0
    public var speed: Float = 5.0
    public var target: SCNVector3?

    // Rotation
    private var isRotating: Bool = false

    // SCNNode
    private var node: SCNNode
    private var parentNode: SCNNode

    // Time counter
    private var counter: UInt64 = 0

}
