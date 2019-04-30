//
//  AppDelegate.swift
//  FootballStatsFilters-coreData4
//
//  Created by Gilbert Andrei Floarea on 14/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var  coreDataStack = CoreDataStack(modelName: "FootballModel")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard let navController = window?.rootViewController as? UINavigationController,
            let viewController = navController.topViewController as? ViewController else {
                return true
        }
        
        viewController.coreDataStack = coreDataStack
        importJSONSeedDataIfNeeded()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        coreDataStack.saveContext()
    }

    func importJSONSeedDataIfNeeded() {
        let fetchRequest = NSFetchRequest<Club>(entityName: "Club")
        let count = try! coreDataStack.managedContext.count(for: fetchRequest)
        
        guard count == 0 else { return }
        
        do {
            let results = try coreDataStack.managedContext.fetch(fetchRequest)
            results.forEach { coreDataStack.managedContext.delete($0) }
            
            coreDataStack.saveContext()
            importJSONSeedData()
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
    }
    
    func importJSONSeedData() {
        let jsonURL = Bundle.main.url(forResource: "football", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonURL)
        
        let jsonDict = try! JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [String: Any]
        let responseDict = jsonDict["response"] as! [String: Any]
        let jsonArray = responseDict["squads"] as! [[String: Any]]
        
        for jsonDictionary in jsonArray {
            let clubName = jsonDictionary["name"] as? String
            
            
            let cupsWonDict = jsonDictionary["cupsWon"] as! [String: Any]
            let cupsWonCount = cupsWonDict["count"] as? NSNumber
            
            let locationDict = jsonDictionary["location"] as! [String: Any]
            let contactDict = locationDict["contactInfo"] as! [String: String]
            let clubPhone = contactDict["mobilePhone"]
            let clubMail = contactDict["email"]
            
            let priceDict = jsonDictionary["price"] as! [String: Any]
            let statsDict =  jsonDictionary["stats"] as! [String: Any]
            
            let location = Location(context: coreDataStack.managedContext)
            location.address = locationDict["address"] as? String
            location.city = locationDict["city"] as? String
            location.country = locationDict["country"] as? String
            location.postcode = locationDict["postalCode"] as? String
            let distance = locationDict["distance"] as? NSNumber
            location.distance = distance!.floatValue
            
            let category = jsonDictionary["categories"] as! [[String: Any]]
            let federation = Federation(context: coreDataStack.managedContext)
            federation.name = category.first!["name"] as? String
//            federation.id = category["id"] as? String
            
            let priceInformation = PriceInformation(context: coreDataStack.managedContext)
            priceInformation.priceBracket = priceDict["currency"] as? Double ?? 0
            
            let accomplishments = Accomplishments(context: coreDataStack.managedContext)
            let trophiesWon = statsDict["trophiesWon"] as? NSNumber
            accomplishments.trophiesWon = trophiesWon as! Int64
            let noOfPlayers = statsDict["noOfPlayers"] as? NSNumber
            accomplishments.noOfPlayers = noOfPlayers as! Int64
            let tickets = statsDict["ticketsSoldLastYear"] as? NSNumber
            accomplishments.ticketsSoldLastYear = tickets as! Int64
            
            let club = Club(context: coreDataStack.managedContext)
            club.name = clubName
            club.contact = clubPhone
            club.mail = clubMail
            club.cupsWon = cupsWonCount!.int32Value
            club.location = location
            club.federation = federation
            club.priceInformation = priceInformation
            club.accomplishments = accomplishments
        }
        
        coreDataStack.saveContext()
    }
}

