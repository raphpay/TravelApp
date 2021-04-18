//
//  CurrencyConverterServiceTest.swift
//  TravelAppTests
//
//  Created by Raphaël Payet on 18/04/2021.
//

import XCTest
@testable import TravelApp

class CurrencyConverterServiceTest: XCTestCase {
    func testGetCurrencyRateFailedCallbackIfError() {
        // Given
        let fakeSession = URLSessionFake(data: nil, response: FakeCurrencyResponseData.responseOK, error: FakeCurrencyResponseData.error)
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
    
    func testGetCurrencyRateFailedCallbackIfNoData() {
        // Give
        let fakeSession = URLSessionFake(data: nil, response: FakeCurrencyResponseData.responseOK, error: nil)
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
    
    func testGetCurrencyRateFailedCallbackIfIncorrectData() {
        // Given
        let fakeSession = URLSessionFake(data: FakeCurrencyResponseData.currencyIncorrectData,
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
    
    func testGetCurrencyRateFailedCallbackIfIncorrectResponse() {
        // Given
        let fakeSession = URLSessionFake(data: FakeCurrencyResponseData.currencyCorrectData,
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
    
    func testGetCurrencyRateSuccessCallback() {
        // Given
        let fakeSession = URLSessionFake(data: FakeCurrencyResponseData.currencyCorrectData,
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
    
    func testGetCurrencyRateShouldPostSuccessIfNoErrorAndCorrectData() {
        // Given
        let fakeSession = URLSessionFake(data: FakeCurrencyResponseData.currencyCorrectData,
                                         response: FakeCurrencyResponseData.responseOK, error: nil)
        let currencyService = CurrencyConverterService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currencyService.getRate(from: .euro, to: .usDollar) { (_value, success) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(_value)
            // See for the rate how to see equal
//            XCTAssertEqual(base, )
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}


