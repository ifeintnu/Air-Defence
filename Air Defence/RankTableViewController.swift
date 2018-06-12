//
//  RankTableViewController.swift
//  
//
//  Created by user on 2018/6/12.
//

import UIKit
//import FirebaseDatabase




class RankTableViewController: UITableViewController {
//    var ref: DatabaseReference!
//    let companyName = ["Apple", "Google", "MS"]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
//        ref = Database.database().reference()
//        let scores = self.ref.child("scores")
//        scores.queryOrdered(byChild: "score").observe(.value, with: { (snapshot) in
//            //                                (scores).queryOrdered(byChild: "score")
//            //                            print(scoreQuery)
//            //                            scoreQuery.observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            //                                print(snapshot.value?)
////                                            let dic = snapshot.value as? NSDictionary
////                                            print(dic!)
////
////                                            for (key,value) in dic! {
////                                                print("\(key) : \(value)")
////                                                let childDic = value as? NSDictionary
//////                                                childDic["name"]!
//////                                                childDic!["name"]    = childDic!["name"] as! String
//////                                                print(name)
//////                                                childDic["score"] = childDic["score"] as Int
////                                                arr.append(childDic!)
////                                            }
//////                                            arr = arr.sort(by: {$0.score > $1.score})
////                                            print(arr)
////                                            print(type(of:arr[0]["name"]))
////                                            print(type(of:arr[0]["score"]))
////                                            NSArray * values = [dictionary value];
////                                            print(values)
//            //                                let username = value?["score"] as? Int ?? 0
//            //                                let user = User(username: username)
//            //                                print(username)
//            
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print(arr.count)
        return arr.count
//        return companyName.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

//        print(indexPath)
//         Configure the cell...
        
        let newScore = arr[indexPath.row]["highScore"] as! Int
        let scoreString = String(newScore)
        cell.textLabel?.text = scoreString
        let name = arr[indexPath.row]["name"] as! String
        cell.detailTextLabel?.text = "         " + name
//        "\(arr?.objectAtIndex(indexPath.row).name)"
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
