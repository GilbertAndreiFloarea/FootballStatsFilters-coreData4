//
//  FootballClubDetailsVC.swift
//  FootballStatsFilters-coreData4
//
//  Created by Gilbert Andrei Floarea on 15/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//

import UIKit

class FootballClubDetailsVC: ViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var federationLabel: UILabel!
    @IBOutlet weak var trophiesLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var ticketsLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var cupsLabel: UILabel!
    
    var club: Club?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen(club: club)
    }
    
    func configureScreen(club: Club?) {
        guard let club = club else {
            return
        }
        self.navigationItem.title = club.name ?? ""
        cityLabel.text = "City: \(club.location?.city ?? "N/A")"
        countryLabel.text = "Country: \(club.location?.country ?? "N/A")"
        distanceLabel.text = "Distance: \(club.location?.distance ?? 0) kilometers away"
        phoneLabel.text = "Phone no: \(club.contact ?? "")"
        emailLabel.text = "Mail: \(club.mail ?? "")"
        zipLabel.text = "Zip Code: \(club.location?.postcode ?? "N/A")"
        federationLabel.text = "\(club.federation?.name ?? "N/A")"
        trophiesLabel.text = "Trophies won: \(club.accomplishments?.trophiesWon ?? 0) trophies"
        playersLabel.text = "Players registered: \(club.accomplishments?.noOfPlayers ?? 0) players"
        ticketsLabel.text = "Tickets sold last year: \(club.accomplishments?.ticketsSoldLastYear ?? 0) tickets"
        valueLabel.text = "Budget: \(club.priceInformation?.priceBracket ?? 0) millions"
        cupsLabel.text = "\(club.cupsWon) \(club.cupsWon == 1 ? "cup won" : "cups won")"
    }
}
