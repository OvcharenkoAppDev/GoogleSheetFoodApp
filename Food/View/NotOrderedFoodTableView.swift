//
//  NotOrderedFoodTableView.swift
//  RiddleFood
//
//  Created by Kostyan on 26.07.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//

import UIKit
import SVProgressHUD

class NotOrderedFoodTableView: UIView, UITableViewDataSource,UITableViewDelegate{

    var foodArray: [String] = []
    var googleDataStroe : IGoogleSheetDataStore = DefaultGoogleSheetDataStore.sharedManager
    
    private weak var tableVIewNotOrdered : UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.addSubviews()
        self.foodArray = Food.notOrderedFoodNames()
        let notificationName = NSNotification.Name.init(GoogleSheetNotificationName.didUpdatedData.rawValue)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NotOrderedFoodTableView.didUpdatedTable(notification:)),
                                               name: notificationName,
                                               object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        let avalibl  = self.tableVIewNotOrdered?.sizeThatFits(CGSize(width: width, height: height))
        
        self.tableVIewNotOrdered?.frame = CGRect(x: 0,
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
        self.tableVIewNotOrdered = tableView
        self.tableVIewNotOrdered.dataSource = self
        self.tableVIewNotOrdered.delegate = self
        self.tableVIewNotOrdered.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        self.googleDataStroe.createOrder(food: foodArray[indexPath.row], value: true)
    }
    
    
    @objc private func didUpdatedTable(notification: Notification) {
        self.foodArray = Food.notOrderedFoodNames()
        self.tableVIewNotOrdered.reloadData()
        SVProgressHUD.dismiss()
    }

    
}
