//
//  IntroductionWindow.swift
//  TestProject
//
//  Created by 王冠綸 on 2019/6/27.
//  Copyright © 2019 lixin. All rights reserved.
//

import UIKit

public class IntroductionView {
    
    internal static var introductionView: IntroductionView!
    internal static var alpha: CGFloat = 0.6
    
    private let window: UIWindow
    internal let viewController: UIViewController
    
    // MARK: - Private function
    
    private init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        viewController = UIViewController()
        
        window.rootViewController = viewController
        window.isHidden = false
        
        viewController.view.backgroundColor = .black
        viewController.view.alpha = IntroductionView.alpha
    }
    
    deinit {
        print("Release IntroductionView")
    }
    
    private func setHighlight(frame: CGRect) {
        let path = UIBezierPath(rect: viewController.view.frame)
        path.append(UIBezierPath(rect: frame))
        setMask(path: path.cgPath)
    }
    
    private func addHighlight(frame: CGRect) {
        if let shapeLayer = viewController.view.layer.mask as? CAShapeLayer,
            let path = shapeLayer.path {
            let newPath = UIBezierPath(cgPath: path)
            newPath.append(UIBezierPath(rect: frame))
            setMask(path: newPath.cgPath)
        } else {
            setHighlight(frame: frame)
        }
    }
    
    private func setMask(path: CGPath) {
        let mask = CAShapeLayer()
        mask.path = path
        mask.fillRule = .evenOdd
        viewController.view.layer.mask = mask
    }
    
    // MARK: - Public static function
    
    public static func setMaskAlpha(_ alpha: CGFloat) {
        self.alpha = alpha
        
        if introductionView != nil {
            introductionView.viewController.view.alpha = alpha
        }
    }
    
    public static func setHighlight(frame: CGRect) {
        introductionView = IntroductionView()
        introductionView.setHighlight(frame: frame)
    }
    
    public static func setHighlight(for view: UIView) {
        introductionView = IntroductionView()
        
        let highlightFrame = view.convert(view.bounds, to: introductionView.viewController.view)
        introductionView.setHighlight(frame: highlightFrame)
    }
    
    public static func addHighlight(frame: CGRect) {
        if introductionView != nil {
            introductionView.addHighlight(frame: frame)
        } else {
            setHighlight(frame: frame)
        }
    }
    
    public static func addHighlight(for view: UIView) {
        if introductionView != nil {
            let highlightFrame = view.convert(view.bounds, to: introductionView.viewController.view)
            introductionView.addHighlight(frame: highlightFrame)
        } else {
            setHighlight(for: view)
        }
    }
    
    public static func clear() {
        introductionView = nil
    }
    
}
