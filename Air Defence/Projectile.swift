import SceneKit

class Projectile : Entity {
    
    init(parentNode: SCNNode, origin: SCNVector3, target: SCNVector3, colour: UIColor) {
        let projectileShape = SCNSphere(radius: 0.3)
        projectileShape.firstMaterial!.diffuse.contents = colour
        projectileShape.firstMaterial!.specular.contents = UIColor.white
        let node = SCNNode(geometry: projectileShape)
        node.position = origin
        super.init(parentNode, node, isMobile: true, mass: 1.0, isAffectedByGravity: false)
        self.minZDist = 0.0
        self.speed = 5.0
        self.target = target
    }
    
}
