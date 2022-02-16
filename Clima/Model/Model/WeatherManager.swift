//
//  WeatherManager.swift
//  Clima
//
//  Created by Alicia Windsor on 12/02/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didWeatherUpdate(_ weatherManager : WeatherManager, weather : WeatherModel)
    func didFailWithError(_ error: Error)
}

extension WeatherManager {
    
    //let latLongURL =
    
    func fetchWeather (latitude : Double, longitude : Double){
       // print(cityName)
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        //let turlString = urlString.trimmingCharacters(in: .whitespaces)
        
       // print (urlString)
        performRequest(with: urlString)

    }
}

struct WeatherManager {
    let apiKey = "YOUR_API_KEY"
    
    var weatherURL : String {
        
        return "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    }
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather (cityName : String){
       // print(cityName)
        let urlString = "\(weatherURL)&q=\(cityName)"
        //let turlString = urlString.trimmingCharacters(in: .whitespaces)
        
       // print (urlString)
        performRequest(with: urlString)

    }
    
    
    func performRequest(with urlString : String) {
       
        //1. Create URL
     
        if let url = URL(string: urlString) {//DOUBLE CHECK YOUR URL IF THIS ISNT WORKING CHECK THE HTTPS:// AND NOT \\
            //print("ex")
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "ACCEPT")
        
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return //exit func and dont continue
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData) { //calling methods in closures requires self to show who owns the method (current class).
                        self.delegate?.didWeatherUpdate(self, weather: weather)
                        
                    }
                }
            }
            
            //completionHandler takes function that conforms to these inputs. can be refactored to a closure.
            
            //passing in call to method handle, for each input no values are being passed in. completion handler is triggered by task ie when session completes networking.
            
            //4. Execute task
 
            task.resume()
            
        }else{
            print("Url not building")
        }
    }

    func parseJSON (weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        //use do, try, catch for decoder incase anything goes wrong.
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) // data decoded as type WeatherData
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(weatherId: id, cityName: name, temperature: temp)
            
            //print(weather.tempString)
            return(weather)
            
        } catch{
            delegate?.didFailWithError(error)
            return nil
        }
        
    }
    
    

}
