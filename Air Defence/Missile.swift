import SceneKit

class Missile : Entity {
    
    init(origin: SCNVector3, target: SCNVector3, enemy: Bool, reversed: Bool = false) {
        let node = Missile.scene!.rootNode.clone()
        node.scale = SCNVector3(0.05, 0.05, 0.05)
        node.position = origin
        let bitMask = Missile.bitMask
        var yOffset: Float = 0.5 * Float.pi
        if reversed {
            yOffset = -yOffset
        }
        super.init(node, isMobile: true, mass: 0.1, isAffectedByGravity: false, isTemporary: true, physicsBody: SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0), options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])), collisionBitMask: bitMask, contactBitMask: EnemyShip.bitMask & Flare.bitMask, rotationOffsets: SCNVector3(0.0, yOffset, 0.0), enemy: enemy, rotationallyFixed: false, lookAtPoint: target, minZDist: 0.0, speed: 7.5, target: target)
        super.startRotating()
    }
    
    // Bit Masks
    public static let bitMask = 2
    
    // Range
    public static let start: Float = 0.5
    public static let end: Float = 60.0
    
    // Scene
    public static var scene: SCNScene?
}
