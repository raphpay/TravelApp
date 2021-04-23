//
//  WeatherServiceTest.swift
//  TravelAppTests
//
//  Created by Raphaël Payet on 23/04/2021.
//

import XCTest
@testable import TravelApp

class WeatherServiceTest: XCTestCase {
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
    
    
//    func testGetCurrentWeatherFailedWithNoDataInLocalCity() {
//        // Given
//        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.currentWeatherCorrectData,
//                                                response: nil, error: nil)
//        let weatherService = WeatherService(session: fakeSession)
//
//        // When
//        let expectation = XCTestExpectation(description: "testGetCurrentWeatherFailedWithNoDataInLocalCity")
//        weatherService.getWeather(in: .local, for: .current) { (success, _objects) in
//            // Then
//            XCTAssertFalse(success)
//            XCTAssertNil(_objects)
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 0.01)
//    }
    
    func testGetCurrentWeatherFailedWithIncorrectDataInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.weatherIncorrectData,
                                                response: nil, error: nil)
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
}
