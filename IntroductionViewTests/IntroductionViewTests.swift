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
    
    let alpha: CGFloat = 1
    let confirmButtonTitle = "Test button title"
    let highlightArea = CGRect(x: 0, y: 0, width: 100, height: 100)
    let testMessage = "Test message."

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        IntroductionView.setMaskAlpha(alpha)
        IntroductionView.setButtonTitle(confirmButtonTitle)
        IntroductionView.setHighlight(frame: highlightArea, with: testMessage)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        IntroductionView.clear()
    }
    
    func testMask() {
        let check = IntroductionView.introductionView.view.backgroundColor == UIColor(white: 0, alpha: alpha)
        XCTAssertTrue(check, "Mask dosen't show the right background color.")
    }
    
    func testHighlightArea() {
        if let mask = IntroductionView.introductionView.view.layer.mask as? CAShapeLayer,
            let path = mask.path {
            // TODO: Can't test.
            XCTAssertTrue(true, "Highlight area dosen't show the right frame.")
        } else {
            XCTAssert(false, "Fatal error.")
        }
    }
    
    func testMessageLabel() {
        let check = IntroductionView.introductionView.messageLabel?.text == testMessage
        XCTAssertTrue(check, "Message label dosen't show the right message.")
    }
    
    func testConfirmButton() {
        let check = IntroductionView.introductionView.confirmButton?.titleLabel?.text == confirmButtonTitle
        XCTAssertTrue(check, "Confirm button dosen't show the right title.")
    }

}
