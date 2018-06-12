import UIKit
import SceneKit
import SpriteKit
import ARKit
import AVFoundation
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit

var score = 100
var userID = ""
var userName = ""
var userHighScore = 100
var arr = [NSDictionary]()

class ViewController: UIViewController, SCNPhysicsContactDelegate, ARSCNViewDelegate {
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func ClickLogout(_ sender: Any) {
        userID = ""
        userName = ""
        score = 100
        userHighScore = 100
        
        UserDefaults.standard.set("", forKey: "userID")
        
        UserDefaults.standard.set("", forKey: "userName")
        AlertLoginBtn.isHidden  = false
        LabelName.text          = ""
        loginBtn.isHidden       = false
        logoutBtn.isHidden      = true
    }
    @IBOutlet weak var AlertLoginBtn: UIButton!
    @IBOutlet weak var LabelName: UILabel!
    var ref: DatabaseReference!
    var spriteScene: OverlayScene!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    private var fireCounter: UInt64 = 0
    @IBAction func Rotation(_ sender: Any) {
        fireCounter = fireCounter &+ 1
        if fireCounter % 5 == 0 {
            fireFlare()
        }
    }
    
    @IBAction func SwipeRight(_ sender: Any) {
        fireMissile()
    }
    
    @IBAction func SwipeLeft(_ sender: Any) {
        fireMissile()
    }
    
    @IBAction func touchSight(_ sender: Any) {
        fireMissile()
    }
    
    @IBAction func SwipeDown(_ sender: Any) {
        fireMissile()
    }
    
    @IBAction func SwipeUp(_ sender: Any) {
        fireFlare()
    }
    
    public func addEntity(_ entity: Entity) {
        entity.setID(entityCounter)
        pendingEntities.append(entity)
        entityCounter = entityCounter &+ 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func fireFlare(){
        let (direction, position) = getCameraVector()
        let start = Flare.start
        let end = Flare.end
        let origin = SCNVector3(position.x + direction.x * start, position.y + direction.y * start, position.z + direction.z * start)
        let target = SCNVector3(position.x + direction.x * end, position.y + direction.y * end, position.z + direction.z * end)
        addEntity(Flare(origin: origin, target: target))
    }
    
    func fireMissile(){
        let (direction, position) = getCameraVector()
        let start = Missile.start
        let end = Missile.end
        let origin = SCNVector3(position.x + direction.x * start, position.y + direction.y * start, position.z + direction.z * start)
        let target = SCNVector3(position.x + direction.x * end, position.y + direction.y * end, position.z + direction.z * end)
        addEntity(Missile(origin: origin, target: target, reversed: true))
        score=score - 1
        self.ref.child("history").setValue(["score": score])
        self.spriteScene.score = self.spriteScene.score - 1
    }
    
    public func getCameraVector() -> (SCNVector3, SCNVector3) {
        if let frame = sceneView.session.currentFrame {
            let transform = SCNMatrix4(frame.camera.transform)
            let direction = SCNVector3(-1 * transform.m31, -1 * transform.m32, -1 * transform.m33) // Orientation of camera in world space.
            let position = SCNVector3(transform.m41, transform.m42, transform.m43) // Location of camera in world space.
            return (direction, position)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var nodeA, nodeB: SCNNode?
        if contact.nodeA.physicsBody?.categoryBitMask == Missile.bitMask {
            nodeA = contact.nodeA
            nodeB = contact.nodeB
        }
        else {
            nodeA = contact.nodeB
            nodeB = contact.nodeA
        }
        if let nodeA = nodeA, let nodeB = nodeB {
            if nodeA.physicsBody?.categoryBitMask == Missile.bitMask && nodeB.physicsBody?.categoryBitMask == EnemyShip.bitMask {
                if let particleSystem = SCNParticleSystem(named: "explosion", inDirectory: "art.scnassets") {
                    playSound(sound: .explosion)
                    let explosionNode = SCNNode()
                    explosionNode.addParticleSystem(particleSystem)
                    explosionNode.position = nodeA.position
                    sceneView.scene.rootNode.addChildNode(explosionNode)
                }
                if let nameA = nodeA.name, let nameB = nodeB.name {
                    var newEntities: [Entity] = []
                    for entity in entities {
                        if entity.getID() == nameA || entity.getID() == nameB {
                            entity.die()
                            score=score + 5
                        if(score>userHighScore){
                                userHighScore = score
                            }
                            let scores = self.ref.child("scores");
                            scores.child(userID).setValue([
                                "name"      : userName  ,
                                "score"     : score     ,
                                "highScore" : userHighScore
                                ])
                            self.spriteScene.score = score
                            deadEntities.append(entity)
                        }
                        else {
                            newEntities.append(entity)
                        }
                    }
                    entities = newEntities
                }
            }
            else if nodeA.physicsBody?.categoryBitMask == Missile.bitMask && nodeB.physicsBody?.categoryBitMask == Flare.bitMask {
                print("Flare collision.")
                if let particleSystem = SCNParticleSystem(named: "explosion", inDirectory: "art.scnassets") {
                    playSound(sound: .explosion)
                    let explosionNode = SCNNode()
                    explosionNode.addParticleSystem(particleSystem)
                    explosionNode.position = nodeA.position
                    sceneView.scene.rootNode.addChildNode(explosionNode)
                }
                if let nameA = nodeA.name, let nameB = nodeB.name {
                    var newEntities: [Entity] = []
                    for entity in entities {
                        if entity.getID() == nameA || entity.getID() == nameB {
                            entity.die()
                            deadEntities.append(entity)
                        }
                        else {
                            newEntities.append(entity)
                        }
                    }
                    entities = newEntities
                }
            }
        }
    }
    
    private func playSound(sound: Sound) {
        DispatchQueue.main.async {
            do
            {
                if let soundPath = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3", subdirectory: "Sounds") {
                    self.soundPlayer = try AVAudioPlayer(contentsOf: soundPath)
                    self.soundPlayer?.play()
                }
            }
            catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if worldIsSetUp {
            var numEnemyShips: Int = 0
            for entity in pendingEntities {
                sceneView.scene.rootNode.addChildNode(entity.getNode())
                if entity.isEnemy {
                    numEnemyShips += 1
                }
            }
            var newEntities: [Entity] = pendingEntities
            pendingEntities = []
            for entity in entities {
                if entity.dead() {
                    deadEntities.append(entity)
                }
                else {
                    entity.update(self)
                    newEntities.append(entity)
                    if entity.isEnemy {
                        numEnemyShips += 1
                    }
                }
            }
            entities = newEntities
            newEntities = []
            for entity in deadEntities {
                entity.remove()
            }
            if numEnemyShips == 0, let currentFrame = sceneView.session.currentFrame {
                level += 5
                for _ in 0..<level {
                    addEntity(EnemyShip(currentFrame))
                }
            }
        }
        else {
            setUpWorld()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    private func setUpWorld() {
        if EnemyShip.scene != nil && Missile.scene != nil {
            let geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
            let node = SCNNode(geometry: geometry)
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry, options: nil))
            node.position = SCNVector3(0.0, 0.0, 1.0)
            worldIsSetUp = true
        }
    }

    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        let UDUserID = UserDefaults.standard.string(forKey: "userID") ?? ""
        let UDUserName = UserDefaults.standard.string(forKey: "userName") ?? ""
        userID = UDUserID
        userName = UDUserName
        
        if(userID != ""){
            AlertLoginBtn.isHidden  = true
            LabelName.text          = userName
            loginBtn.isHidden       = true
            logoutBtn.isHidden      = false
        }else{
            LabelName.isHidden  = true
            loginBtn.isHidden   = false
            logoutBtn.isHidden  = true
        }
        
        
        
        ref = Database.database().reference()
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
        if(userID == ""){
            
            
            if (FBSDKAccessToken.current() != nil)
            {
                // User is already logged in, do work such as go to next view controller.
                
                let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large)"])
                
                graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                    
                    if ((error) != nil)
                    {
                        // Process error
                        if let error = error {
                            print("Error: \(error)")
                        }
                    }
                    else
                    {
                        let tmp = result as! [String: AnyObject]
                        userName    = tmp["first_name"] as! String
                        userID      = tmp["id"]         as! String
                        print(userID)
                        let scores = self.ref.child("scores");
                        scores.child(userID).updateChildValues([
                            "score"     : 100
                        ])
                    }
                })
            }
            else //not using facebook login
            {
            }

                let loginView : FBSDKLoginButton = FBSDKLoginButton()
                self.view.addSubview(loginView)
                loginView.frame.origin.y = self.view.frame.height - loginView.frame.height - 70
                loginView.frame.origin.x = 10
                loginView.readPermissions = ["public_profile", "email", "user_friends"]
        }
        
        
        //Firebase  get data
        ref.child("scores").queryOrdered(byChild: "score").observe(.value, with: { (snapshot) in
            arr = [NSDictionary]()
            let dic = snapshot.value as? NSDictionary
            for (key,value) in dic! {
                
                let childDic = value as? NSDictionary
                let keyString = key as! String
                
                if (keyString == userID) {
                    userHighScore = childDic!["highScore"]  as! Int
                    score         = childDic!["score"]      as! Int
                }
                arr.append(childDic!)
            }
            for _ in 0..<arr.count{
                for j in 0..<arr.count - 1{
                    if let left = arr[j]["highScore"] as! Int?, let right = arr[j+1]["highScore"] as! Int? {
                        if left < right {
                            let temp = arr[j]
                            arr[j] = arr[j+1]
                            arr[j+1] = temp
                        }
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }

        // Set the view's delegates
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        
        // Don't show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Use default lighting.
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        
        
        //scoreBoard
        self.spriteScene = OverlayScene(size: sceneView.bounds.size)
        sceneView.overlaySKScene = self.spriteScene
        
        
        // Toggle debugging options
        //sceneView.debugOptions = //.showPhysicsShapes // ARSCNDebugOptions.showWorldOrigin
        
        // Set EnemyShip and Projectile scenes
        EnemyShip.scene = SCNScene(named: "art.scnassets/enemy_ship.scn")!
        Missile.scene = SCNScene(named: "art.scnassets/missile.scn")!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        let UDUserID = UserDefaults.standard.string(forKey: "userID") ?? ""
        let UDUserName = UserDefaults.standard.string(forKey: "userName") ?? ""
        userID = UDUserID
        userName = UDUserName
        
        if(userID != ""){
            AlertLoginBtn.isHidden  = true
            LabelName.text          = userName
            loginBtn.isHidden       = true
            logoutBtn.isHidden      = false
        }else{
            LabelName.isHidden  = true
            loginBtn.isHidden   = false
            logoutBtn.isHidden  = true
        
            if (FBSDKAccessToken.current() != nil){
                AlertLoginBtn.isHidden = true
            }else{
                AlertLoginBtn.isHidden = false
            }
        }
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

    public static let FPS: Float = 60.0

    
    private var entities: [Entity] = []
    private var entityCounter: Int = 0
    private var level: Int = 0
    private var pendingEntities: [Entity] = []
    private var deadEntities: [Entity] = []
    private var soundPlayer: AVAudioPlayer?
    private var worldIsSetUp: Bool = false
    
    private enum Sound: String {
        case explosion = "explosion"
    }
    
}
