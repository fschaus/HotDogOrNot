//
//  PopUpViewController.swift
//  Seefood
//
//  Created by Francois Schaus on 10/16/17.
//  Copyright © 2017 Francois Schaus. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    var answerPassedOver : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
guessedObject.text = "Not hotdog! It's a \(answerPassedOver!)"
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var guessedObject: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
