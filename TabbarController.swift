//
//  TabbarController.swift
//  button
//
//  Created by Mariola Hullings on 6/20/23.
//


import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let customButton = UIButton(type: .custom)
    private var isButtonConfigured = false
    private var initialButtonFrame: CGRect?
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        customizeTabBarAppearance()
        configureCustomButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeHeightOfTabbar()
//        layoutCustomButton()
    }
    
    func changeHeightOfTabbar() {
        let tabBarHeight = view.safeAreaInsets.bottom + 45 + 12
        var tabFrame = tabBar.frame
        tabFrame.size.height = tabBarHeight
        tabFrame.origin.y = view.frame.size.height - tabBarHeight
        tabBar.frame = tabFrame
    }
    
    func customizeTabBarAppearance() {
        let greenColor = UIColor(red: 228/255, green: 248/255, blue: 237/255, alpha: 1.0)
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: greenColor, cornerRadius: 10)
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }

    func configureCustomButton() {
        if let image = UIImage(named: "svg-heart") {
            customButton.setImage(image, for: .normal)
        }
        customButton.isHidden = true
        view.addSubview(customButton)
    }
    
    
    func layoutCustomButton() {
        guard !isButtonConfigured else { return }
        
        //        sets initial size of icon
        let dimension: CGFloat = 25
        customButton.bounds.size = CGSize(width: dimension, height: dimension)
        customButton.layer.cornerRadius = dimension / 4
        customButton.center.x = view.center.x
        //        sets the height of the button
        customButton.center.y = tabBar.frame.origin.y + tabBar.frame.size.height / 6.5
        
        
        let initialScale: CGFloat = 0.1
        customButton.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
        
        isButtonConfigured = true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = self.tabBar.items?.firstIndex(of: item)
        
        if index == 2 {
            customButton.isHidden = false
            let originalButtonCenter = customButton.center
            customButton.center.y = originalButtonCenter.y + 100
            
            UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {
                let scale = UIScreen.main.bounds.width / 105 // Adjust the denominator to fit your needs
                self.customButton.transform = CGAffineTransform(scaleX: scale, y: scale)

//                self.customButton.transform = CGAffineTransform(scaleX: 4.4, y: 4.4)
                self.customButton.center = originalButtonCenter
            }, completion: nil)
        } else {
            customButton.isHidden = true
            customButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2) // Reset the transform
        }
    }
}


extension UIImage {
    func createSelectionIndicator(color: UIColor, cornerRadius: CGFloat) -> UIImage {
        let size = CGSize(width: 45, height: 45)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()
        
        // Create the outer square
        let outerPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
        color.setFill()
        outerPath.fill()
        
        // Create the inner square (selection fill)
        let borderWidth: CGFloat = 4
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height )
        let innerPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        innerPath.addClip()
        
        // Draw the inner square with border
        let borderPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        UIColor(red: 0, green: 195/255, blue: 103/255, alpha: 1.0).setStroke()
        borderPath.lineWidth = borderWidth
        borderPath.stroke()
        
        // Get the final image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.withRenderingMode(.alwaysOriginal) ?? UIImage()
    }
}


