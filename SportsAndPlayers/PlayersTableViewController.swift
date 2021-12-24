//
//  PlayersTableViewController.swift
//  SportsAndPlayers
//
//  Created by admin on 24/12/2021.
//

import UIKit

class PlayersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        
        return cell
    }

}
