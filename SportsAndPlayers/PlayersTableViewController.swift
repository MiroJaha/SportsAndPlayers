//
//  PlayersTableViewController.swift
//  SportsAndPlayers
//
//  Created by admin on 24/12/2021.
//

import UIKit
import CoreData

class PlayersTableViewController: UITableViewController {
    
    var sport: Sports!
    var playersList = [Players]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let save = (UIApplication.shared.delegate as! AppDelegate).saveContext

    override func viewDidLoad() {
        super.viewDidLoad()
        title = sport.name
        fetchingPlayersData()
    }

    func fetchingPlayersData() {
        let result: NSFetchRequest<Players> = Players.fetchRequest()
        let requestPredicate = NSPredicate(format: "sports == %@", sport)
        result.predicate = requestPredicate
        do {
            playersList = try context.fetch(result)
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    @IBAction func addNewPlayer(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Player", message: "Please Enter Player Details Below", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Player Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Player Age"
        }
        alert.addTextField { textField in
            textField.placeholder = "Player Height"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            let name = alert.textFields![0].text!
            let height = alert.textFields![2].text!
            if name.isEmpty || height.isEmpty {
                return
            }
            if let age = Int32(alert.textFields![1].text!) {
                let newPlayer = Players(context: self.context)
                newPlayer.name = name
                newPlayer.age = age
                newPlayer.height = height
                self.sport.addToPlayers(newPlayer)
                self.save()
                self.fetchingPlayersData()
            }else {
                return
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        guard let name = playersList[indexPath.row].name else { return cell }
        let age = playersList[indexPath.row].age
        guard let height = playersList[indexPath.row].height else { return cell }
        cell.textLabel?.text = "\(name) - Age: \(age), Height: \(height)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Player", message: "Please Edit Player Details Below", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.playersList[indexPath.row].name
        }
        alert.addTextField { textField in
            textField.text = String(self.playersList[indexPath.row].age)
        }
        alert.addTextField { textField in
            textField.text = self.playersList[indexPath.row].height
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            let name = alert.textFields![0].text!
            let height = alert.textFields![2].text!
            if name.isEmpty || height.isEmpty {
                return
            }
            if let age = Int32(alert.textFields![1].text!) {
                self.playersList[indexPath.row].name = name
                self.playersList[indexPath.row].age = age
                self.playersList[indexPath.row].height = height
                self.save()
                self.fetchingPlayersData()
            }else {
                return
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(playersList[indexPath.row])
        save()
        fetchingPlayersData()
    }
}
