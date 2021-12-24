//
//  ViewController.swift
//  SportsAndPlayers
//
//  Created by admin on 24/12/2021.
//

import UIKit

class SportsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PlayersTableViewController
        destination.title = ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportCell", for: indexPath) as! SportsTableViewCell
        if let imgae = cell.sportImageView.image {
            cell.sportImageView.image = imgae
            cell.sportImageView.isHidden = false
            cell.addImageButton.isHidden = true
        }else {
            cell.sportImageView.isHidden = true
            cell.addImageButton.isHidden = false
        }
        return cell
    }
}

