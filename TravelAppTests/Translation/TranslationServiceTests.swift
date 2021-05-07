//
//  TranslationServiceTests.swift
//  TravelAppTests
//
//  Created by Raphaël Payet on 04/05/2021.
//

import XCTest
@testable import TravelApp

class TranslationServiceTests: XCTestCase {
    // Error - OK
    // No data - Response ok -
    // Incorrect data - Response ok -
    // Correct data - Response not ok -
    // Correct data - Response ok -
    
    func testGivenCallbackFailed_WhenError_ThenSuccessIsFalseAndTextIsNil(){
        // Given
        let fakeSession = TranslateURLSessionFake(data: nil, response: nil, error: FakeTranslationResponseData.error)
        let translationService = TranslationService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Error")
        translationService.getTranslation(baseText: FakeTranslationResponseData.baseText, targetLanguage: .french) { (success, text) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(text)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenCallbackFailed_WhenNoData_ThenSuccessIsFalseAndTextIsNil(){
        // Given
        let fakeSession = TranslateURLSessionFake(data: nil,
                                                  response: FakeTranslationResponseData.responseOK, error: nil)
        let translationService = TranslationService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "No data")
        translationService.getTranslation(baseText: FakeTranslationResponseData.baseText, targetLanguage: .french) { (success, text) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(text)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenCallbackFailed_WhenIncorrectData_ThenSuccessIsFalseAndTextIsNil(){
        // Given
        let fakeSession = TranslateURLSessionFake(data: FakeTranslationResponseData.translateIncorrectData,
                                                  response: FakeTranslationResponseData.responseOK, error: nil)
        let translationService = TranslationService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Incorrect data")
        translationService.getTranslation(baseText: FakeTranslationResponseData.baseText, targetLanguage: .french) { (success, text) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(text)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenCallbackFailed_WhenIncorrectResponse_ThenSuccessIsFalseAndTextIsNil(){
        // Given
        let fakeSession = TranslateURLSessionFake(data: FakeTranslationResponseData.translateCorrectData,
                                                  response: FakeTranslationResponseData.responseNotOK, error: nil)
        let translationService = TranslationService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Incorrect response")
        translationService.getTranslation(baseText: FakeTranslationResponseData.baseText, targetLanguage: .french) { (success, text) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(text)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenCallbackSucceed_WhenCorrectDataAndResponse_ThenSuccessIsTrueAndTextIsTranslated(){
        // Given
        let fakeSession = TranslateURLSessionFake(data: FakeTranslationResponseData.translateCorrectData,
                                                  response: FakeTranslationResponseData.responseOK, error: nil)
        let translationService = TranslationService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Error")
        translationService.getTranslation(baseText: FakeTranslationResponseData.baseText, targetLanguage: .french) { (success, text) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(text)
            XCTAssertEqual(text, FakeTranslationResponseData.translatedText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
