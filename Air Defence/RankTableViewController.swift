//
//  RankTableViewController.swift
//  
//
//  Created by user on 2018/6/12.
//

import UIKit

class RankTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        
        let newScore = arr[indexPath.row]["highScore"] as! Int
        let scoreString = String(newScore)
        cell.textLabel?.text = scoreString
        let name = arr[indexPath.row]["name"] as! String
        cell.detailTextLabel?.text = "         " + name
        return cell
    }

}
