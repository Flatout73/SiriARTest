//
//  ViewController.swift
//  SiriAR
//
//  Created by Леонид Лядвейкин on 26/03/2019.
//  Copyright © 2019 Леонид Лядвейкин. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    var cars: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cars = CarsManager.shared.cars
        
        INPreferences.requestSiriAuthorization { (status) in
            
        }
        INVocabulary.shared().setVocabularyStrings(["bmw", "audi"], of: .carName)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        cell.textLabel?.text = cars[indexPath.row].name
        cell.accessoryType = cars[indexPath.row].locked ? .checkmark : .none
        return cell
    }
    
    
}

