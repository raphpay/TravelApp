//
//  WeatherServiceTest.swift
//  TravelAppTests
//
//  Created by Raphaël Payet on 23/04/2021.
//

import XCTest
@testable import TravelApp

class WeatherServiceTest: XCTestCase {
    // Error
    // No data - Response ok
    // Incorrect data - Response ok
    // Correct data - Response not ok
    // Correct data - Response ok
    
    // Current
    func testGetCurrentWeatherFailedWithErrorInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: nil, response: nil, error: FakeWeatherResponseData.error)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Error")
        weatherService.getWeather(in: .local, for: .current) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrentWeatherFailedWithNoDataInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: nil,
                                                response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "No Data")
        weatherService.getWeather(in: .local, for: .current) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrentWeatherFailedWithIncorrectDataInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.weatherIncorrectData,
                                                response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Incorrect Data")
        weatherService.getWeather(in: .local, for: .current) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrentWeatherFailedWithIncorrectResponseInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.currentWeatherCorrectData,
                                                response: FakeWeatherResponseData.responseNotOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Incorrect Response")
        weatherService.getWeather(in: .local, for: .current) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetCurrentWeatherSucceedInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.currentWeatherCorrectData,
                                                response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Correct Data")
        weatherService.getWeather(in: .local, for: .current) { (success, _objects) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Error
    // No data - Response ok
    // Incorrect data - Response ok
    // Correct data - Response not ok
    // Correct data - Response ok
    
    // Daily
    
    func testGetDailyWeatherFailedWithErrorInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: nil, response: nil, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Incorrect Response")
        weatherService.getWeather(in: .local, for: .current) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
