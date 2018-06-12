import ARKit
import Foundation
import SceneKit

class Entity {
    
    init(_ node: SCNNode, isMobile: Bool, mass: CGFloat, isAffectedByGravity: Bool, isTemporary: Bool, physicsBody: SCNPhysicsBody, collisionBitMask: Int, contactBitMask: Int, rotationOffsets: SCNVector3 = SCNVector3(0.0, 0.0, 0.0), rotationallyFixed: Bool = false) {
        self.node = node
        self.isMobile = isMobile
        self.isTemporary = isTemporary
        self.rotationOffsets = rotationOffsets
        self.rotationallyFixed = rotationallyFixed
        
        node.physicsBody = physicsBody
        node.physicsBody?.mass = mass
        node.physicsBody?.isAffectedByGravity = isAffectedByGravity
        node.physicsBody?.categoryBitMask = collisionBitMask
        node.physicsBody?.collisionBitMask = collisionBitMask
        node.physicsBody?.contactTestBitMask = contactBitMask
    }
    
    public func getPosition() -> SCNVector3 {
        return node.position
    }
    
    public func getTimeCount() -> UInt64 {
        return counter
    }
    
    public func dead() -> Bool {
        return isDead
    }
    
    public func die() {
        isDead = true
    }
    
    public func getID() -> String {
        return id
    }
    
    public func getNode() -> SCNNode {
        return node
    }
    
    public func remove() {
        let removeAction = SCNAction.removeFromParentNode()
        node.runAction(SCNAction.sequence([removeAction]))
    }
    public func modifyTarget() {
        // should implement in projectile
    }
    public func setID(_ id: Int) {
        self.id = String(id)
        node.name = self.id
    }
    
    // The rotating feature is for showcasing the ship, not for gameplay.
    public func startRotating() {
        isRotating = true
    }
    
    public func stopRotating() {
        isRotating = false
    }
    
    public func update(_ view: ViewController) {
        if !dead() {
            // Using a time counter should be okay because the frame rate seems to be capped at sixty FPS.
            // I would prefer to use a timer, but I found Swift's various timer functions to be too inaccurate, perhaps due to user error.
            counter = counter &+ 1
            
            if isRotating {
                node.eulerAngles = SCNVector3Make(0, Float(counter % 360) / 180.0 * Float.pi, 0)
            }
            self.modifyTarget()
            
            if isMobile, let target = target, let lookAtPoint = lookAtPoint {
                let nodePos = node.position
                let distRaw = SCNVector3(target.x - nodePos.x, target.y - nodePos.y, target.z - nodePos.z - minZDist)
                let dist = (distRaw.x * distRaw.x + distRaw.y * distRaw.y + distRaw.z * distRaw.z).squareRoot()
                let speedFactor = (abs(dist) < distBuffer ? 0.0 : speed / dist / ViewController.FPS)
                if isTemporary && speedFactor == 0.0 {
                    die()
                }
                node.position = SCNVector3(nodePos.x + distRaw.x * speedFactor, nodePos.y + distRaw.y * speedFactor, nodePos.z + distRaw.z * speedFactor)
                let distRawFromLookAtPoint = SCNVector3(lookAtPoint.x - nodePos.x, lookAtPoint.y - nodePos.y, lookAtPoint.z - nodePos.z)
                if rotationallyFixed {
                    node.eulerAngles = SCNVector3(rotationOffsets.x, rotationOffsets.y, rotationOffsets.z)
                }
                else {
                    node.eulerAngles = SCNVector3(sin(distRawFromLookAtPoint.y / distRawFromLookAtPoint.x) + rotationOffsets.x, sin(distRawFromLookAtPoint.x / distRawFromLookAtPoint.z) + rotationOffsets.y, sin(distRawFromLookAtPoint.y / distRawFromLookAtPoint.x) + rotationOffsets.z)
                }
                //node.physicsBody?.velocity = SCNVector3(distRaw.x * speedFactor, distRaw.y * speedFactor, distRaw.z * speedFactor)
                //node.physicsBody?.angularVelocity = SCNVector4(0.0, 1.0, 0.0, 1.0)
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
    public var lookAtPoint: SCNVector3?
    private var rotationallyFixed: Bool
    private var rotationOffsets: SCNVector3 // Offsets to make entity face forwards.
    
    // SCNNode
    private var node: SCNNode
    
    // Time counter
    private var counter: UInt64 = 0
    
    // Type
    public var isEnemy: Bool = false
    
}
