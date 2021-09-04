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

enum SortStyle {
    case title
    case author
    case readme
}

enum Section: String, CaseIterable {
    case addNew
    case readMe = "Read Me!"
    case finished = "Fished"
}

class LibrayTableViewController: UITableViewController {
    
    var dataSource: LibraryDataSource!
    
    @IBOutlet var sortButtons: [UIBarButtonItem]!
    
    @IBAction func sortByTitle(_ sender: UIBarButtonItem) {
        dataSource.update(sortStyle: .title)
        updateTintColors(tappedButton: sender)
    }
    
    @IBAction func sortByAuthor(_ sender: UIBarButtonItem) {
        dataSource.update(sortStyle: .author)
        updateTintColors(tappedButton: sender)
    }
    
    @IBAction func sortByReadMe(_ sender: UIBarButtonItem) {
        dataSource.update(sortStyle: .readme)
        updateTintColors(tappedButton: sender)
    }
    
    func updateTintColors(tappedButton: UIBarButtonItem) {
        sortButtons.forEach { button in
            button.tintColor = button == tappedButton
                ? button.customView?.tintColor : .secondaryLabel
            
        }
    }
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailTableViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let book = dataSource.itemIdentifier(for: indexPath) else {
            fatalError("Nothing selected")
        }
        return DetailTableViewController(coder: coder, book: book)
    }
    
    @IBSegueAction func registerView(_ coder: NSCoder) -> NewBookTableViewController? {
        return NewBookTableViewController(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem

        tableView.register(UINib(nibName: "\(LibraryHeaderView.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseIdentifier)
        
        configureDataSource()
        dataSource.update(sortStyle: .readme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.update(sortStyle: dataSource.currentSortStyle)
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 1 ? "Read Me!" : nil
    }
    
    // MARK: - Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LibraryHeaderView.reuseIdentifier) as? LibraryHeaderView else {
            return nil
        }
        
        headerView.titleLabel.text = Section.allCases[section].rawValue
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ? 60 : 0
    }

    // MARK:- Data Source
    func configureDataSource() {
        dataSource = LibraryDataSource(tableView: tableView) { (tableView, indexPath, book) -> UITableViewCell? in
            if indexPath == IndexPath(row: 0, section: 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewBookCell", for: indexPath)
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(BookCell.self)", for: indexPath) as? BookCell else {
                fatalError("Could not create BookCell")
            }
            cell.titleLabel.text = book.title
            cell.authorLabel.text = book.author
            cell.bookThumbnail.image = book.image ?? LibrarySymbol.letterSquare(letter: book.title.first).image
            cell.bookThumbnail.layer.cornerRadius = 12
            
            if let review = book.review {
                cell.reviewLabel.text = review
                cell.reviewLabel.isHidden = false
            }
            cell.readMeBookmark.isHidden = !book.readMe
            return cell
        }
    }
    
}

class LibraryDataSource: UITableViewDiffableDataSource<Section, Book> {
    
    var currentSortStyle: SortStyle = .title
    
    func update(sortStyle: SortStyle, animatingDifferences: Bool = true) {
        currentSortStyle = sortStyle
        var newSnappshot = NSDiffableDataSourceSnapshot<Section, Book>()
        newSnappshot.appendSections(Section.allCases)
        let booksByReadMe: [Bool: [Book]] = Dictionary(grouping: Library.books, by: \.readMe)
        for (readMe, books) in booksByReadMe {
            var sortedBooks: [Book]
            switch  sortStyle {
            case .title:
                sortedBooks = books.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
            case .author:
                sortedBooks = books.sorted { $0.author.localizedCaseInsensitiveCompare($1.author) == .orderedAscending }
            case .readme:
                sortedBooks = books
            }
            newSnappshot.appendItems(sortedBooks, toSection: readMe ? .readMe : .finished)
        }
        newSnappshot.appendItems([Book.mockBook], toSection: .addNew)
        apply(newSnappshot, animatingDifferences: animatingDifferences)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section == snapshot().indexOfSection(.addNew) ? false : true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard  let book = self.itemIdentifier(for: indexPath) else {
                return
            }
            Library.delete(book: book)
            update(sortStyle: currentSortStyle)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section != snapshot().indexOfSection(.readMe)
            && currentSortStyle == .readme{
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath,
              sourceIndexPath.section == destinationIndexPath.section,
              let bookToMove = itemIdentifier(for: sourceIndexPath),
              let bookAtDestination = itemIdentifier(for: destinationIndexPath) else {
            apply(snapshot(), animatingDifferences: false)
            return
        }
        
        Library.reorderBooks(bookToMove: bookToMove, bookAtDestination: bookAtDestination)
        update(sortStyle: currentSortStyle, animatingDifferences: false)
    }
}

