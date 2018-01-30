//
//  ExchangeRateContainer.swift
//  CurrencyConverter
//
//  Created by Naga Mullapudi on 2018-01-21.
//

import Foundation

class ExchangeRateContainer {
    var exchangeRates: [ExchangeRate] = []
    
    var activeExchangeRate: ExchangeRate?
    
    var networkFetch: Bool = false
    
    func exchangeRateInfo(with base: String) -> ExchangeRate? {
        let filtered = exchangeRates.filter({ (exchangeRate) -> Bool in
            exchangeRate.base == base
        })
        print(filtered)
        guard filtered.count > 0 else {
            return nil
        }
        return filtered[0]
    }
}

//MARK: - Read, Write to Disk
extension ExchangeRateContainer {
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("eRates")
    
    func save() -> Bool {
        return NSKeyedArchiver.archiveRootObject(self.exchangeRates, toFile: ExchangeRateContainer.ArchiveURL.path)
    }
    
    func remove(stale exchangeRate: ExchangeRate) -> Bool {
        guard let index = self.exchangeRates.index(of: exchangeRate) else {
            return false
        }
        self.exchangeRates.remove(at: index)
        return save()
    }
    
    func retrieveAll() -> Bool {
        guard let eRates = NSKeyedUnarchiver.unarchiveObject(withFile: ExchangeRateContainer.ArchiveURL.path) as? [ExchangeRate], eRates.count > 0 else {
            return false
        }
        self.exchangeRates = eRates
        return true
    }
    
}

//MARK: - Fetching Service
extension ExchangeRateContainer {
    
    func loadExchangeRateFromDatabase(with base: String, completionBlock: @escaping ((Error?) -> Void)) {
        
        guard retrieveAll(), let localInfo = exchangeRateInfo(with: base) else {
            //Nothing found so fetch from the service
            
            print("\(base) not found - fetching from network")
            fetchExchangeRates(with: base, completionBlock: completionBlock)
            return
        }
        
        //Is it stale data?? if so get rid of it!!
        guard localInfo.staleData && remove(stale: localInfo) else {
            print("local fetch")
            networkFetch = false
            self.activeExchangeRate = localInfo
            completionBlock(nil)
            return
        }
        
        //Stale data ... so download it again
        print("stale data")
        fetchExchangeRates(with: base, completionBlock: completionBlock)
    }
    
    func fetchExchangeRates(with base: String?, completionBlock: @escaping ((Error?) -> Void)) {
        networkFetch = true
        ExchangeRateService.fetchExchangeRate(with: base) { [weak self] (data, error) in
            guard let strongSelf = self else {
                assertionFailure("Self is missing!!!!!")
                return
            }
            
            guard error == nil, let data = data else {
                completionBlock(error)
                return
            }
        
            guard let jsonObject = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
                completionBlock(ServiceError.parsingError)
                return
            }
            
            guard let base = jsonObject["base"] as? String,
                let date = jsonObject["date"] as? String,
                let rates = jsonObject["rates"] as? [String: Double] else {
                    completionBlock(ServiceError.parsingError)
                    return
            }
            
            guard let exchangeRate = ExchangeRate(base: base, date: date, rates: rates, timestamp: Date()) else {
                completionBlock(ServiceError.objectCreationError)
                return
            }
        
            strongSelf.exchangeRates.append(exchangeRate)
            strongSelf.activeExchangeRate = exchangeRate
            
            guard strongSelf.save() else {
                completionBlock(ServiceError.saveError)
                return
            }

            completionBlock(nil)
        }
    }
}
