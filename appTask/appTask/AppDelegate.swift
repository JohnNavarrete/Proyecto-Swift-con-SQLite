//
//  AppDelegate.swift
//  appTask
//
//  Created by John P. Navarrete on 23/12/21.
//  Copyright © 2021 John P. Navarrete. All rights reserved.
//

import UIKit
import SQLite3

var dbQueue:OpaquePointer!

var dbURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        dbQueue = createAndOpenDatabase() //    CREA Y ABRE LAS BASE DE DATOS
        
        if (createTables() == false) {
            print("Error in create tables")
        }else{
            print("YAY")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func createAndOpenDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        
        let url = NSURL(fileURLWithPath: dbURL)
        if let pathComponent = url.appendingPathComponent("TEST.sqlite")
        {
            let filePath = pathComponent.path
            
            if sqlite3_open(filePath, &db) == SQLITE_OK
            {
                print("Succesfuly apened the database :) at \(filePath)")
                return db
            }
            else
            {
                print("Could not open the database")
            }
        }
        else
        {
            print("File Path is not avilable. ")
        }
        
        return db
    }
    
    func createTables() -> Bool
    {
        var bRetVal : Bool = false
        
        let createTable = sqlite3_exec(dbQueue, "CREATE TABLE IF NOT EXISTs TEMP (TEMPCOLUMN1 TEXT NULL, TEMPCOLUMN2 TEXT NULL)", nil, nil, nil)
        
        if (createTable != SQLITE_OK) {
            print("Not able to create table")
            bRetVal = false
        }else{
            bRetVal = true
        }
        return bRetVal
        
        
    }

}

