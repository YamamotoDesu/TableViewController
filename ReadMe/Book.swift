//
//  Book.swift
//  ReadMe
//
//  Created by 山本響 on 2021/08/29.
//

import UIKit

struct Book {
    let title: String
    let author: String
    var image: UIImage {
        Library.loadImage(forBook: self) ?? LibrarySymbol.letterSquare(letter: title.first).image
    }
}
