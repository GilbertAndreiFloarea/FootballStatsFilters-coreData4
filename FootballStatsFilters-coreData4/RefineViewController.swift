//
//  RefinerViewController.swift
//  FootballStatsFilters-coreData4
//
//  Created by Gilbert Andrei Floarea on 14/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//

import UIKit
import CoreData

protocol RefinerViewControllerDelegate: class {
    func RefinerViewController(filter: RefinerViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?)
}

class RefinerViewController: UITableViewController {
    
    @IBOutlet weak var firstPriceCategoryLabel: UILabel!
    @IBOutlet weak var secondPriceCategoryLabel: UILabel!
    @IBOutlet weak var thirdPriceCategoryLabel: UILabel!
    @IBOutlet weak var hasCupsWonLabel: UILabel!
    
    // MARK: - Price section
    @IBOutlet weak var cheapClubCell: UITableViewCell!
    @IBOutlet weak var moderateClubCell: UITableViewCell!
    @IBOutlet weak var expensiveClubCell: UITableViewCell!
    
    // MARK: - Most popular section
    @IBOutlet weak var hasCupsWonCell: UITableViewCell!
    @IBOutlet weak var closeAroundCell: UITableViewCell!
    @IBOutlet weak var hasTrophiesWonCell: UITableViewCell!
    
    // MARK: - Sort section
    @IBOutlet weak var nameAZSortCell: UITableViewCell!
    @IBOutlet weak var nameZASortCell: UITableViewCell!
    @IBOutlet weak var distanceSortCell: UITableViewCell!
    @IBOutlet weak var priceSortCell: UITableViewCell!
    
    // MARK: - Properties
    var coreDataStack: CoreDataStack!
    weak var delegate: RefinerViewControllerDelegate?
    var selectedSortDescriptor: NSSortDescriptor?
    var selectedPredicate: NSPredicate?
    
    lazy var cheapClubPredicate: NSPredicate = {
        return NSPredicate(format: "%K < %d", #keyPath(Club.priceInformation.priceBracket), 5)
    }()
    
    lazy var moderateClubPredicate: NSPredicate = {
        return NSPredicate(format: "%K < %d && %d < %K", #keyPath(Club.priceInformation.priceBracket), 10, 5, #keyPath(Club.priceInformation.priceBracket))
    }()
    
    lazy var expensiveClubPredicate: NSPredicate = {
        return NSPredicate(format: "%K > %d", #keyPath(Club.priceInformation.priceBracket), 10)
    }()
    
    lazy var hasCupsWonPredicate: NSPredicate = {
        return NSPredicate(format: "%K > 0", #keyPath(Club.cupsWon))
    }()
    
    lazy var walkingDistancePredicate: NSPredicate = {
        return NSPredicate(format: "%K < 1000", #keyPath(Club.location.distance))
    }()
    
    lazy var hasTrophiesWonPredicate: NSPredicate = {
        return NSPredicate(format: "%K > 10000", #keyPath(Club.accomplishments.trophiesWon))
    }()
    
    lazy var nameSortDescriptor: NSSortDescriptor = {
        let compareSelector = #selector(NSString.localizedStandardCompare(_:))
        return NSSortDescriptor(key: #keyPath(Club.name), ascending: true, selector: compareSelector)
    }()
    
    lazy var distanceSortDescriptor: NSSortDescriptor = {
        return NSSortDescriptor(key: #keyPath(Club.location.distance), ascending: true)
    }()
    
    lazy var priceSortDescriptor: NSSortDescriptor = {
        return NSSortDescriptor(key: #keyPath(Club.priceInformation.priceBracket), ascending: true)
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateCheapClubCountLabel()
        populateModerateClubCountLabel()
        populateExpensiveClubCountLabel()
        populateHasCupsWonLabel()
    }
    
    // MARK: - IBActions
    @IBAction func go(_ sender: UIBarButtonItem) {
        delegate?.RefinerViewController(filter: self, didSelectPredicate: selectedPredicate, sortDescriptor: selectedSortDescriptor)
        dismiss(animated: true)
    }
}

// MARK - UITableViewDelegate
extension RefinerViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath)else {
            return
        }
        
        switch cell {
        // Price section
        case cheapClubCell:
            selectedPredicate = cheapClubPredicate
        case moderateClubCell:
            selectedPredicate = moderateClubPredicate
        case expensiveClubCell:
            selectedPredicate = expensiveClubPredicate
            
        // Most Popular section
        case hasCupsWonCell:
            selectedPredicate = hasCupsWonPredicate
        case closeAroundCell:
            selectedPredicate = walkingDistancePredicate
        case hasTrophiesWonCell:
            selectedPredicate = hasTrophiesWonPredicate
            
        //Sort By section
        case nameAZSortCell:
            selectedSortDescriptor = nameSortDescriptor
        case nameZASortCell:
            selectedSortDescriptor = nameSortDescriptor.reversedSortDescriptor as? NSSortDescriptor
        case distanceSortCell:
            selectedSortDescriptor = distanceSortDescriptor
        case priceSortCell:
            selectedSortDescriptor = priceSortDescriptor
            
        default: break
        }
        
        cell.accessoryType = .checkmark
    }
}

// MARK: - Helper methods
extension RefinerViewController {
    
    func populateCheapClubCountLabel() {
        
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Club")
        fetchRequest.resultType = .countResultType
        fetchRequest.predicate = cheapClubPredicate
        
        do {
            let countResult = try coreDataStack.managedContext.fetch(fetchRequest)
            let count = countResult.first!.intValue
            let pluralized = count == 1 ? "club" : "clubs"
            firstPriceCategoryLabel.text = "\(count) football \(pluralized)"
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
        }
    }
    
    func populateModerateClubCountLabel() {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Club")
        fetchRequest.resultType = .countResultType
        fetchRequest.predicate = moderateClubPredicate
        
        do {
            let countResult = try coreDataStack.managedContext.fetch(fetchRequest)
            let count = countResult.first!.intValue
            let pluralized = count == 1 ? "club" : "clubs"
            secondPriceCategoryLabel.text = "\(count) football \(pluralized)"
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
        }
    }
    
    func populateExpensiveClubCountLabel() {
        
        let fetchRequest: NSFetchRequest<Club> = Club.fetchRequest()
        fetchRequest.predicate = expensiveClubPredicate
        do {
            let count = try coreDataStack.managedContext.count(for: fetchRequest)
            let pluralized = count == 1 ? "club" : "clubs"
            thirdPriceCategoryLabel.text = "\(count) football \(pluralized)"
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
        }
    }
    
    func populateHasCupsWonLabel() {
        
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Club")
        fetchRequest.resultType = .dictionaryResultType
        
        let cupsExpressionDesc = NSExpressionDescription()
        cupsExpressionDesc.name = "sumCups"
        
        let cupsCountExp = NSExpression(forKeyPath: #keyPath(Club.cupsWon))
        cupsExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [cupsCountExp])
        cupsExpressionDesc.expressionResultType = .integer32AttributeType
        
        fetchRequest.propertiesToFetch = [cupsExpressionDesc]
        
        do {
            let results = try coreDataStack.managedContext.fetch(fetchRequest)
            let resultDict = results.first!
            let numCups = resultDict["sumCups"] as! Int
            let pluralized = numCups == 1 ?  "cup" : "cups"
            hasCupsWonLabel.text = "\(numCups) \(pluralized)"
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
        }
    }
}

