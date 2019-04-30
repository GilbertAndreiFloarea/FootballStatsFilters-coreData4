//
//  Federation+CoreDataProperties.swift
//  FootballStatsFilters-coreData4
//
//  Created by Gilbert Andrei Floarea on 14/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//
//

import Foundation
import CoreData


extension Federation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Federation> {
        return NSFetchRequest<Federation>(entityName: "Federation")
    }

    @NSManaged public var federationID: String?
    @NSManaged public var name: String?
    @NSManaged public var club: Club?

}
