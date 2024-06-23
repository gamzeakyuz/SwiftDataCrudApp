//
//  LibraryData.swift
//  SwiftDataCrudApp
//
//  Created by Gamze Akyüz on 23.06.2024.
//

import Foundation

class LibraryData: ObservableObject {
    
    var books: [Book] = []
    
    func addBook(title: String, author: String) {
        let newBook = Book(title: title, author: author, dateAdded: Date())
        books.append(newBook)
    }
    
    func deleteBook(at index: Int) {
        books.remove(at: index)
    }
    
    func updateBook(book: Book, title: String, author: String) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].title = title
            books[index].author = author
        }
    }
}
