//
//  File.swift
//  Food
//
//  Created by Константин Овчаренко on 01.08.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//

import Foundation

public class Food {
    var nameUser = ""
    var nameFood = ""
    var line = 0
    var column = 0
    var isOrdered = false
    var columnLetter = ""
    
    static func currentUserFoods() -> [Food] {
        let googleDataStor = DefaultGoogleSheetDataStore.sharedManager
        guard let currentUserName = googleDataStor.currentMyName() else {
            return []
        }
        
        let foods = googleDataStor.foods
        
        var userFoods: [Food] = []
        
        for food in foods {
            if food.nameUser == currentUserName {
                userFoods.append(food)
            }
        }
        
        if userFoods.count <= 0 {
            for foodName in googleDataStor.foodArray {
                let food = Food()
                food.nameUser = currentUserName
                food.nameFood = foodName
                food.isOrdered = false
                food.column = -1
                food.line = -1
                userFoods.append(food)
            }
        }
        
        return userFoods
    }
    
    static func orderedFoodNames() -> [String]{
        
        let foods : [Food] = self.currentUserFoods()
        var foodNames : [String] = []
        for food in foods {
            if food.isOrdered {
                foodNames.append(food.nameFood)
            }
        }
        return foodNames
    }
    
    static func notOrderedFoodNames() -> [String]{
        
        let foods : [Food] = self.currentUserFoods()
        var foodNames : [String] = []
        for food in foods {
            if !food.isOrdered {
                foodNames.append(food.nameFood)
            }
        }
        return foodNames
    }
}
