//
//  ViewController.swift
//  ReadMe
//
//  Created by 山本響 on 2021/08/29.
//

import UIKit

class LibraryHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "\(LibraryHeaderView.self)"
    @IBOutlet var titleLabel: UILabel!
}

class LibrayTableViewController: UITableViewController {

    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailTableViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("Nothing selected")
        }
        
        let book = Library.books[indexPath.row]
        return DetailTableViewController(coder: coder, book: book)
    }
    
    @IBSegueAction func registerView(_ coder: NSCoder) -> NewBookTableViewController? {
        return NewBookTableViewController(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 1 ? "Read Me!" : nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LibraryHeaderView.reuseIdentifier) as? LibraryHeaderView else { return nil }
        headerView.titleLabel.text = "Read Me!"
        return headerView
    }
    
    
    // MARK: - Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    // MARK:- Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : Library.books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else {
            fatalError("Could not create BookCell")
        }
        let book = Library.books[indexPath.row]
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        cell.bookThumbnail.image = book.image
        cell.bookThumbnail.layer.cornerRadius = 12
        return cell
    }

}

