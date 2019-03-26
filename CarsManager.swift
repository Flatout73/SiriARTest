//
//  CarsManager.swift
//  SiriAR
//
//  Created by Леонид Лядвейкин on 26/03/2019.
//  Copyright © 2019 Леонид Лядвейкин. All rights reserved.
//

import Foundation

class Car: NSObject, NSCoding {
    var name: String
    var locked: Bool = true
    
    init(name: String) {
        self.name = name
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(locked, forKey: "locked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.locked = aDecoder.decodeBool(forKey: "locked")
    }
}

class CarsManager {
    static let shared = CarsManager()
    
    let defaults = UserDefaults(suiteName: "group.SiriAR")!
    var cars: [Car] = []
    
    var isAuthorized = false {
        didSet {
            defaults.set(isAuthorized, forKey: "isAuthorized")
            defaults.synchronize()
        }
    }
    
    init() {
        NSKeyedUnarchiver.setClass(Car.self, forClassName: "Car")
        if let data = defaults.object(forKey: "cars") as? Data, let array = NSKeyedUnarchiver.unarchiveObject(with: data) {
            cars = array as! [Car]
        } else {
            cars = [Car(name: "bmw"), Car(name: "audi")]
            saveCars()
        }
        
        isAuthorized = defaults.bool(forKey: "isAuthorized")
    }
    
    func setStatus(locked: Bool, for carName: String) {
        cars.first { $0.name == carName }?.locked = locked
        saveCars()
    }
    
    func saveCars() {
        NSKeyedArchiver.setClassName("Car", for: Car.self)
        defaults.set(try! NSKeyedArchiver.archivedData(withRootObject: cars, requiringSecureCoding: false), forKey: "cars")
        defaults.synchronize()
    }
}
