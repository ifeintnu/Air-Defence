import ARKit
import SceneKit

class Entity {
    
    init(_ parentNode: SCNNode, _ node: SCNNode, isMobile: Bool, mass: CGFloat, isAffectedByGravity: Bool) {
        self.node = node
        self.parentNode = parentNode
        self.isMobile = isMobile
        parentNode.addChildNode(node)
        
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.mass = mass
        node.physicsBody?.isAffectedByGravity = isAffectedByGravity
    }
    
    // TODO: This function updates the node's position in addition to its y-rotation.
    // Ideally, it would only update its orientation.
    // Furthermore, instead of mimicking the camera's orientation, facing the camera's (x, y, z) location would be much, much better.
    public func mimicCameraOrientation(_ currentFrame: ARFrame, _ yRotationOffset: Float) {
        let rotate = simd_float4x4(SCNMatrix4MakeRotation(currentFrame.camera.eulerAngles.y + yRotationOffset, 0.0, 1.0, 0.0))
        let rotateTransform = simd_mul(simd_float4x4(parentNode.worldTransform), rotate)
        node.transform = SCNMatrix4(rotateTransform)
    }
    
    // The rotating feature is for showcasing the ship, not for gameplay.
    public func startRotating() {
        isRotating = true
    }
    
    public func stopRotating() {
        isRotating = false
    }

    public func update(_ view: SCNView) {
        // Using a time counter should be okay because the frame rate seems to be capped at sixty FPS.
        // I would prefer to use a timer, but I found Swift's various timer functions to be too inaccurate, perhaps due to user error.
        counter = counter &+ 1
        
        if isRotating {
            node.eulerAngles = SCNVector3Make(0, Float(counter % 360) / 180.0 * Float.pi, 0)
        }
        
        if isMobile, let target = target {
            let nodeCol = node.presentation.position
            let distRaw = SCNVector3(target.x - nodeCol.x, target.y - nodeCol.y, target.z - nodeCol.z - minZDist)
            let dist = (distRaw.x * distRaw.x + distRaw.y * distRaw.y + distRaw.z * distRaw.z).squareRoot()
            let speedFactor = (abs(dist) < distBuffer ? 0.0 : speed / dist)
            node.physicsBody?.velocity = SCNVector3(distRaw.x * speedFactor, distRaw.y * speedFactor, distRaw.z * speedFactor)
        }
        
    }

    // Movement
    private let distBuffer: Float = 0.5
    private var isMobile: Bool = false
    public var minZDist: Float = 2.0
    public var speed: Float = 5.0
    public var target: SCNVector3?

    // Rotation
    private var isRotating: Bool = false

    // SCNNode
    private var node: SCNNode
    private var parentNode: SCNNode

    // Time counter
    private var counter: UInt64 = 0

}
