//
//  Goal.swift
//  iHustle
//
//  Created by Paul Hudson on 23/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

enum Priority: String, Codable {
    case low
    case medium
    case high
}

class Goal: Codable, Hashable {
    
    static let openActivityType = "com.timmikelj.iHustle.openGoal"
    
    var id: String
    var name: String { didSet { DataController.shared.didUpdate() } }
    var priority: Priority { didSet { DataController.shared.didUpdate() } }
    var isCompleted: Bool { didSet { DataController.shared.didUpdate() } }
    
    var userActivity: NSUserActivity {
        let userActivity = NSUserActivity(activityType: Self.openActivityType)
        userActivity.title = name
        userActivity.userInfo = ["id": id]
        return userActivity
    }

    init(name: String, priority: Priority, isCompleted: Bool) {
        self.id = UUID().uuidString
        self.name = name
        self.priority = priority
        self.isCompleted = isCompleted
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Goal, rhs: Goal) -> Bool {
        return lhs.id == rhs.id
    }
}
