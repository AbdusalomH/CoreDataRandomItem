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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    var whatPresent: Bool? = nil
    

    @IBOutlet weak var tableview: UITableView!
    
    
    
    var usersName: [NSManagedObject] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequest()
        
        view.backgroundColor = .systemPink
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        button1.setTitle("Пур Тужур", for: .normal)
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
        
        let alert = UIAlertController(title: "Добавить", message: "Новый пользователь", preferredStyle: .alert)
        
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
        
        
        let randomWinner = Int.random(in: 0...winnerUsers.count - 1)
        
        if whatPresent == false {
        
            VC.winnerUser = winnerUsers[randomWinner]
            VC.winnerNumber = String(randomWinner + 1)
            VC.present = "Набор Пур Тужу"
            navigationController?.pushViewController(VC, animated: true)

        } else {
            VC.winnerUser = winnerUsers[randomWinner]
            VC.winnerNumber = String(randomWinner + 1)
            VC.present = "50 сомони"
            navigationController?.pushViewController(VC, animated: true)

        }
        
        
    }
    
    @IBOutlet weak var button1: UIButton!
    
    @IBAction func present1(_ sender: UIButton) {
        
        button1.setTitle("Выбран Пур Тужур", for: .normal)
        button2.setTitle("50 сомони", for: .normal)
        whatPresent = false

        
    }
    
    
    @IBOutlet weak var button2: UIButton!
    @IBAction func present2(_ sender: UIButton) {
        
        
        button1.setTitle("Пур Тужур", for: .normal)
        button2.setTitle("Выбран 50сом.", for: .normal)
        whatPresent = true
   
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
    
  
    func fetchRequest() {
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            
            let users = try context.fetch(fetchRequest)
            usersName = users
        } catch let err as NSError {
            print("error appears when fetch request \(err)")
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
   
        }
    }
}

