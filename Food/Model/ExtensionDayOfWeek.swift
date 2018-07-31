//
//  ExtansionDayOfWeek.swift
//  RiddleFood
//
//  Created by Константин Овчаренко on 21.07.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//
import Foundation

extension Date {
    func dayOfWeek() -> String {
        
        switch Calendar.current.dateComponents([.weekday], from: self).weekday {
        case 2?:
            return "Понедельник"
        case 3?:
            return "Вторник"
        case 4?:
            return "Среда"
        case 5?:
            return "Четверг"
        case 6?:
            return "Пятница"
        default:
            return "Выходной"
        }
    }
}
