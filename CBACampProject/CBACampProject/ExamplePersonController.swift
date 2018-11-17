//
//  ExamplePersonController.swift
//  CBACampProject
//
//  Created by JUDY on 2018. 11. 18..
//  Copyright © 2018년 mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class ExamplePersonController: UIViewController {
    @IBAction func Logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch{
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
