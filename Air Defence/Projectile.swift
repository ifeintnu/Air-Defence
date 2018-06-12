import SceneKit

class Projectile : Entity {
    
    init(origin: SCNVector3, target: SCNVector3, reversed: Bool = false) {
        let node = Projectile.scene!.rootNode.clone()
        node.scale = SCNVector3(0.05, 0.05, 0.05)
        node.position = origin
        let bitMask = Projectile.bitMask
        var yOffset: Float = 0.5 * Float.pi
        if reversed {
            yOffset = -yOffset
        }
        super.init(node, isMobile: true, mass: 0.1, isAffectedByGravity: false, isTemporary: true, physicsBody: SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0), options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])), collisionBitMask: bitMask, contactBitMask: EnemyShip.bitMask, rotationOffsets: SCNVector3(0.0, yOffset, 0.0))
        super.minZDist = 0.0
        super.speed = 7.5
        super.target = target
        super.lookAtPoint = target
        super.startRotating()
    }
    
    private func setDiffProjectile(colour: UIColor){
        switch colour {
        case UIColor.red: // quick
            self.speed = 15
        case UIColor.blue: // normal
            self.speed = 7.5
        case UIColor.cyan:
            self.speed = 7.5
            self.gravity = +0.15
        case UIColor.brown:
            self.speed = 7.5
            self.gravity = -0.15
        case UIColor.yellow:
            self.speed = 7.5
            self.left = 0.15
        case UIColor.green:
            self.speed = 7.5
            self.left = -0.15

        default:
            self.speed = 7.5
        }
    }
    // Bit Masks
    public static let bitMask = 2
    
    // Range
    public static let start: Float = 0.5
    public static let end: Float = 30.0
    
    // Gravity
    private var gravity: Float = 0.0
    private var left: Float = 0.0
    // Scene
    public static var scene: SCNScene?
}
