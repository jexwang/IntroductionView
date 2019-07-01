//
//  TailView.swift
//  IntroductionView
//
//  Created by 王冠綸 on 2019/6/28.
//  Copyright © 2019 jexwang. All rights reserved.
//

import UIKit

class TailView: UIView {
    
    private var position: IntroductionView.Position
    
    init(frame: CGRect, position: IntroductionView.Position) {
        self.position = position
        
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath()
        
        switch position {
        case .top:
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        case .left:
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        case .right:
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        case .bottom:
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        
        path.close()
        
        UIColor.white.setFill()
        path.fill()
    }

}
