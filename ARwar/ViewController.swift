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

class ViewController: UIViewController {

    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Debug) {
            self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        }
        self.sceneView.session.run(configuration)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

