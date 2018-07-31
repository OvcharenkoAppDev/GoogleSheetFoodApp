//
//  RootWireframe.swift
//  RiddleFood
//
//  Created by Константин Овчаренко on 21.07.2018.
//  Copyright © 2018 Константин Овчаренко. All rights reserved.
//

import UIKit

protocol IRootWireframe {
    func present(viewController: UIViewController)
    func close(viewController: UIViewController)
}

final class RootWireframe: NSObject, IRootWireframe {
    
        static let sharedInstance = RootWireframe()

    
    func present(viewController: UIViewController) {
        self.rootNavigationController?.present(viewController,
                                               animated: true,
                                               completion: {
                    
        })
    }
    func close(viewController: UIViewController) {
        let animated = true
        
        OperationQueue.main.addOperation {
            if viewController.navigationController != nil {
                viewController.navigationController?.popViewController(animated: animated)
            } else {
                viewController.dismiss(animated: animated, completion: {
                    
                })
            }
        }
    }
    
    
    private var rootNavigationController: NavigationVC?
    
    private var window: UIWindow? {
        didSet {
            let libraryVC = MainViewController()
            self.rootNavigationController = NavigationVC(rootViewController: libraryVC)
            self.rootNavigationController?.setNavigationBarHidden(true, animated: false)
            
            self.window?.rootViewController = self.rootNavigationController
            self.window?.makeKeyAndVisible()
        }
    }
    
    private override init() {
        
    }
}
