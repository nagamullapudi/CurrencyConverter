//
//  ExchangeRateViewModel.swift
//  CurrencyConverter
//
//  Created by Naga Mullapudi on 2018-01-21.
//

import Foundation
import CoreData

class ExchangeRateViewModel {
    
    var container: ExchangeRateContainer
    
    init() {
        self.container = ExchangeRateContainer() 
    }
    
    init(with container: ExchangeRateContainer = ExchangeRateContainer()) {
        self.container = container
    }
    
    var networkFetch: Bool {
        return self.container.networkFetch
    }
    
    var activeCurrencyInfo: ExchangeRate? {
        return container.activeExchangeRate
    }
    
    var numberOfItems: Int {
        return container.exchangeRates.count
    }
    
    var baseStringForActiveInfo: [String] {
        guard let active = container.activeExchangeRate else {
            return []
        }
        return Array(active.rates.keys)
    }
    
    func currencyValue(countryCode: String, value: Double) -> Double {
        guard let active = container.activeExchangeRate else {
            return 0
        }
        guard let rate = active.rates[countryCode] else {
            return 0
        }
        return rate * value
    }

    //This shall be the datasource for the tableViewController popover
    var allbaseStrings: [String] {
        guard let active = container.activeExchangeRate else {
            return []
        }
        var baseKeys = Array(active.rates.keys)
        baseKeys.append(active.base)
        return baseKeys.sorted { $0 < $1 }
    }

    func loadExchangeRates(with base: String = "EUR", completionBlock: @escaping ((Error?) -> Void)) {
        container.loadExchangeRateFromDatabase(with: base, completionBlock: completionBlock)
    }
    
}
