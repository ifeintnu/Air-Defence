//
//  UserViewController.swift
//  Air Defence
//
//  Created by user on 2018/6/13.
//  Copyright © 2018年 NTU. All rights reserved.
//

//struct defaultsKeys {
//    static let userID = ""
//    static let userName = ""
//}

import UIKit

class UserViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBAction func ClickAction(_ sender: Any) {
//        guard let text = usernameField?.text as? String else {
//            print("Fuck!!!!!")
//            return
//        }
        let name = usernameField.text!
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        var timeStamp = Int(timeInterval)
        timeStamp = timeStamp * -1
        userID = String(timeStamp)
        userName = name
        UserDefaults.standard.set(userID, forKey: "userID")
        
        UserDefaults.standard.set(userName, forKey: "userName")
//        let defaults = UserDefaults.standard
//        defaults.set(timeStamp, forKey: defaultsKeys.userID)
//        defaults.synchronize()
//        defaults.set(userName, forKey: defaultsKeys.userName)
//        defaults.synchronize()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
