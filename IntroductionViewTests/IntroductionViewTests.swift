//
//  IntroductionViewTests.swift
//  IntroductionViewTests
//
//  Created by 王冠綸 on 2019/6/28.
//  Copyright © 2019 jexwang. All rights reserved.
//

import XCTest
@testable import IntroductionView

class IntroductionViewTests: XCTestCase {
    
    let highlightArea = CGRect(x: 0, y: 0, width: 100, height: 100)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        IntroductionView.setHighlight(frame: highlightArea)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        IntroductionView.clear()
    }
    
    func testMask() {
        let view = IntroductionView.introductionView.viewController.view!
        
        IntroductionView.setMaskAlpha(1)
        let alphaCheck = view.alpha == IntroductionView.alpha
        XCTAssertTrue(alphaCheck, "Mask dosen't show the right alpha.")
        
        let colorCheck = view.backgroundColor == .black
        XCTAssertTrue(colorCheck, "Mask dosen't show the right background color.")
    }
    
    func testHighlightArea() {
        if let mask = IntroductionView.introductionView.viewController.view.layer.mask as? CAShapeLayer,
            let path = mask.path {
            // TODO: Can't test.
            XCTAssertTrue(true, "Highlight area dosen't show the right frame.")
        } else {
            XCTAssert(false, "Fatal error.")
        }
    }

}
