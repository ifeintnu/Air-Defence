import SceneKit

class Projectile : Entity {
    
    init(parentNode: SCNNode, origin: SCNVector3, target: SCNVector3, colour: UIColor) {
        let projectileShape = SCNSphere(radius: 0.05)
        projectileShape.firstMaterial!.diffuse.contents = colour
        projectileShape.firstMaterial!.specular.contents = UIColor.white
        let node = SCNNode(geometry: projectileShape)
        node.position = origin
        super.init(parentNode, node, isMobile: true, mass: 1.0, isAffectedByGravity: false, isTemporary: true)
        self.minZDist = 0.0
        self.speed = 7.5
        self.target = target
    }

    public static let start: Float = 0.5
    public static let end: Float = 30.0
    
}
