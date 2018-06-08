//
//  ViewController.swift
//  ARwar
//
//  Created by 何驊益 on 2018/6/3.
//  Copyright © 2018年 jacky. All rights reserved.
//

import UIKit
import ARKit

let Debug = true

class ViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var button: UIButton!

    @IBAction func btnClick(_ sender: Any) {
        print(getComeraPosition()?.x, getComeraPosition()?.y, getComeraPosition()?.z)
    }
    
    func getComeraPosition()->SCNVector3? {
        let currentTransform = self.sceneView.session.currentFrame?.camera.transform
        guard let columns = currentTransform?.columns else {
            return nil
        }
        return SCNVector3((columns.3.x), (columns.3.y), (columns.3.z))
    }
    
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Debug) {
            self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        }
        self.sceneView.delegate = self
        self.sceneView.session.run(configuration)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

