//
//  MainTabBarViewController.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor(red: 132/255, green: 128/255, blue: 247/255, alpha: 1.0)
        self.configureTabbar()
        self.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 55
        tabFrame.origin.y = self.view.frame.size.height - 55
        self.tabBar.frame = tabFrame
        
        setDefaultSelection()
        
    }
    func configureTabbar() {
        
        self.tabBar.alpha = 1.0
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        let count = self.tabBar.items?.count ?? 0
        for i in 0..<count {
            let item: UITabBarItem = self.tabBar.items![i]
            
            if i == 0  {
                item.title = "Home"
                item.image = UIImage(named:"tabbar_home")?.withRenderingMode(.alwaysOriginal)
            }else if i == 1  {
                item.title = "Feed"
                item.image = UIImage(named:"tabbar_feed")?.withRenderingMode(.alwaysOriginal)
            }
            else if i == 2  {
                item.title = "Users"
                item.image = UIImage(named:"tabbar_group")?.withRenderingMode(.alwaysOriginal)
            }
            else if i == 3  {
                item.title = "Friends"
                item.image = UIImage(named:"tabbar_friends")?.withRenderingMode(.alwaysOriginal)
            }
            else if i == 4  {
                item.title = "Settings"
                item.image = UIImage(named:"tabbar_setting")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    func setDefaultSelection() {
        let itemWidth = tabBar.frame.width / CGFloat(tabBar.items!.count)
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: tabBar.frame.height)
        )
        let bottomView = UIView(frame: CGRect(x: 0, y: (tabBar.frame.height - 2), width: itemWidth, height: 2))
        bottomView.backgroundColor = UIColor(patternImage: UIImage(named: "BottomDivider")!)
        tabBar.insertSubview(bottomView, at: 0)
        //bgView.backgroundColor = UIColor.black
        bgView.backgroundColor = UIColor.white
        tabBar.insertSubview(bgView, at: 0)
    }
    func clearSelections() {
        for views in tabBar.subviews {
            views.backgroundColor = UIColor.clear
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        clearSelections()
        setSelection(item: item)
    }
    func setSelection(item:UITabBarItem) {
        
        for i in 0..<self.tabBar.items!.count {
            let tabItem = self.tabBar.items![i]
//            if i == 0 {
//                if tabItem !=  item{
//                    let itemWidth = tabBar.frame.width / CGFloat(tabBar.items!.count)
//                    let bgView = UIView(frame: CGRect(x: itemWidth * CGFloat(i), y: 0, width: itemWidth, height: tabBar.frame.height)
//                    )
//                    bgView.backgroundColor = UIColor.red
////                    bgView.startBlink()
//                    tabBar.insertSubview(bgView, at: 0)
//
//                }
//            }
            if(item == tabItem) {
                let itemWidth = tabBar.frame.width / CGFloat(tabBar.items!.count)
                let bgView = UIView(frame: CGRect(x: itemWidth * CGFloat(i), y: 0, width: itemWidth, height: tabBar.frame.height)
                )
                let bottomView = UIView(frame: CGRect(x: itemWidth * CGFloat(i), y: (tabBar.frame.height - 2), width: itemWidth, height: 2))
                bottomView.backgroundColor = UIColor(patternImage: UIImage(named: "BottomDivider")!)
                tabBar.insertSubview(bottomView, at: 0)
                //bgView.backgroundColor = UIColor.black
                bgView.backgroundColor = UIColor.white
                tabBar.insertSubview(bgView, at: 0)
            }
        }
    }
    
    
    
    
}
