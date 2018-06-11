import SceneKit

class Projectile : Entity {
    
    init(origin: SCNVector3, target: SCNVector3, colour: UIColor) {
        let projectileShape = SCNSphere(radius: 0.05)
        projectileShape.firstMaterial!.diffuse.contents = colour
        projectileShape.firstMaterial!.specular.contents = UIColor.white
        let node = SCNNode(geometry: projectileShape)
        node.position = origin
        let bitMask = Projectile.bitMask
        super.init(node, isMobile: true, mass: 0.1, isAffectedByGravity: false, isTemporary: true, physicsBody: SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: projectileShape, options: nil)), collisionBitMask: bitMask, contactBitMask: EnemyShip.bitMask)
        self.target = target
        
        self.setDiffProjectile(colour: colour)
        self.minZDist = 0.0
        
    }
    override public func modifyTarget() {
        self.target?.y += self.gravity
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
}
