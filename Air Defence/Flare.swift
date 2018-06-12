import SceneKit

class Flare : Entity {
    
    init(origin: SCNVector3, target: SCNVector3) {
        let geometry = SCNPyramid(width: 0.005, height: 0.01, length: 0.005)
        geometry.firstMaterial!.diffuse.contents = UIColor.yellow
        geometry.firstMaterial!.emission.contents = UIColor.yellow
        geometry.firstMaterial!.specular.contents = UIColor.yellow
        let node = SCNNode(geometry: geometry)
        node.position = origin
        let bitMask = Flare.bitMask
        super.init(node, isMobile: true, mass: 0.1, isAffectedByGravity: false, isTemporary: true, physicsBody: SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry, options: nil)), collisionBitMask: bitMask, contactBitMask: Missile.bitMask, rotationOffsets: SCNVector3(0.0, 0.0, 0.0), rotationallyFixed: true)
        super.minZDist = 0.0
        super.speed = 7.5
        super.target = target
        super.lookAtPoint = target
        super.startRotating()
    }
    
    // Bit Masks
    public static let bitMask = 4
    
    // Range
    public static let start: Float = 0.25
    public static let end: Float = 100.0
}
