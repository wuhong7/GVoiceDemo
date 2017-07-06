//
//  WHBaseTabBarController.swift
//  GVoiceDemo
//
//  Created by 盖特 on 2017/7/5.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class WHBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var array = [WHBaseNavigationController]()
        array.append(loadChileViewControllerWithClassName(controller: WHDiscoveryChannelController(), title: "发现频道", imageName: "xinwen"))
//        array.append(loadChileViewControllerWithClassName(controller: WHDiscoveryChannelController(), title: "频道", imageName: "biaoqian"))
//        array.append(loadChileViewControllerWithClassName(controller: SGTagsController(), title: "标签", imageName: "biaoqian"))
//        array.append(loadChileViewControllerWithClassName(controller: SGSetController(), title: "设置", imageName: "shezhi"))
        
        self.viewControllers = array
        
    }

    func loadChileViewControllerWithClassName(controller:WHBaseViewController , title:String , imageName:String) -> WHBaseNavigationController{
        
        controller.title = title
        //嵌套导航控制器
        let nav = WHBaseNavigationController(rootViewController: controller)
        //设置图片
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: "\(imageName)-red"))
        
        return nav
        
    }


}
