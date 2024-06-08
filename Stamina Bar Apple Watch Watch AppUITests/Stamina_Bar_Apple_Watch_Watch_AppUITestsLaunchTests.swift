//
//  Stamina_Bar_Apple_Watch_Watch_AppUITestsLaunchTests.swift
//  Stamina Bar Apple Watch Watch AppUITests
//
//  Created by Bryce Ellis on 5/8/24.
//

import XCTest

final class Stamina_Bar_Apple_Watch_Watch_AppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
