//
//  NotOrderedFoodTableView.swift
//  RiddleFood
//
//  Created by Kostyan on 26.07.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//

import UIKit
import SVProgressHUD

class OrderedFoodTableView: UIView, UITableViewDataSource,UITableViewDelegate{
    
    var foodArray: [String] = []
    var googleDataStroe : IGoogleSheetDataStore = DefaultGoogleSheetDataStore.sharedManager
    
    
    private weak var tableVIewOrdered : UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews()
        self.foodArray = Food.orderedFoodNames()
        
        
        
        
        let notificationName = NSNotification.Name.init(GoogleSheetNotificationName.didUpdatedData.rawValue)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(OrderedFoodTableView.didUpdatedTable(notification:)),
                                               name: notificationName,
                                               object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        let avalibl  = self.tableVIewOrdered?.sizeThatFits(CGSize(width: width, height: height))
        
        self.tableVIewOrdered?.frame = CGRect(x: 0,
                                       y: 0,
                                       width: width,
                                       height: height)
    }
    
    func addSubviews(){
         self.addTableView()
    }
    
    func addTableView(){
        let tableView = UITableView()
        self.addSubview(tableView)
        self.tableVIewOrdered = tableView
        self.tableVIewOrdered.dataSource = self
        self.tableVIewOrdered.delegate = self
        self.tableVIewOrdered.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel!.text = "\(foodArray[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SVProgressHUD.show()
        self.googleDataStroe.createOrder(food: foodArray[indexPath.row], value: false)
    }
    
    
    @objc private func didUpdatedTable(notification: Notification) {

        self.foodArray = Food.orderedFoodNames()
        self.tableVIewOrdered.reloadData()
        SVProgressHUD.dismiss()
    }

    
}
