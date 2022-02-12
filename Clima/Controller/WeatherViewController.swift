//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchTextField.delegate = self //textfield should report back to vc. notify vc on what happens. 
    }
    

    @IBAction func searchPressed(_ sender: UIButton) {
        buttonAction()
    }
    
    func buttonAction () {
        print(searchTextField.text!)
        searchTextField.endEditing(true)//dismisses keyboard
    }
    
    //triggered by textfield not us. could have multiple text fields and apply these methods to all of them.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textfield should process return key in keyboard?
        buttonAction()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //use the searchtexfield.tex to get weather for city
        
        searchTextField.text = "" //clears textfield
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //this method is useful for validation
        
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Please enter a city"
            return false
        }
        
    }
    
  
    
}

