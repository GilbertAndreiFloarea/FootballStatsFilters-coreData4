//
//  PriceInformation+CoreDataProperties.swift
//  FootballStatsFilters-coreData4
//
//  Created by Gilbert Andrei Floarea on 15/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//
//

import Foundation
import CoreData


extension PriceInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PriceInformation> {
        return NSFetchRequest<PriceInformation>(entityName: "PriceInformation")
    }

    @NSManaged public var priceBracket: Double
    @NSManaged public var club: Club?

}
