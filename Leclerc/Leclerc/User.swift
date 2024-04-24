//
//  User.swift
//  LeclercCore
//
//  Created by Sofía Jimémez Martínez on 24/04/24.
//

import Foundation

public struct User {
    var id: String
    var name: String
    var phone: String
    var feeds: UserFeeds!
    var medals: [Activity]!
    var quests: [Activity]!
    var eventos: [Activity]!
}

struct UserFeeds {
    var feeds_visites: [Feed]
    var my_feed: Feed
}

