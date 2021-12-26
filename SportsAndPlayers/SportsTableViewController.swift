//
//  ViewController.swift
//  SportsAndPlayers
//
//  Created by admin on 24/12/2021.
//

import UIKit
import CoreData

class SportsTableViewController: UITableViewController {
    
    var sportsList = [Sports]()
    var selectedIndexPath: NSIndexPath?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let save = (UIApplication.shared.delegate as! AppDelegate).saveContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingSportsData()
    }
    
    func fetchingSportsData() {
        let result: NSFetchRequest<Sports> = Sports.fetchRequest()
        do {
            sportsList = try context.fetch(result)
        }catch {
            print(error)
        }
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PlayersTableViewController
        if let sport = sender as? Sports {
            destination.sport = sport
        }
    }
    
    @IBAction func addNewSport(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Sport", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter Sport Name"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            let name = alert.textFields![0].text!
            if name.isEmpty {
                return
            }
            let newSport = Sports(context: self.context)
            newSport.name = name
            self.save()
            self.fetchingSportsData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportCell", for: indexPath) as! SportsTableViewCell
        cell.sportsAndPlayersDelegate = self
        cell.indexPath = indexPath as NSIndexPath
        cell.sportNameLabel.text = sportsList[indexPath.row].name
        if let imgae = sportsList[indexPath.row].image {
            let selectedImage = UIImage(data: imgae)
            cell.sportImageView.image = selectedImage
            cell.sportImageView.isHidden = false
            cell.addImageButton.isHidden = true
        }else {
            cell.sportImageView.isHidden = true
            cell.addImageButton.isHidden = false
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sport = sportsList[indexPath.row]
        performSegue(withIdentifier: "PlayersSegue", sender: sport)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Sport", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = self.sportsList[indexPath.row].name
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            let newName = alert.textFields![0].text!
            if newName.isEmpty {
                return
            }
            self.sportsList[indexPath.row].name = newName
            self.save()
            self.fetchingSportsData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(sportsList[indexPath.row])
        save()
        fetchingSportsData()
    }
}

extension SportsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.originalImage] as? UIImage else { return }
        if let ip = selectedIndexPath?.row {
            sportsList[ip].image = userPickedImage.pngData()
            save()
            fetchingSportsData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SportsTableViewController: SportsAndPlayersDelegate {
    func saveImage(indexPath: NSIndexPath?) {
        selectedIndexPath = indexPath
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
}
