//
//  FirstScreen.swift
//  PedalNature
//
//  Created by Volkan Sahin on 10.03.2020.
//  Copyright © 2020 Volkan Sahin. All rights reserved.
//

import UIKit

class FirstScreen: UIViewController {

    @IBOutlet weak var discoverButton: UIButton!
    @IBOutlet weak var challengesButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let insetValue = CGFloat(15)
        discoverButton.imageEdgeInsets = UIEdgeInsets(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue)
        challengesButton.imageEdgeInsets = UIEdgeInsets(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue)
        notificationButton.imageEdgeInsets = UIEdgeInsets(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue)
        accountButton.imageEdgeInsets = UIEdgeInsets(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue)
    }
    
    @IBAction func startLocation(_ sender: UIButton) {
        performSegue(withIdentifier: "startLocation", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startLocation" {
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.startLocationFlag = 1
            }
        }
    }
    

}
