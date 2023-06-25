//
//  CatsAndModules_YanaBuhaApp.swift
//  CatsAndModules_YanaBuha
//
//  Created by Yana Buha on 30.05.2023.
//

import Foundation
import SwiftUI
import Networking
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct CatsAndModules_YanaBuhaApp: App {
    @StateObject var network = DataOfImage()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            List()
                .environmentObject(network)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

