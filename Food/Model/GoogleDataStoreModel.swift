//
//  GoogleDataStoreModel.swift
//  RiddleFood
//
//  Created by Константин Овчаренко on 20.07.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

protocol IGoogleSheetDataStore{
    func currentMyName() -> String?
    func createOrder(food: String, value : Bool)
    func signIn()
    func signInSilentl()
    var foodArray : [String] {get}
    var foods : [Food] {get}
}

class GoodleSheetDataStore : NSObject {
    static var sharedManager : IGoogleSheetDataStore = DefaultGoogleSheetDataStore()
}

typealias DefaultGoogleDataStore_WriteCompletion = () -> Void

class DefaultGoogleSheetDataStore : NSObject, IGoogleSheetDataStore, GIDSignInUIDelegate, GIDSignInDelegate {
    
        var arrayData = [[Any]]()
        var namesArray = [String]()
        var foodArray = [String]()
        var userName : String?
        var foods = [Food]()
    
    
        static var sharedManager = DefaultGoogleSheetDataStore()
    
    func letterFromColumn(column: Int) -> String {
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        return letters[column]
    }
    
    let spreadsheetId = "14R934twuL-rVUdaqUvz4yS-sSY8H5LEFQP-Z50ZDxgw"

    func currentMyName() -> String? {
       return GIDSignIn.sharedInstance().currentUser?.profile.name
    }
    
    func signIn() {
            GIDSignIn.sharedInstance().signIn()
    }
    
    func signInSilentl() {
        if false == GIDSignIn.sharedInstance().hasAuthInKeychain() {
            return
        }
        
        OperationQueue.main.addOperation {
            GIDSignIn.sharedInstance().signInSilently()
        }
    }
    
    func fill(data: [[Any]]) {
        
        guard var foodNames: [String] = data.first as? [String] else {
            return
        }
        
        var foodArray : [Food] = []
        
        foodNames.remove(at: 0)
        
        var userNames: [String] = []
        
        for i in 1..<data.count {
            var line = data[i]
            let userName: String? = line.first as? String
            line.remove(at: 0)
            userNames.append(userName!)
            
            for j in 0..<foodNames.count {
                let value: String? = line.count > j ? (line[j] as? String) : ""
                let foodName: String = foodNames[j]
                let food = Food()
                food.nameFood = foodName
                food.nameUser = userName ?? ""
                food.line = i + 1
                food.column = j + 1
                food.isOrdered = value == "1"
                foodArray.append(food)
                
            }
        }
        self.namesArray = userNames
        self.foodArray = foodNames
        self.foods = foodArray
    }
    
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.rootWireframe.present(viewController: viewController)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("didDisconnectWith error \(error)")
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.rootWireframe.close(viewController: viewController)
    }
    
    func sendRequest() {
        
        let range = Date().dayOfWeek()
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            
            .query(withSpreadsheetId: spreadsheetId, range:range)
        print(range)
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(receivingData(ticket:finishedWithObject:error:))
        )
    }
    
    @objc func receivingData(ticket: GTLRServiceTicket, finishedWithObject result : GTLRSheets_ValueRange, error : NSError?) {
        
        if error != nil {
            return
        }else {
            guard let tableData = result.values else {
                return
            }
            self.arrayData = tableData
            self.fill(data: tableData)
            
            
            let notificationName = NSNotification.Name.init(GoogleSheetNotificationName.didUpdatedData.rawValue)
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil
            )
        }
    }
  
    func chekUser() -> (String?,Int) {
        
        guard let userName = self.userName else {return (nil,-1)}
        let userLine : Int? = self.namesArray.index(of: userName)

        if userLine == nil{
            var lastLine = 1
            for food in foods{
                if food.line > lastLine{
                    lastLine = food.line
                }
            }
            lastLine += 1
            return (self.userName, lastLine)
        }
        return (nil,userLine! + 2)
    }
    
    
    override init() {
        super.init()
        
        GIDSignIn.sharedInstance().delegate   = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes     = self.scopes
  
    }
    
    // MARK: - Private
    
    
    private var rootWireframe: IRootWireframe = RootWireframe.sharedInstance
    
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets]
    
    private let service = GTLRSheetsService()
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if nil != error {
            self.service.authorizer = nil
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            
            if UserDefaults.standard.string(forKey: "UserName") == nil {
            self.userName = user.profile.name
            self.sendRequest()
        }
            
      }
    }
    
}


