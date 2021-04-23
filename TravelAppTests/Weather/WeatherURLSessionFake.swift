//
//  WeatherURLSessionFake.swift
//  TravelAppTests
//
//  Created by Raphaël Payet on 23/04/2021.
//

import Foundation


import Foundation

class WeatherURLSessionFake : URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = WeatherURLSessionDataTaskFake() // TODO : Find how this method is now implemented
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
}

class WeatherURLSessionDataTaskFake : URLSessionDataTask {
    var completionHandler: ((Data? , URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    override func resume() {
        completionHandler?(data, urlResponse, error)
    }
    
    override func cancel() {}

}
