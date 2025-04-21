////
////  Journal.swift
////  Thancho2
////
////  Created by 박지희 on 4/20/25.
////
import Foundation
import SwiftData

@Model
class Journal {
    var date: Date
    var content: String
    var imageDataArray: [Data]

    init(date: Date, content: String, imageDataArray: [Data] = []) {
        self.date = date
        self.content = content
        self.imageDataArray = imageDataArray
    }

    static var sample: Journal {
        Journal(date: Date(), content: "", imageDataArray: [])
    }
}
