//
//  ViewController.swift
//  button
//
//  Created by Mariola Hullings on 6/19/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customButton: UIButton!
    private var isButtonConfigured = false
    private var initialButtonFrame: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if the customButton outlet is connected
        if customButton == nil {
            print("customButton outlet is not connected.")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard !isButtonConfigured, let button = customButton else { return }
        
        // Store the initial frame of the button
        initialButtonFrame = button.frame
        
        // Get the smaller dimension to make the button a perfect circle
        let dimension = min(button.bounds.width, button.bounds.height)
        
        // Set the button's width and height to the smallest dimension
        button.bounds.size = CGSize(width: dimension, height: dimension)
        
        // Make the button round
        button.layer.cornerRadius = dimension / 2
        
        // Calculate initial scale
        let initialScale: CGFloat = dimension / 150.0
        
        // Set initial scale
        button.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)

        // Store original button position
//        let originalButtonCenter = button.center
        
        // Store original button position and move it lower
               let originalButtonCenter = button.center
               button.center.y += 100  // Adjust this value to set the initial lower position


        // Animate the button to its final size and position
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                  button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4) // Grow the button to be 1.5 times the initial size
                  button.center = CGPoint(x: originalButtonCenter.x, y: originalButtonCenter.y - 10)
              }, completion: nil)
        
        // Ensure that the button maintains its round shape if the view's size changes
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Mark that the button has been configured
        isButtonConfigured = true
    }
}
