//
//  Group.swift
//  iHustle
//
//  Created by Paul Hudson on 23/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

class Group: Codable, Hashable {
    
    static let openActivityType = "com.timmikelj.iHustle.openGroup"
    
    let id: String
    var name: String { didSet { DataController.shared.didUpdate() } }
    var goals: [Goal]
    var created: Date

    init(name: String, goals: [Goal], created: Date) {
        self.id = UUID().uuidString
        self.name = name
        self.goals = goals
        self.created = created
    }
    
    var userActivity: NSUserActivity {
        let userActivity = NSUserActivity(activityType: Self.openActivityType)
        userActivity.title = name
        userActivity.userInfo = ["id": id]
        return userActivity
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }

    func goal(with identifier: String) -> Goal? {
        for goal in goals {
            if goal.id == identifier {
                return goal
            }
        }

        return nil
    }
}
