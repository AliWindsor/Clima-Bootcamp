//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self //needs to be defined first!!
        locationManager.requestWhenInUseAuthorization()//permission request
        locationManager.requestLocation() //one time location data.
        
        weatherManager.delegate = self //IMPORTANT FOR DELEGATE TO WORK!!!
        searchTextField.delegate = self //textfield should report back to vc. notify vc on what happens.
        
    }
    
    @IBAction func updateLocationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        buttonAction()
    }
    
    func buttonAction () {
        //print(searchTextField.text!)
        searchTextField.endEditing(true)//dismisses keyboard
    
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
  
}
//MARK: - Location

extension WeatherViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got it")
        if let location = locations.last { //gets most recent location
            locationManager.stopUpdatingLocation() //triggers request location multiple times
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - Delegate
extension WeatherViewController : WeatherManagerDelegate {
    func didWeatherUpdate (_ weatherManager : WeatherManager, weather : WeatherModel) {
        //need to change thread in order to update UI
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
       
    }
}

//MARK: - Textfield delegate

extension WeatherViewController : UITextFieldDelegate {
    //triggered by textfield not us. could have multiple text fields and apply these methods to all of them.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textfield should process return key in keyboard?
        buttonAction()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //use the searchtexfield.text to get weather for city
        //print(searchTextField.text)
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
              
        }
       
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
        
    }}

