//
//  Location+CoreDataProperties.swift
//  FootballStatsFilters-coreData4
//
//  Created by Gilbert Andrei Floarea on 14/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var distance: Float
    @NSManaged public var state: String?
    @NSManaged public var postcode: String?
    @NSManaged public var club: Club?

}
