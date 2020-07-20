//
//  WinnersViewController.swift
//  projectCoreData
//
//  Created by Abdusalom Hojiev on 7/20/20.
//  Copyright © 2020 Abdusalom Hojiev. All rights reserved.
//

import UIKit
import CoreData

class WinnersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
     

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var winnersTable: UITableView!
    
    var moneyWinners: [NSManagedObject] = []

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
   
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        winnersTable.delegate = self
        winnersTable.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneyWinners.count
    }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "winnersCell", for: indexPath)
        
        let money = moneyWinners[indexPath.row]
                
        cell.textLabel?.text = (money.value(forKey: "winnersName") as? String)
        
        cell.detailTextLabel?.text = "Консультант №\(indexPath.row + 1)"
        return cell
     }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(moneyWinners[indexPath.row])
            moneyWinners.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
 
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    


}
