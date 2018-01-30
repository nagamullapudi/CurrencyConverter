//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by Naga Mullapudi on 2018-01-21.
//

import Foundation

class ExchangeRate: NSObject, NSCoding {
    
    let base: String
    let date: String
    let rates: [String: Double]
    let timestamp: Date?
    
    private let refreshInterval: TimeInterval = 60 * 30 // half an hour
    
    var staleData: Bool {
        guard let timestamp = timestamp else {
            return true
        }
        let timeSinceLastDownload = Date().timeIntervalSince(timestamp)
        if timeSinceLastDownload >= refreshInterval { return true }
        return false
    } 
    
    init?(base: String, date: String, rates: [String: Double], timestamp: Date?) {
        guard !base.isEmpty else { return nil }
        guard !date.isEmpty else { return nil }
        guard !rates.isEmpty else { return nil }
        
        self.base = base
        self.date = date
        self.rates = rates
        self.timestamp = timestamp
    }
    
    struct PropertyKey {
        static let base = "base"
        static let date = "date"
        static let rates = "exchangeRates"
        static let timestamp = "timestamp"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(base, forKey: PropertyKey.base)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(rates, forKey: PropertyKey.rates)
        aCoder.encode(timestamp, forKey: PropertyKey.timestamp)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let base = aDecoder.decodeObject(forKey: PropertyKey.base) as? String else {
            return nil
        }
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String else {
            return nil
        }
        guard let rates = aDecoder.decodeObject(forKey: PropertyKey.rates) as? [String: Double] else {
            return nil
        } 
        
        let timestamp = aDecoder.decodeObject(forKey: PropertyKey.timestamp) as? Date
        
        // Must call designated initializer.
        self.init(base: base, date: date, rates: rates, timestamp: timestamp)
        
    }
}
