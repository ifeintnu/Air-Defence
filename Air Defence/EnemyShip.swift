import ARKit
import SceneKit

class EnemyShip {
    
    init(parentNode: SCNNode, primaryNode: SCNNode, _ currentFrame: ARFrame) {
        node = primaryNode.childNode(withName: "Ship_Type_3_Sphere.005_sh3", recursively: true)!
        self.parentNode = parentNode
        parentNode.addChildNode(node)
        
        // When these three lines are called together, the node's position is distorted.
        node.pivot = SCNMatrix4MakeTranslation(-1.5, 0.0, 2.0) // This centres the ship with respect to its scene's root node.
        node.eulerAngles = SCNVector3Make(0, yRotationOffset, 0) // This rotates the ship to face forwards.
        node.position = SCNVector3(0.0, 0.0, -15.0)

        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.mass = 1.0
        node.physicsBody?.isAffectedByGravity = false
    }
    
    // TODO: This function updates the node's position in addition to its y-rotation.
    // Ideally, it would only update its orientation.
    // Furthermore, instead of mimicking the camera's orientation, facing the camera's (x, y, z) location would be much, much better.
    public func mimicCameraOrientation(_ currentFrame: ARFrame) {
        let rotate = simd_float4x4(SCNMatrix4MakeRotation(currentFrame.camera.eulerAngles.y + yRotationOffset, 0, 1, 0))
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
        
        if engineIsRunning {
            //mimicCameraOrientation(currentFrame)
            let camCol = view.pointOfView!.position
            let nodeCol = node.presentation.position
            let distRaw = SCNVector3(camCol.x - nodeCol.x, camCol.y - nodeCol.y, camCol.z - nodeCol.z - minZDist)
            let dist = (distRaw.x * distRaw.x + distRaw.y * distRaw.y + distRaw.z * distRaw.z).squareRoot()
            let factor = (abs(dist) < distBuffer ? 0.0 : 5.0 / dist)
            node.physicsBody?.velocity = SCNVector3(distRaw.x * factor, distRaw.y * factor, distRaw.z * factor)
        }
    }

    // Time counter
    private var counter: UInt64 = 0
    
    // Engine
    private var engineIsRunning: Bool = true
    private var minZDist: Float = 2.0
    private let distBuffer: Float = 0.5
    
    // Rotation
    private var isRotating: Bool = false
    private let yRotationOffset = 0.5 * Float.pi // Offset to make the ship face forwards rather than sideways.
    
    // SCNNode
    private var node: SCNNode // Remember to change back to private.
    private var parentNode: SCNNode

}
