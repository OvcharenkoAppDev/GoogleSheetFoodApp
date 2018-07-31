//
//  ExtensionCreateOrder.swift
//  RiddleFood
//
//  Created by Константин Овчаренко on 31.07.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//

import Foundation
import GoogleSignIn

extension DefaultGoogleSheetDataStore {
    
    
    func createOrder(food: String, value : Bool){ // extension - 2
        
        
        guard var columt = self.foodArray.index(of: food) else {return}
        columt += 1
        
        let day = Date().dayOfWeek()
        let writeValue : String = value ? "1" : ""
        let chekUserResult = self.chekUser()
        if chekUserResult.1 > 0 {
            if let userName = chekUserResult.0{
                self.write(value: userName, row: chekUserResult.1, column: 0, page: day, completion: {
                    self.write(value: writeValue, row: chekUserResult.1, column: columt, page: day, completion: {
                        self.sendRequest()
                    })
                })
            } else {
                self.write(value: writeValue, row: chekUserResult.1, column: columt, page: day, completion: {
                    self.sendRequest()
                })
                
            }
        }
    }
    
    private func write(value: String, row: Int, column: Int, page: String, completion : @escaping DefaultGoogleDataStore_WriteCompletion) { // extinsion - 2 (private)
        
        let range = "\(page)!\(self.letterFromColumn(column: column))\(row)"
        let requestParams = [
            "values": [
                [value]
            ]
        ]
        
        
        // URL
        let encodedRange = range.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURLString: String = "https://sheets.googleapis.com/v4/spreadsheets/\(self.spreadsheetId)/values/\(encodedRange!)?valueInputOption=USER_ENTERED"
        let requestURL: URL = URL(string: requestURLString)!
        var request: URLRequest = URLRequest.init(url: requestURL)
        
        // DATA
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted)
        
        // HEADERS
        let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken!
        let authorizationHeaderValue = "Bearer \(accessToken)"
        request.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
        
        // SEND
        let urlSessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        let urlSession: URLSession = URLSession(configuration: urlSessionConfig)
        let dataTask: URLSessionDataTask = urlSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let responseData = data {
                print("data \(try? JSONSerialization.jsonObject(with: responseData, options: []))")
            } else {
                print("empty data")
            }
            
            print("error \(error)")
            completion()
        }
        dataTask.resume()
    }

    
}
