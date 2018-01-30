//
//  ExchangeRateService.swift
//  CurrencyConverter
//
//  Created by Naga Mullapudi on 2018-01-21.
//

import Foundation

private let baseURLString = "https://api.fixer.io/latest?base="

enum ServiceError: Error {
    case missingBase
    case serviceFailure
    case malformedURL
    case parsingError
    case saveError
    case objectCreationError
    case errorWithCode(errorCode: Int)
}

class ExchangeRateService {
    class func fetchExchangeRate(with base: String?, completionBlock: @escaping ((Data?, Error?) -> Void)) {
        guard let base = base else {
            completionBlock(nil, ServiceError.missingBase)
            return
        }
        
        guard let url = URL(string: baseURLString + base) else {
            completionBlock(nil, ServiceError.malformedURL)
            return
        }
        
        let request = URLRequest(url: url)
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            defer { dataTask = nil }
            
            guard error == nil, 
                data != nil else {
                completionBlock(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionBlock(nil, ServiceError.serviceFailure)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completionBlock(nil, ServiceError.errorWithCode(errorCode: httpResponse.statusCode))
                return
            }
            
            completionBlock(data, nil)
            
        }
        dataTask?.resume()
    }
}

