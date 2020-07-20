//
//  ViewController.swift
//  projectCoreData
//
//  Created by Abdusalom Hojiev on 7/1/20.
//  Copyright © 2020 Abdusalom Hojiev. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    
    let present1 = "Фирменные очки"
    let present2 = "50 сомони"
    
    
    @IBAction func showAllWinners(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToWinners", sender: self)
    }
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    var whatPresent: Bool? = nil
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    var usersName: [NSManagedObject] = []
    
    var winnersName: [NSManagedObject] = []
    var winnersPresent: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequest()
        
        view.backgroundColor = .systemPink
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        button1.setTitle("Фирменные очки", for: .normal)
        button2.setTitle("50 сомони", for: .normal)
        
        button1.layer.cornerRadius = 12
        button2.layer.cornerRadius = 12
        
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addItem))
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    @objc func addItem() {
        
        let alert = UIAlertController(title: "Добавить", message: "Новый консультант", preferredStyle: .alert)
        
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Имя"
        }
        
        let action = UIAlertAction(title: "Ok", style: .default) { [unowned self] action in
            
            let newUser = alert.textFields![0]
            
            self.saveUser(newUser.text!)
            self.tableview.reloadData()
            let index = IndexPath(row: self.usersName.count - 1, section: 0)
            self.tableview.scrollToRow(at: index, at: .middle, animated: true)
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    
    
    
    
    @IBAction func winnerButton(_ sender: UIButton) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "winnerID") as! WinnerViewController
        
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        var winnerUsers: [String] = []
        
        do {
            let all = try context.fetch(fetch)
            
            for allusers in all {
                
                let users = allusers.value(forKey: "name") as! String
                winnerUsers.append(users)
            }
        } catch {
            print(error)
        }
        
        
        
        if whatPresent == false {
            
            
            let randomWinner = Int.random(in: 0...winnerUsers.count - 1)
            VC.winnerUser = winnerUsers[randomWinner]
            VC.winnerNumber = String(randomWinner + 1)
            VC.present = "Фирменные очки"
            saveMoneyWinner(winners: winnerUsers[randomWinner])
            navigationController?.pushViewController(VC, animated: true)
            
            
            
        } else if whatPresent == true {
            
            
            let randomWinner = Int.random(in: 0...winnerUsers.count - 1)
            VC.winnerUser = winnerUsers[randomWinner]
            VC.winnerNumber = String(randomWinner + 1)
            VC.present = "50 сомони"
            saveMoneyWinner(winners: winnerUsers[randomWinner])
            navigationController?.pushViewController(VC, animated: true)
            
        }
        
    }
    
    @IBOutlet weak var button1: UIButton!
    
    @IBAction func present1(_ sender: UIButton) {
        
        if usersName.count != 0  {
            
            button1.setTitle("Выбраны очки", for: .normal)
            button2.setTitle("50 сомони", for: .normal)
            whatPresent = false
            
        }
        
    }
    
    
    @IBOutlet weak var button2: UIButton!
    @IBAction func present2(_ sender: UIButton) {
        
        if usersName.count != 0 {
            button1.setTitle("Фирменные очки", for: .normal)
            button2.setTitle("Выбран 50сом.", for: .normal)
            whatPresent = true
        }
        
    }
    
    
    
    func saveUser(_ Item: String) {
        
        
        if let newItem = NSEntityDescription.entity(forEntityName: "User", in: context) {
            let newname = NSManagedObject(entity: newItem, insertInto: context)
            
            newname.setValue(Item, forKey: "name")
            
            usersName.append(newname)
            
            do {
                try context.save()
            } catch let err as NSError {
                print("Not able to save item \(err)")
            }
        }
    }
    
    func saveMoneyWinner(winners: String) {
        
        if let newItem = NSEntityDescription.entity(forEntityName: "MoneyWinners", in: context) {
            
            
            let newname = NSManagedObject(entity: newItem, insertInto: context)
            
            newname.setValue(winners, forKey: "winnersName")
            
            winnersName.append(newname)
            
            do {
                try context.save()
                print("Sucessfully saved")
            } catch let err as NSError {
                print("Not able to save item \(err)")
            }
        }
    }
    
    
//    func saveParfueWinner(winners: String) {
//
//        if let newItem = NSEntityDescription.entity(forEntityName: "ParfumeWinners", in: context) {
//
//
//            let newPresent = NSManagedObject(entity: newItem, insertInto: context)
//
//            newPresent.setValue(winners, forKey: "winnersName")
//
//            winnersPresent.append(newPresent)
//
//            do {
//                try context.save()
//                print("Sucessfully saved")
//            } catch let err as NSError {
//                print("Not able to save item \(err)")
//            }
//        }
//
//    }
    
    
    func fetchRequest() {
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            
            let users = try context.fetch(fetchRequest)
            usersName = users
        } catch let err as NSError {
            print("error appears when fetch request \(err)")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToWinners" {
            
            let dest = segue.destination as! WinnersViewController
            
            let fetchMoneyWinner = NSFetchRequest<NSManagedObject>(entityName: "MoneyWinners")
            
            
            do {
                
                let moneyWinners = try context.fetch(fetchMoneyWinner)
                dest.moneyWinners = moneyWinners
                
                
                do {
                    try context.save()
                } catch {
                    print(error)
                }
                
                
                if whatPresent == true {
                    dest.title = "Денежный приз"
                    
                } else if whatPresent == false {
                    dest.title = "Фирменные очки"
                }
                
                
            } catch {
                print(error)
            }
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return usersName.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let user = usersName[indexPath.row]
        
        cell.textLabel?.text = user.value(forKey: "name") as? String
        
        cell.detailTextLabel?.text = "Консультант №\(String(indexPath.row + 1))"
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(usersName[indexPath.row])
            usersName.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            print("Successfully deleted")
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

