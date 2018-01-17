//
//  Container.swift
//  CurrencyConversion
//
//  Created by Naga Sai Jyothi  on 2017-12-16.
//  Copyright © 2017 Naga Sai Jyothi . All rights reserved.
//

import UIKit

class Container: NSObject {
    var keys: [String] = []

    func convert(convertFromCurrencyType: String,convertToCurrencyType: String, conversionNumber:Float,completion: @escaping (String?, Error?) -> ()) {
        let convertFromCurrencyType = convertFromCurrencyType
        let urlWithBaseCurrencyType = "https://api.fixer.io/latest?base=" + convertFromCurrencyType
        
        let url = URL(string: urlWithBaseCurrencyType)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let content = data else {
                print("Content not found")
                return}
            do{
                let currencyRates = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! [String:Any]
                
                print(currencyRates["rates"]!)
                let rates:[String:Float] = currencyRates["rates"] as! Dictionary
                print(rates[convertToCurrencyType]!)
                let currencyRate = rates[convertToCurrencyType]!
                let convertedRate:Float = conversionNumber * currencyRate as Float
                let displayConvertedRate = "\(conversionNumber) \(convertFromCurrencyType) = \(convertedRate) \(convertToCurrencyType)"
                print(displayConvertedRate)
                completion(displayConvertedRate, nil)

            }
            catch{
                print("Json Error")
            }
            }
        task.resume()
    }
    
    func currencyList(complition: @escaping (Error?) -> ()){
        let urlWithBaseCurrencyType = "https://api.fixer.io/latest?base=CAD"
        let url = URL(string: urlWithBaseCurrencyType)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let content = data else {
                print("Content not found")
                return}
            do{
                let currencyRates = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! [String:Any]
                
                print(currencyRates["rates"]!)
               // let rates:[String:Float] = currencyRates["rates"] as! Dictionary
                let rates:[String:Float] = currencyRates["rates"] as! Dictionary
                for key in rates.keys {
                self.keys.append(key)
                }
                print("currency Rates List:\n\(self.keys)")
                complition(nil)
            }
            catch{
                print("Catched Error")
            }
        }
        task.resume()
        }
}
