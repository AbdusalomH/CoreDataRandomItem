//
//  WinnerViewController.swift
//  projectCoreData
//
//  Created by Abdusalom Hojiev on 7/3/20.
//  Copyright © 2020 Abdusalom Hojiev. All rights reserved.
//

import UIKit

class WinnerViewController: UIViewController {
    
    
    var winnerUser = ""
    
    var winnerNumber = ""
    
    var present = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        winnerN.text = "Консультант №\(winnerNumber)"
        winnerName.text = winnerUser
        presentName.text = present
        

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var winnerN: UILabel!
    @IBOutlet weak var winnerName: UILabel!
    @IBOutlet weak var presentName: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
