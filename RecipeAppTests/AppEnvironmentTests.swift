//
//  AppEnvironmentTests.swift
//  RecipeApp
//
//  Created by Ravi Seta on 27/01/25.
//


import XCTest

@testable import RecipeApp

final class AppEnvironmentTests: XCTestCase {

    func testAppEnvironmentSingleton() {
        // Ensure `AppEnvironment.shared` is always the same instance.
        let instance1 = AppEnvironment.shared
        let instance2 = AppEnvironment.shared
        
        XCTAssertTrue(instance1 === instance2, "AppEnvironment.shared should return the same instance.")
    }
    
    func testDefaultEnvironmentType() {
        // Ensure the default `environmentType` is `.production`.
        let environment = AppEnvironment.shared
        
        XCTAssertEqual(environment.environmentType, .production, "Default environment type should be `.production`.")
    }
    
    func testUpdateEnvironmentType() {
        // Ensure `environmentType` can be updated.
        let environment = AppEnvironment.shared
        
        environment.environmentType = .production // Set to `.production`
        XCTAssertEqual(environment.environmentType, .production, "Environment type should be `.production`.")
    }
}
