//
//  DocumentsCoordinator.swift
//  ImageManager
//
//  Created by Aleksey Lexx on 19.02.2023.
//

import Foundation
import UIKit

class DocumentsCoordinator {
    
    static let shared = DocumentsCoordinator()
    
    private func getDocumentsURL() -> URL {
        let documentsURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let doucmentsURL = documentsURLs[0]
        return doucmentsURL
    }
    
    func createNavigationController(for rootViewController: UIViewController, with model: TabBarModel) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        navigationController.navigationBar.tintColor = UIColor(named: "NavigationColor")
        navigationController.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        navigationController.navigationBar.backgroundColor = UIColor(named: "NavigationColor")
        navigationController.tabBarItem = UITabBarItem(title: model.title,
                                                       image: model.image,
                                                       tag: model.tag)
        return navigationController
    }
    
    func createTabBarController() -> UITabBarController {
        
        let tabBarController = UITabBarController()
        UITabBar.appearance().backgroundColor = UIColor(named: "NavigationColor")
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
        UITabBar.appearance().isTranslucent = true
        tabBarController.tabBar.tintColor = UIColor(named: "PurpleColor")
        tabBarController.viewControllers = [
            self.createNavigationController(for: DocumentsViewController(fileURL: getDocumentsURL(),
                                                                         directoryTitle: getDocumentsURL().lastPathComponent), with: TabBarModel(title: "Documents",image: UIImage(systemName: "doc.on.doc"),tag: 0)),
            self.createNavigationController(for: SettingsViewController(),
                                               with: TabBarModel(title: "Settings",
                                                                 image: UIImage(systemName: "gearshape.2.fill"),
                                                                 tag: 1)),
        ]
        return tabBarController
    }
}

struct TabBarModel {
    let title: String
    let image: UIImage?
    let tag: Int
}

