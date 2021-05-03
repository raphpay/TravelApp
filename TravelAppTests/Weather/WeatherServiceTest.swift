//
//  WeatherServiceTest.swift
//  TravelAppTests
//
//  Created by Raphaël Payet on 23/04/2021.
//

import XCTest
import UIKit
@testable import TravelApp

class WeatherServiceTest: XCTestCase {
    
    
    // MARK: - Current Weather Tests
    // Error - OK
    // No data - Response ok - OK
    // Incorrect data - Response ok - OK
    // Correct data - Response not ok - OK
    // Correct data - Response ok - OK
    
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
    
    
    // MARK: - Daily Weather tests
    // Error - OK
    // No data - Response ok - OK
    // Incorrect data - Response ok - OK
    // Correct data - Response not ok - OK
    // Correct data - Response ok - OK
    
    func testGetDailyWeatherFailedWithErrorInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: nil, response: nil, error: FakeWeatherResponseData.error)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Error")
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDailyWeatherFailedWithNoDataInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: nil,
                                                response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "No Data")
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDailyWeatherFailedWithIncorrectDataInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.weatherIncorrectData,
                                                response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Incorrect Data")
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDailyWeatherFailedWithIncorrectResponseInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.dailyWeatherCorrectData,
                                                response: FakeWeatherResponseData.responseNotOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Incorrect Response")
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDailyWeatherFailedWithCorrectDataInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.dailyWeatherCorrectData,
                                                response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Correct Data")
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDailyWeatherSucceedInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.dailyWeatherCorrectData,
                                                response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Correct Data")
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    // MARK: - Hourly Weather Tests
    // Error - OK
    // No data - Response ok - OK
    // Incorrect data - Response ok - OK
    // Correct data - Response not ok - OK
    // Correct data - Response ok - OK
    
    func testGetHourlyWeatherFailedWithErrorInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: nil,
                                                response: nil, error: FakeWeatherResponseData.error)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Error")
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetHourlyWeatherFailedWithNoDataInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: nil,
                                                response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "No Data")
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetHourlyWeatherFailedWithIncorrectDataInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.weatherIncorrectData,
                                                response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Incorrect Data")
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetHourlyWeatherFailedWithIncorrectResponseInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.hourlyWeatherCorrectData,
                                                response: FakeWeatherResponseData.responseNotOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Incorrect Response")
        weatherService.getWeather(in: .local, for: .day) { (success, _objects) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetHourlyWeatherSucceedInLocalCity() {
        // Given
        let fakeSession = WeatherURLSessionFake(data: FakeWeatherResponseData.hourlyWeatherCorrectData,
                                                response: FakeWeatherResponseData.responseOK, error: nil)
        let weatherService = WeatherService(session: fakeSession)
        
        // When
        let expectation = XCTestExpectation(description: "Correct Data")
        weatherService.getWeather(in: .local, for: .hour) { (success, _objects) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(_objects)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    // MARK: - Icon conversion
    func testGivenIDIs200WhenGettingWeatherIconThenWeatherIsThunderstorm() {
        let icon = WeatherService.shared.convertIcon(id: 200)
        XCTAssertEqual(icon, UIImage(named: WeatherIcons.thunderstorm.rawValue)!)
    }
    
    func testGivenIDIs300WhenGettingWeatherIconThenWeatherIsDrizzle() {
        let icon = WeatherService.shared.convertIcon(id: 300)
        XCTAssertEqual(icon, UIImage(named: WeatherIcons.drizzle.rawValue)!)
    }
    
    func testGivenIDIs500WhenGettingWeatherIconThenWeatherIsRain() {
        let icon = WeatherService.shared.convertIcon(id: 500)
        XCTAssertEqual(icon, UIImage(named: WeatherIcons.rain.rawValue)!)
    }
    
    func testGivenIDIs600WhenGettingWeatherIconThenWeatherIsSnow() {
        let icon = WeatherService.shared.convertIcon(id: 600)
        XCTAssertEqual(icon, UIImage(named: WeatherIcons.snow.rawValue)!)
    }
    
    func testGivenIDIs711WhenGettingWeatherIconThenWeatherIsSmoke() {
        let icon = WeatherService.shared.convertIcon(id: 711)
        XCTAssertEqual(icon, UIImage(named: WeatherIcons.smoke.rawValue)!)
    }
    
    func testGivenIDIs741WhenGettingWeatherIconThenWeatherIsFog() {
        let icon = WeatherService.shared.convertIcon(id: 741)
        XCTAssertEqual(icon, UIImage(named: WeatherIcons.fog.rawValue)!)
    }
    
    func testGivenIDIs800WhenGettingWeatherIconThenWeatherIsClear() {
        let icon = WeatherService.shared.convertIcon(id: 800)
        XCTAssertEqual(icon, UIImage(named: WeatherIcons.clear.rawValue)!)
    }
    
    func testGivenIDIs801WhenGettingWeatherIconThenWeatherIsCloud() {
        let icon = WeatherService.shared.convertIcon(id: 801)
        XCTAssertEqual(icon, UIImage(named: WeatherIcons.cloud.rawValue)!)
    }
}
