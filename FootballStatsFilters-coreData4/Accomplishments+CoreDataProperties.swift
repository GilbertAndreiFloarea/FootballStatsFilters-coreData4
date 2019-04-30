//
//  Accomplishments+CoreDataProperties.swift
//  FootballStatsFilters-coreData4
//
//  Created by Gilbert Andrei Floarea on 14/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//
//

import Foundation
import CoreData


extension Accomplishments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Accomplishments> {
        return NSFetchRequest<Accomplishments>(entityName: "Accomplishments")
    }

    @NSManaged public var trophiesWon: Int64
    @NSManaged public var noOfPlayers: Int64
    @NSManaged public var ticketsSoldLastYear: Int64
    @NSManaged public var club: Club?

}
