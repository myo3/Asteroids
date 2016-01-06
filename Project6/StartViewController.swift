//
//  StartViewController.swift
//  Project6
//
//  Created by Monica Ong on 11/9/15.
//  Copyright © 2015 Monica Ong. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var levelController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Cloud Background.png")!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "beginGame"{
            let destinationVC = segue.destinationViewController as! ViewController
            destinationVC.level = levelController.selectedSegmentIndex ?? 0
        }
    }
    
    @IBAction func playAgain(segue: UIStoryboardSegue){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
