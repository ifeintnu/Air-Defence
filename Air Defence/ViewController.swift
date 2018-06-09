import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBAction func swipeUpGesture(_ sender: UISwipeGestureRecognizer) {
        let (direction, position) = getCameraVector()
        let start = Projectile.start
        let end = Projectile.end
        let origin = SCNVector3(position.x + direction.x * start, position.y + direction.y * start, position.z + direction.z * start)
        let target = SCNVector3(position.x + direction.x * end, position.y + direction.y * end, position.z + direction.z * end)
        entities.append(Projectile(parentNode: sceneView.scene.rootNode, origin: origin, target: target, colour: UIColor.red))
    }
    
    func getCameraVector() -> (SCNVector3, SCNVector3) {
        if let frame = self.sceneView.session.currentFrame {
            let transform = SCNMatrix4(frame.camera.transform)
            let direction = SCNVector3(-1 * transform.m31, -1 * transform.m32, -1 * transform.m33) // Orientation of camera in world space.
            let position = SCNVector3(transform.m41, transform.m42, transform.m43) // Location of camera in world space.
            return (direction, position)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        if worldIsSetUp {
            for (index, entity) in entities.enumerated() {
                if entity.dead() {
                    entities.remove(at: index)
                }
                else {
                    entity.update(sceneView)
                }
            }
        }
        else {
            setUpWorld()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Show origin of coordinate system
        //sceneView.debugOptions = ARSCNDebugOptions.showWorldOrigin
        
        // Create a new scene
        EnemyShip.scene = SCNScene(named: "art.scnassets/enemy_ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    private func setUpWorld() {
        if let currentFrame = sceneView.session.currentFrame {
            if EnemyShip.scene != nil {
                entities.append(EnemyShip(parentNode: sceneView.scene.rootNode, currentFrame))
                worldIsSetUp = true
            }
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    private var worldIsSetUp: Bool = false
    private var entities: [Entity] = []
    
}
