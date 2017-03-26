//
//  SignIdViewController.swift
//  hackcity
//
//  Created by Remi Robert on 26/03/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import Alamofire

class SignIdViewController: UIViewController {

    @IBOutlet weak var inputIDField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func connect(_ sender: Any) {
        
        if inputIDField.text == "" {
            
            let alertController = UIAlertController(title: "Oops!!", message: "Must enter an ID to continue 🤓", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            //login
            let id = inputIDField.text
            let idDict = [
                "deviceId": id
            ]
            
            let post = Alamofire.request("http://172.16.0.49:4242/device", method: .post, parameters: idDict)
            post.validate().responseJSON(completionHandler: {response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)                        
                    }

                    
                case .failure(let error):
                    print(error)
                    
                    let alertController = UIAlertController(title: "Oops!!", message: "failure to load data", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            })
        }
    }
    
}









