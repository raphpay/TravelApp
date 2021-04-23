//
//  CurrencyConverterServiceTest.swift
//  TravelAppTests
//
//  Created by Raphaël Payet on 18/04/2021.
//

import XCTest
@testable import TravelApp

class CurrencyConverterServiceTest: XCTestCase {
    func testGetCurrencyRateFailedWithError() {
        // Given
        let fakeSession = CurrencyURLSessionFake(data: nil, response: nil, error: FakeCurrencyResponseData.error)
        let currencyService = CurrencyConverterService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "testGetCurrencyRateFailedCallbackIfError")
        currencyService.getRate(from: .euro, to: .usDollar) { (_value, success) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrencyRateFailedWithoutData() {
        // Give
        let fakeSession = CurrencyURLSessionFake(data: nil, response: FakeCurrencyResponseData.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currencyService.getRate(from: .euro, to: .usDollar) { (_value, success) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrencyRateFailedWithIncorrectData() {
        // Given
        let fakeSession = CurrencyURLSessionFake(data: FakeCurrencyResponseData.currencyIncorrectData,
                                         response: FakeCurrencyResponseData.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currencyService.getRate(from: .euro, to: .usDollar) { (_value, success) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrencyRateFailedWithIncorrectResponse() {
        // Given
        let fakeSession = CurrencyURLSessionFake(data: FakeCurrencyResponseData.currencyCorrectData,
                                         response: FakeCurrencyResponseData.responseNotOK, error: nil)
        let currencyService = CurrencyConverterService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currencyService.getRate(from: .euro, to: .usDollar) { (_value, success) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_value)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrencyRateSuccessCompletion() {
        // Given
        let fakeSession = CurrencyURLSessionFake(data: FakeCurrencyResponseData.currencyCorrectData,
                                         response: FakeCurrencyResponseData.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currencyService.getRate(from: .euro, to: .usDollar) { (_value, success) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(_value)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}


