//
//  Book.swift
//  SwiftDataCrudApp
//
//  Created by Gamze Akyüz on 23.06.2024.
//

import Foundation

struct Book: Identifiable {
    var id = UUID()
    var title: String
    var author: String
    var dateAdded: Date
}
