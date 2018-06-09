import ARKit
import SceneKit

class EnemyShip : Entity {
    
    init(parentNode: SCNNode, _ currentFrame: ARFrame) {
        let node = EnemyShip.scene!.rootNode.childNode(withName: "Ship_Type_3_Sphere.005_sh3", recursively: true)!
        super.init(parentNode, node, isMobile: true, mass: 1.0, isAffectedByGravity: false)

        node.pivot = SCNMatrix4MakeTranslation(-1.5, 0.0, 2.0) // This centres the ship with respect to its scene's root node.
        node.eulerAngles = SCNVector3Make(0, yRotationOffset, 0) // This rotates the ship to face forwards.
        node.position = SCNVector3(0.0, 0.0, -15.0)

        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.mass = 1.0
        node.physicsBody?.isAffectedByGravity = false
    }
    
    override public func update(_ view: SCNView) {
        target = view.pointOfView!.position
        super.update(view)
    }

    // Rotation
    private let yRotationOffset: Float = 0.5 * Float.pi // Offset to make the ship face forwards rather than sideways.

    // Scene
    public static var scene: SCNScene?

}
