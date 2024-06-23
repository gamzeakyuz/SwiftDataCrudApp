//
//  ViewController.swift
//  SwiftDataCrudApp
//
//  Created by Gamze Akyüz on 23.06.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var libraryData = LibraryData()
    var selectedBook: Book?



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view1.layer.cornerRadius = 10.0
        view2.layer.cornerRadius = 10.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let author = authorTextField.text, !author.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }
        
        if let book = selectedBook {
            libraryData.updateBook(book: book, title: title, author: author)
        } else {
            libraryData.addBook(title: title, author: author)
        }
        
        tableView.reloadData()
        clearForm()
    }
        
    private func clearForm() {
        titleTextField.text = ""
        authorTextField.text = ""
        selectedBook = nil
        saveButton.setTitle("Add", for: .normal)
    }

    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }


}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    @objc func refreshTable() {
        // Veri yenileme işlemleri burada yapılır.
        tableView.refreshControl?.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryData.books.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let book = libraryData.books[indexPath.row]
        cell.textLabel?.text = "\(book.title)"
        cell.detailTextLabel?.text = "\(book.author) - \(formattedDate(date: book.dateAdded))"
        cell.detailTextLabel?.textColor = UIColor.magenta
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBook = libraryData.books[indexPath.row]
        titleTextField.text = selectedBook?.title
        authorTextField.text = selectedBook?.author
        saveButton.setTitle("Update", for: .normal)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List of Books Read"
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bookToDelete = libraryData.books[indexPath.row]
            let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete the book \(bookToDelete.title)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                self.libraryData.deleteBook(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }



}



