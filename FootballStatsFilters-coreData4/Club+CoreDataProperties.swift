//
//  Club+CoreDataProperties.swift
//  FootballStatsFilters-coreData4
//
//  Created by Gilbert Andrei Floarea on 14/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//
//

import Foundation
import CoreData


extension Club {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Club> {
        return NSFetchRequest<Club>(entityName: "Club")
    }

    @NSManaged public var name: String?
    @NSManaged public var contact: String?
    @NSManaged public var mail: String?
    @NSManaged public var cupsWon: Int32
    @NSManaged public var federation: Federation?
    @NSManaged public var location: Location?
    @NSManaged public var priceInformation: PriceInformation?
    @NSManaged public var accomplishments: Accomplishments?
    @NSManaged public var topTierClub: Bool

}
