//
//  IntroductionView.swift
//  IntroductionView
//
//  Created by 王冠綸 on 2019/6/28.
//  Copyright © 2019 jexwang. All rights reserved.
//

import UIKit

public protocol IntroductionViewDelegate: class {
    func introductionViewDidClickButton()
}

public class IntroductionView {
    
    internal enum Position {
        case top, left, right, bottom
    }
    
    private static weak var delegate: IntroductionViewDelegate?
    
    internal static var introductionView: IntroductionView!
    
    internal static var alpha: CGFloat = 0.8
    internal static var confirmButtonTitle: String = "I known."
    
    internal let view: UIView
    private let window: UIWindow
    
    private var messageView: UIView?
    internal var messageLabel: UILabel?
    internal var confirmButton: UIButton?
    
    private var margin: CGFloat = 8
    
    // MARK: - Private function
    
    private init() {
        let viewController = UIViewController()
        
        view = viewController.view
        view.backgroundColor = UIColor(white: 0, alpha: IntroductionView.alpha)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.isHidden = false
    }
    
    deinit {
        print("Release IntroductionView")
    }
    
    private func setHighlight(frame: CGRect) {
        let path = UIBezierPath(rect: view.frame)
        path.append(UIBezierPath(rect: frame))
        setMask(path: path.cgPath)
    }
    
    private func addHighlight(frame: CGRect) {
        if let shapeLayer = view.layer.mask as? CAShapeLayer,
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
        view.layer.mask = mask
    }
    
    private func setMessageView(message: String, refrenceFrame: CGRect) {
        messageView = UIView()
        messageView!.layer.cornerRadius = 4
        messageView!.backgroundColor = .white
        messageView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageView!)
        setMessageViewConstraints(refrenceFrame: refrenceFrame)
        
        setMessageLabel(text: message)
        setConfirmButton()
        setTail(refrenceFrame: refrenceFrame)
        adjustMessageView()
    }
    
    private func setMessageViewConstraints(refrenceFrame: CGRect) {
        guard let messageView = messageView else { return }
        
        let xConstraint: NSLayoutConstraint
        let xSecondConstraint: NSLayoutConstraint
        let yConstraint: NSLayoutConstraint
        let ySecondConstraint: NSLayoutConstraint
        
        let position = getPosition(refrenceFrame: refrenceFrame)
        let tailSize = getTailSize(messageViewPosition: position)
        
        switch position {
        case .top:
            xConstraint = messageView.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: refrenceFrame.midX)
            xSecondConstraint = messageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -(margin * 2))
            yConstraint = messageView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: refrenceFrame.minY - tailSize.height - margin)
            ySecondConstraint = messageView.topAnchor.constraint(greaterThanOrEqualTo: window.layoutMarginsGuide.topAnchor, constant: margin)
        case .left:
            xConstraint = messageView.rightAnchor.constraint(equalTo: view.leftAnchor, constant: refrenceFrame.minX - tailSize.width - margin)
            xSecondConstraint = messageView.leftAnchor.constraint(greaterThanOrEqualTo: window.layoutMarginsGuide.leftAnchor, constant: margin)
            yConstraint = messageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: refrenceFrame.midY)
            ySecondConstraint = messageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, constant: -(margin * 2))
        case .right:
            xConstraint = messageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: refrenceFrame.maxX + tailSize.width + margin)
            xSecondConstraint = messageView.rightAnchor.constraint(lessThanOrEqualTo: window.layoutMarginsGuide.rightAnchor, constant: -margin)
            yConstraint = messageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: refrenceFrame.midY)
            ySecondConstraint = messageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, constant: -(margin * 2))
        case .bottom:
            xConstraint = messageView.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: refrenceFrame.midX)
            xSecondConstraint = messageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -(margin * 2))
            yConstraint = messageView.topAnchor.constraint(equalTo: view.topAnchor, constant: refrenceFrame.maxY + tailSize.height + margin)
            ySecondConstraint = messageView.bottomAnchor.constraint(lessThanOrEqualTo: window.layoutMarginsGuide.bottomAnchor, constant: -margin)
        }
        
        NSLayoutConstraint.activate([
            xConstraint,
            xSecondConstraint,
            yConstraint,
            ySecondConstraint
        ])
    }
    
    private func getPosition(refrenceFrame: CGRect) -> Position {
        let topSpace = refrenceFrame.minY - view.bounds.minY
        let leftSpace = refrenceFrame.minX - view.bounds.minX
        let rightSpace = view.bounds.maxX - refrenceFrame.maxX
        let bottomSpace = view.bounds.maxY - refrenceFrame.maxY
        let biggestSpace = [topSpace, leftSpace, rightSpace, bottomSpace].sorted().last!
        
        let position: Position
        switch true {
        case topSpace == biggestSpace:
            position = .top
        case leftSpace == biggestSpace:
            position = .left
        case rightSpace == biggestSpace:
            position = .right
        case bottomSpace == biggestSpace:
            position = .bottom
        default:
            position = .top
        }
        
        return position
    }
    
    private func getTailSize(messageViewPosition: Position) -> CGSize {
        switch messageViewPosition {
        case .top, .bottom:
            return CGSize(width: 16, height: 8)
        case .left, .right:
            return CGSize(width: 8, height: 16)
        }
    }
    
    private func setMessageLabel(text: String) {
        guard let messageView = messageView else { return }
        
        messageLabel = UILabel()
        messageLabel!.text = text
        messageLabel!.numberOfLines = 0
        messageLabel!.translatesAutoresizingMaskIntoConstraints = false
        messageView.addSubview(messageLabel!)
        
        NSLayoutConstraint.activate([
            messageLabel!.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 8),
            messageLabel!.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 8),
            messageLabel!.rightAnchor.constraint(lessThanOrEqualTo: messageView.rightAnchor, constant: -8)
        ])
    }
    
    private func setConfirmButton() {
        guard let messageView = messageView,
            let messageLabel = messageLabel else { return }
        
        confirmButton = UIButton(type: .system)
        confirmButton!.setTitle(IntroductionView.confirmButtonTitle, for: .normal)
        confirmButton!.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        confirmButton!.setContentCompressionResistancePriority(.required, for: .vertical)
        confirmButton!.translatesAutoresizingMaskIntoConstraints = false
        messageView.addSubview(confirmButton!)
        
        NSLayoutConstraint.activate([
            confirmButton!.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            confirmButton!.leftAnchor.constraint(greaterThanOrEqualTo: messageView.leftAnchor, constant: 8),
            confirmButton!.rightAnchor.constraint(lessThanOrEqualTo: messageView.rightAnchor, constant: -8),
            confirmButton!.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func confirmButtonClick(_ sender: UIButton) {
        IntroductionView.delegate?.introductionViewDidClickButton()
    }
    
    private func setTail(refrenceFrame: CGRect) {
        guard let messageView = messageView else { return }
        view.layoutIfNeeded()
        
        let position = getPosition(refrenceFrame: refrenceFrame)
        let tailSize = getTailSize(messageViewPosition: position)
        
        let x: CGFloat
        let y: CGFloat
        switch position {
        case .top:
            x = refrenceFrame.midX - tailSize.width / 2
            y = messageView.frame.maxY
        case .left:
            x = messageView.frame.maxX
            y = refrenceFrame.midY - tailSize.height / 2
        case .right:
            x = messageView.frame.minX - tailSize.width
            y = refrenceFrame.midY - tailSize.height / 2
        case .bottom:
            x = refrenceFrame.midX - tailSize.width / 2
            y = messageView.frame.minY - tailSize.height
        }
        
        let frame = CGRect(origin: CGPoint(x: x, y: y), size: tailSize)
        let tailView = TailView(frame: frame, position: position)
        view.addSubview(tailView)
    }
    
    private func adjustMessageView() {
        guard let messageView = messageView else { return }
        
        switch true {
        case messageView.frame.minX < view.frame.minX + margin:
            let offset = view.frame.minX + margin - messageView.frame.minX
            messageView.transform = CGAffineTransform(translationX: offset, y: 0)
        case messageView.frame.maxX > view.frame.maxX - margin:
            let offset = view.frame.maxX - margin - messageView.frame.maxX
            messageView.transform = CGAffineTransform(translationX: offset, y: 0)
        case messageView.frame.minY < view.frame.minY + margin :
            let offset = view.frame.minY + margin - messageView.frame.minY
            messageView.transform = CGAffineTransform(translationX: 0, y: offset)
        case messageView.frame.maxY > view.frame.maxY - margin:
            let offset = view.frame.maxY - margin - messageView.frame.maxY
            messageView.transform = CGAffineTransform(translationX: 0, y: offset)
        default:
            break
        }
    }
    
}

// MARK: - Public static function
extension IntroductionView {
    
    public static func setDelegate(_ delegate: IntroductionViewDelegate?) {
        self.delegate = delegate
    }
    
    public static func setMaskAlpha(_ alpha: CGFloat) {
        self.alpha = alpha
        
        if introductionView != nil { introductionView.view.backgroundColor = UIColor(white: 0, alpha: alpha) }
    }
    
    public static func setButtonTitle(_ title: String) {
        confirmButtonTitle = title
    }
    
    public static func setHighlight(frame: CGRect, with message: String? = nil) {
        introductionView = IntroductionView()
        introductionView.setHighlight(frame: frame)
        
        if let message = message { introductionView.setMessageView(message: message, refrenceFrame: frame) }
    }
    
    public static func setHighlight(for view: UIView, with message: String? = nil) {
        introductionView = IntroductionView()
        
        let highlightFrame = view.convert(view.bounds, to: introductionView.view)
        introductionView.setHighlight(frame: highlightFrame)
        
        if let message = message { introductionView.setMessageView(message: message, refrenceFrame: highlightFrame) }
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
            let highlightFrame = view.convert(view.bounds, to: introductionView.view)
            introductionView.addHighlight(frame: highlightFrame)
        } else {
            setHighlight(for: view)
        }
    }
    
    public static func clear() {
        introductionView = nil
    }
    
}
