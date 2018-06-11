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
        xDelta = Float(arc4random_uniform(11)) - 5.0
        yDelta = Float(arc4random_uniform(7)) - 3.0
        zDelta = Float(arc4random_uniform(5)) - 2.5
        let zStart = Float(arc4random_uniform(100)) - 110.0
        node.position = SCNVector3(xDelta, yDelta, zStart)
        super.init(parentNode, node, nodeID: nodeID, isMobile: true, mass: 1.0, isAffectedByGravity: false, isTemporary: false, physicsBody: SCNPhysicsBody(type: .dynamic, shape: nil), collisionBitMask: bitMask, contactBitMask: Projectile.bitMask)
    }
    
    override public func update(_ view: ARSCNView) {
        let (direction, position) = ViewController.getCameraVector(view)
        let distanceFactor = Projectile.start
        // Random movement
        // TODO: What about when enemy ships bump into each other?
        /*if super.getTimeCount() % 60 == 0  {
            let rand = arc4random_uniform(8)
            if rand & 1 == 0 {
                xDelta = Float(arc4random_uniform(11)) - 5.0
            }
            if rand & 2 == 0 {
                yDelta = Float(arc4random_uniform(7)) - 3.0
            }
            if rand & 4 == 0 {
                zDelta = Float(arc4random_uniform(15)) - 17.5
            }
        }*/
        target = SCNVector3(position.x + (direction.x + xDelta) * distanceFactor, position.y + (direction.y + yDelta) * distanceFactor, position.z + (direction.z + zDelta) * distanceFactor)
        super.update(view)
    }

    // Bit Masks
    public static let bitMask = 1
    
    // Position in Formation
    private var xDelta: Float = 0
    private var yDelta: Float = 0
    private var zDelta: Float = 0

    // Rotation
    private let yRotationOffset: Float = 0.5 * Float.pi // Offset to make the ship face forwards rather than sideways.

    // Scene
    public static var scene: SCNScene?

}
