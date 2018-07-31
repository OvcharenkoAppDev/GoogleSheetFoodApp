//
//  GoogleSheetNotificationame.swift
//  RiddleFood
//
//  Created by Константин Овчаренко on 21.07.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//
import Foundation

enum GoogleSheetNotificationName: String {


    case error        = "FoodNotificationName_error"
    case message      = "FoodNotificationName_message"
    case errorMessage = "FoodNotificationName_errorMessage"
    
    case didUpdatedData = "FoodNotificationName_didUpdateData"
}

enum  GoogleSheetNotificationParameters: String {
    case error    = "FoodNotificationParameters_error"
    case message  = "FoodNotificationParameters_message"
}


