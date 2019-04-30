//
//  ViewController.swift
//  FootballStatsFilters-coreData4
//
//  Created by Gilbert Andrei Floarea on 14/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let RefinerViewControllerSegueIdentifier = "toRefinerViewControllerSI"
    private let clubCellIdentifier = "ClubCell"
    
    var coreDataStack: CoreDataStack!
    
    var fetchRequest: NSFetchRequest<Club>?
    var clubs: [Club] = []
    var asyncFetchRequest: NSAsynchronousFetchRequest<Club>?
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let batchUpdate = NSBatchUpdateRequest(entityName: "Club")
        batchUpdate.propertiesToUpdate = [#keyPath(Club.topTierClub): true]
        batchUpdate.affectedStores = coreDataStack.managedContext.persistentStoreCoordinator?.persistentStores
        batchUpdate.resultType = .updatedObjectsCountResultType

        do {
            let batchResult = try coreDataStack.managedContext.execute(batchUpdate) as! NSBatchUpdateResult
            print("Records updated \(batchResult.result!)")
        } catch let error as NSError {
            print("Could not update \(error), \(error.userInfo)")
        }
        
        let clubFetchRequest: NSFetchRequest<Club> = Club.fetchRequest()
        fetchRequest = clubFetchRequest
        
        asyncFetchRequest = NSAsynchronousFetchRequest<Club>(fetchRequest: clubFetchRequest) {
            [unowned self] (result: NSAsynchronousFetchResult) in
            
            guard let clubs = result.finalResult else {
                return
            }
            
            self.clubs = clubs
            self.tableView?.reloadData()
        }
        
        do {
            guard let asyncFetchRequest = asyncFetchRequest else {
                return
            }
            try coreDataStack.managedContext.execute(asyncFetchRequest)
            // Returns immediately, cancel here if you want
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == RefinerViewControllerSegueIdentifier,
            let navController = segue.destination as? UINavigationController,
            let refineVC = navController.topViewController as? RefinerViewController else {
                return
        }
        
        refineVC.coreDataStack = coreDataStack
        refineVC.delegate = self
    }
}

// MARK: - IBActions
extension ViewController {
    
    @IBAction func unwindToClubListViewController(_ segue: UIStoryboardSegue) {
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: clubCellIdentifier, for: indexPath) as? ClubTableViewCell {
            let club = clubs[indexPath.row]
            cell.clubNameLabel.text = club.name
            cell.clubPriceBracketLabel.text = String(club.priceInformation?.priceBracket ?? 0)
            cell.clubTrophiesWon.text = "\(club.accomplishments?.trophiesWon ?? 0) T"
            if club.cupsWon != 0 {
                cell.cupsLabel.isHidden = false
                cell.cupsLabel.text = "\(club.cupsWon) C"
            } else {
                cell.cupsLabel.isHidden = true
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storbyboard = UIStoryboard(name: "Main", bundle: nil)
        if let footballClubDetailsVC = storbyboard.instantiateViewController(withIdentifier: "footballClubDetailsVCID") as? FootballClubDetailsVC {
            footballClubDetailsVC.club = clubs[indexPath.row]
            footballClubDetailsVC.coreDataStack = coreDataStack
            self.navigationController?.pushViewController(footballClubDetailsVC, animated: true)
        }
    }
    
}

// MARK: - RefinerViewControllerDelegate
extension ViewController: RefinerViewControllerDelegate {
    
    func RefinerViewController(filter: RefinerViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) {
        
        guard let fetchRequest = fetchRequest else {
            return
        }
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        fetchRequest.predicate = predicate
        
        if let sr = sortDescriptor {
            fetchRequest.sortDescriptors = [sr]
        }
        
        fetchAndReload()
    }
}

// MARK: - Helper methods
extension ViewController {
    
    func fetchAndReload() {
        
        guard let fetchRequest = fetchRequest else {
            return
        }
        
        do {
            clubs = try coreDataStack.managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}


