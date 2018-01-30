//
//  ExchangeContainerTests.swift
//  CurrencyConverterTests
//
//  Created by Naga Mullapudi on 2018-01-22.
//  Copyright © 2017 Naga Mullapudi. All rights reserved.
//

import XCTest
@testable import CurrencyConversion

class ExchangeContainerTests: XCTestCase {
    let container = ExchangeRateContainer()
    let base = "USD"
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let expectation: XCTestExpectation = self.expectation(description: "Fetch Rates")
        container.loadExchangeRateFromDatabase(with: base) { (error) in
            DispatchQueue.main.async {
                expectation.fulfill()
               
            }
        }

        self.waitForExpectations(timeout: TimeInterval(INT16_MAX)) { (error) in
            XCTAssertNil(error, "Service failed to send a response")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsNetworkFetch() {
        XCTAssertTrue(container.networkFetch, "This is a local Fetch")
    }
    
    func testIsNotNetworkFetch() {
        XCTAssertFalse(container.networkFetch, "This is a network Fetch")
    }
    
    func testActiveExchangeRate() {
        XCTAssertNotNil(container.activeExchangeRate, "activeExchangeRate is missing")
        XCTAssertTrue(container.activeExchangeRate?.base == base, "Not the right exchange rate")
    }
    
    func testExchangeRates() {
        XCTAssertTrue(container.exchangeRates.count > 0, "exchangeRates should not be none")
    }

}
