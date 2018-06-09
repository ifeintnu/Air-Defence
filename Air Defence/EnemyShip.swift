import ARKit
import SceneKit

class EnemyShip : Entity {
    
    init(parentNode: SCNNode, nodeID: Int, _ currentFrame: ARFrame) {
        let node = EnemyShip.scene!.rootNode.childNode(withName: "Ship_Type_3_Sphere.005_sh3", recursively: true)!.clone()
        let bitMask = EnemyShip.bitMask
        
        // The following line is commented out because it moves the geometry away from the physics of the object, which breaks collision detection.
        // Ultimately, this problem had to be remedied in Blender.
        //node.pivot = SCNMatrix4MakeTranslation(-1.5, 0.0, 2.0) // This centres the ship with respect to its scene's root node.
        
        node.eulerAngles = SCNVector3Make(0, yRotationOffset, 0) // This rotates the ship to face forwards.
        let xPos = Int(arc4random_uniform(_: 11)) - 5
        let yPos = Int(arc4random_uniform(_: 7)) - 3
        let zPos = Int(arc4random_uniform(_:5)) - 15
        node.position = SCNVector3(xPos, yPos, zPos)
        super.init(parentNode, node, nodeID: nodeID, isMobile: true, mass: 1.0, isAffectedByGravity: false, isTemporary: false, physicsBody: SCNPhysicsBody(type: .dynamic, shape: nil), collisionBitMask: bitMask, contactBitMask: Projectile.bitMask)
    }
    
    override public func update(_ view: ARSCNView) {
        let (direction, position) = ViewController.getCameraVector(view)
        let distanceFactor = Projectile.start
        target = SCNVector3(position.x + direction.x * distanceFactor, position.y + direction.y * distanceFactor, position.z + direction.z * distanceFactor)
        super.update(view)
    }

    // Bit Masks
    public static let bitMask = 1

    // Rotation
    private let yRotationOffset: Float = 0.5 * Float.pi // Offset to make the ship face forwards rather than sideways.

    // Scene
    public static var scene: SCNScene?

}
