import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    func getComeraPosition()->SCNVector3? {
        let currentTransform = self.sceneView.session.currentFrame?.camera.transform
        guard let columns = currentTransform?.columns else {
            return nil
        }
        return SCNVector3((columns.3.x), (columns.3.y), (columns.3.z))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        if worldIsSetUp {
            for enemyShip in enemyShipNodes {
                enemyShip.update(sceneView)
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
        scene = SCNScene(named: "art.scnassets/enemy_ship.scn")!
        //enemyShipNode2 = enemyShipNode1.clone() as SCNNode
        //enemyShipNode2.position = SCNVector3(x: 0.00, y: 0.75, z: 0.00)
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
        let hydrogenAtom = SCNSphere(radius: 1.20)
        hydrogenAtom.firstMaterial!.diffuse.contents = UIColor.red
        hydrogenAtom.firstMaterial!.specular.contents = UIColor.white
        let hydrogenNode = SCNNode(geometry: hydrogenAtom)
        hydrogenNode.position = SCNVector3Make(-6, 0, 0)
        sceneView.scene.rootNode.addChildNode(hydrogenNode)
        //sceneView.scene.rootNode.addChildNode(enemyShipNode2)
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
            if let scene = scene {
                enemyShipNodes.append(EnemyShip(parentNode: sceneView.scene.rootNode, primaryNode: scene.rootNode, currentFrame))
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
    private var enemyShipNodes: [EnemyShip] = []
    private var scene: SCNScene?
    
}
