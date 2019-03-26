//
//  IntentHandler.swift
//  CarIntentsExtension
//
//  Created by Леонид Лядвейкин on 26/03/2019.
//  Copyright © 2019 Леонид Лядвейкин. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INGetCarLockStatusIntentHandling {
    var cars = CarsManager.shared.cars
    
    func resolveCarName(for intent: INGetCarLockStatusIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        if let car = intent.carName, let carName = intent.carName?.vocabularyIdentifier {
            if cars.first(where: { $0.name == carName }) != nil {
                completion(INSpeakableStringResolutionResult.success(with: car))
            } else {
                completion(INSpeakableStringResolutionResult.unsupported())
            }
        } else {
            completion(INSpeakableStringResolutionResult.needsValue())
        }
    }
    
    
    func handle(intent: INGetCarLockStatusIntent, completion: @escaping (INGetCarLockStatusIntentResponse) -> Void) {
        let response = INGetCarLockStatusIntentResponse(code: .success, userActivity: nil)
        if let carName = intent.carName?.vocabularyIdentifier {
            if let car = cars.first(where: { $0.name == carName }) {
               response.locked = car.locked
            }
        }
        
        completion(response)
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}

extension IntentHandler: INSetCarLockStatusIntentHandling {
    
    func resolveLocked(for intent: INSetCarLockStatusIntent, with completion: @escaping (INBooleanResolutionResult) -> Void) {
        if let locked = intent.locked {
            completion(INBooleanResolutionResult.success(with: locked))
        } else {
            completion(INBooleanResolutionResult.needsValue())
        }
    }
    
    func confirm(intent: INSetCarLockStatusIntent, completion: @escaping (INSetCarLockStatusIntentResponse) -> Void) {
        guard CarsManager.shared.isAuthorized else {
            let userActivity = NSUserActivity(activityType: "ru.hse.authorize")
            completion(INSetCarLockStatusIntentResponse(code: .failureRequiringAppLaunch, userActivity: userActivity))
            
            return
        }
        
        let response = INSetCarLockStatusIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
    
    func handle(intent: INSetCarLockStatusIntent, completion: @escaping (INSetCarLockStatusIntentResponse) -> Void) {
        CarsManager.shared.setStatus(locked: intent.locked!, for: intent.carName!.vocabularyIdentifier!)
        
        let response = INSetCarLockStatusIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
    
    
}
