//
//  ViewController.swift
//  RiddleFood
//
//  Created by Константин Овчаренко on 18.07.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//
import GoogleAPIClientForREST
import UIKit
import GoogleSignIn

class MainViewController: UIViewController {
    
    private weak var dataLable : UILabel?
    private weak var youOrderFood : UILabel?
    private weak var yonNotOredFood : UILabel?
    
    
    private  var googleSheetDataStore: IGoogleSheetDataStore = DefaultGoogleSheetDataStore.sharedManager
    private weak var notOrderedFood : NotOrderedFoodTableView?
    private weak var orderedFoof : OrderedFoodTableView?
//    var food = [Food]
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.gray
            self.googleSheetDataStore.signIn()
            self.addSubviews()
            

         
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.

        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width  = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let x : CGFloat = 0
        let y : CGFloat = 20
        let offSet : CGFloat = 10
        let tableHeight : CGFloat = height / 3
        let lableHeight : CGFloat = 40
        
        self.dataLable?.frame = CGRect(x: x,
                                       y: y,
                                       width: width,
                                       height: lableHeight)
        let youOrderY = lableHeight + offSet + y
        
        self.youOrderFood?.frame = CGRect(x: x,
                                          y: youOrderY,
                                          width: width,
                                          height: lableHeight)
        
        let orderedFoodY = youOrderY + lableHeight + offSet
        
        self.orderedFoof?.frame = CGRect(x: x,
                                         y: orderedFoodY,
                                         width: width,
                                         height: tableHeight)
        let youNotOrderFoodY = orderedFoodY + tableHeight + offSet
        
        self.yonNotOredFood?.frame = CGRect(x: x,
                                            y: youNotOrderFoodY,
                                            width: width,
                                            height: lableHeight)
        let notOrderedFoodY = youNotOrderFoodY + lableHeight + offSet
        self.notOrderedFood?.frame = CGRect(x: x,
                                            y: notOrderedFoodY,
                                            width: width,
                                            height: tableHeight)
        
    }
    
    func addSubviews(){
        self.addDataLable()
        self.addYouOrderFood()
        self.addOrderedTable()
        self.addyonNotOredFood()
        self.addNotOrderedTable()
    }
    
    func addNotOrderedTable(){
        let notOrderedFood = NotOrderedFoodTableView()
        self.view.addSubview(notOrderedFood)
        self.notOrderedFood = notOrderedFood

        
    }
    func addOrderedTable(){
        let orderedFood = OrderedFoodTableView()
        self.view.addSubview(orderedFood)
        self.orderedFoof = orderedFood

    }
    
    func addDataLable(){
        let lable = UILabel()
        self.view.addSubview(lable)
        self.dataLable = lable
        self.dataLable?.text = "Сегодня \(Date().dayOfWeek())"
        self.dataLable?.textAlignment = .center
        self.dataLable?.textColor = UIColor.black
        self.dataLable?.backgroundColor = UIColor.white
   
    }
    func addYouOrderFood(){
        let lable = UILabel()
        self.view.addSubview(lable)
        self.youOrderFood = lable
        self.youOrderFood?.text = "В твоем заказе уже "
        self.youOrderFood?.textAlignment = .center
        self.youOrderFood?.backgroundColor = UIColor.white
        
    }
    func addyonNotOredFood(){
        let lable1 = UILabel()
        self.view.addSubview(lable1)
        self.yonNotOredFood = lable1
        self.yonNotOredFood?.textAlignment = .center
        self.yonNotOredFood?.text = "Но ты можешь дозаказать еще "
        self.yonNotOredFood?.backgroundColor = UIColor.white
    }
    
    
}

