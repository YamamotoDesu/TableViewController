# TableViewController  
## Preview  
<table border="0">
    <tr>
        <tr>
            <th>Preview</th>
            <th>Home</th>
            <th>Detail</th>
            <th>Register</th>
        </tr>
        <td><img src="https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/gif/Complete.gif" width="300"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/132089689-a47cfba8-e8af-4ea2-b0de-1d6ac9e78ffe.png" width="300"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131757681-91b14c3d-2858-4d3f-be7d-44eec5cd5787.png" width="300"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131757740-1b7d83ab-5784-4086-9e64-56b2bebc3e55.png" width="300"></td>
    </tr>
</table>

## Functionality  
### Custom TextField  
<table border="0">
    <tr>
        <tr>
            <th>Preview</th>
            <th>Storyboard</th>
            <th>Set Delegate</th>
        </tr>
        <td><img src="https://user-images.githubusercontent.com/47273077/131759017-d563d523-235e-4414-99b9-a91bdf09dbca.png" width="200"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131759521-5074dd2b-fb7b-41f0-aaa1-cbc4621ddf1c.png" width="500" height="300"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131760195-f83527ae-b42a-492c-98bf-96985d9792e0.png" width="800" height="200"></td>
    </tr>
</table>  

```swift  
extension NewBookTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            return authorextField.becomeFirstResponder()
        } else {
            return textField.resignFirstResponder()
        }
    }
}
```   

### Toolbar  && Sort  
<table border="0">
    <tr>
        <tr>
            <th>Sort</th>
            <th>Storyboard</th>
        </tr>
        <td><img src="https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/gif/Sort.gif" width="300"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/132090832-426dd54f-d975-4557-acb5-0ad119f9461b.png" height="500" width="700"></td>
    </tr>
</table>  

```swift 
enum SortStyle {
    case title
    case author
    case readme
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
```  


### Delete Item
<table border="0">
    <tr>
        <tr>
            <th>Sort</th>
        </tr>
        <td><img src="https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/gif/Delete.gif" width="300"></td>
    </tr>
</table>  

```swift 

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
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
```  

### Move Item
<table border="0">
    <tr>
        <tr>
            <th>Move Item</th>
        </tr>
        <td><img src="https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/gif/Move.gif" width="300"></td>
    </tr>
</table>  

```swift 

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
    
 static func reorderBooks(bookToMove: Book, bookAtDestination: Book) {
    let destinationIndex = Library.books.firstIndex(of: bookAtDestination) ?? 0
    books.removeAll(where: { $0.title == bookToMove.title })
    books.insert(bookToMove, at: destinationIndex)
    saveAllBooks()
  }
```  

### Keyboard Toolbar
<table border="0">
    <tr>
        <tr>
            <th>Preview</th>
        </tr>
        <td><img src="https://user-images.githubusercontent.com/47273077/131838427-21b52c1c-abfd-4c78-8906-2d39c57480ee.png" width="200"></td>
    </tr>
</table>  


```swift  

class DetailTableViewController: UITableViewController {

    @IBOutlet var reviewTextview: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextview.addDoneButton()
    }

}
extension UITextView {
    func addDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
        
    }
}
```   

### UIImagePickerController
<table border="0">
    <tr>
        <tr>
            <th>Preview</th>
        </tr>
        <td><img src="https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/gif/UIImagePickerController.gif" width="200"></td>
    </tr>
</table>  

```swift 

class DetailTableViewController: UITableViewController {

    @IBAction func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
}

extension DetailTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        imageView.image = selectedImage
        Library.saveImage(selectedImage, forBook: book)
        dismiss(animated: true)
    }
}


```  

### Appearance  
<table border="0">
    <tr>
        <tr>
            <th>Light</th>
            <th>Light</th>
            <th>Dark</th>
            <th>Dark</th>
        </tr>
        <td><img src="https://user-images.githubusercontent.com/47273077/131845712-1562f391-056e-4ada-92f7-6980303bdd6d.png" width="200"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131845965-53abfc0c-6fa0-4d6e-8a15-b7974b63313c.png" width="200"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131844840-e041350f-261b-46c5-a35e-20be43e042f9.png" width="200"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131844572-b4084744-cb67-41ba-8238-817ce6819a50.png" width="200"></td>
    </tr>
</table>  
<table border="0">
    <tr>
        <tr>
            <th>Assets</th>
            <th>Global Tint</th>
        </tr>
        <td><img src="https://user-images.githubusercontent.com/47273077/131848293-b0b18aa1-716f-468b-8f6c-0693b193a6c1.png" width="500"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131848069-8b53ad43-3543-4934-acae-6d6347fbdbd3.png" width="500"></td>
    </tr>
</table> 

### Set Custom SectionView  
<table border="0">
    <tr>
        <tr>
            <th>Set Size</th>
            <th>Set Class</th>
        </tr>
        <td><img src="https://user-images.githubusercontent.com/47273077/131848907-17174bcf-f6ae-4dff-934d-1387a0e54647.png" width="500"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131850121-0d4c473d-b64f-4b91-959b-cf84eead5a28.png" width="500"></td>
    </tr>
</table> 

```swift  
class LibraryHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "\(LibraryHeaderView.self)"
    @IBOutlet var titleLabel: UILabel!
}


class LibrayTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "\(LibraryHeaderView.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseIdentifier)
    }

}
```

## Overview    
### Storyboard   
<img src="https://user-images.githubusercontent.com/47273077/132089569-dcdf9b1a-99ad-44be-a5f9-d966c7cc3eae.png" width="900" height="600">  

### Xib  
<img src="https://user-images.githubusercontent.com/47273077/131757926-01ff7337-c30e-452e-9359-fa86918ab848.png" width="500" height="300">  



### TableViewController   
**[LibarayViewController](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/LibarayViewController.swift)**    
```swift  
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


```  

### ViewController   
**[NewBookTableViewController](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/NewBookTableViewController.swift)**    
```swift  
import UIKit

class NewBookTableViewController: UITableViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var authorextField: UITextField!
    @IBOutlet var bookImageView: UIImageView!
    
    var newBookImage: UIImage?
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveNewBook() {
        guard let title = titleTextField.text,
              let author = authorextField.text,
              !title.isEmpty,
              !author.isEmpty else { return }
        
        Library.addNew(book: Book(title: title, author: author, readMe: true, image: newBookImage))
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookImageView.layer.cornerRadius = 16
    }
}

extension NewBookTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        bookImageView.image = selectedImage
        newBookImage = selectedImage
        dismiss(animated: true)
    }
}

extension NewBookTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            return authorextField.becomeFirstResponder()
        } else {
            return textField.resignFirstResponder()
        }
    }
}

```

### ViewController   
**[DetailViewController](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/DetailViewController.swift)**    
```swift  
import UIKit

class DetailTableViewController: UITableViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var reviewTextview: UITextView!
    
    var book: Book
    
    @IBOutlet var readMeButton: UIButton!
    
    @IBAction func toggleReadMe() {
        book.readMe.toggle()
        let image = book.readMe
          ? LibrarySymbol.bookmarkFill.image
          : LibrarySymbol.bookmark.image
        readMeButton.setImage(image, for: .normal)
    }
    
    @IBAction func saveChanges() {
        Library.update(book: book)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = book.image ?? LibrarySymbol.letterSquare(letter: book.title.first).image
        imageView.layer.cornerRadius = 60
        titleLabel.text = book.title
        authorLabel.text = book.author
        
        if let review = book.review {
            reviewTextview.text = review
        }
        
        let image = book.readMe
          ? LibrarySymbol.bookmarkFill.image
          : LibrarySymbol.bookmark.image
        readMeButton.setImage(image, for: .normal)
        
        reviewTextview.addDoneButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("This should never be called!")
    }
    
    init?(coder: NSCoder, book: Book) {
        self.book = book
        super.init(coder: coder)
    }
}

extension DetailTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        imageView.image = selectedImage
        book.image = selectedImage
        dismiss(animated: true)
    }
}

extension DetailTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        book.review = textView.text
        textView.resignFirstResponder()
    }
}

extension UITextView {
    func addDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
        
    }
}

```  

### Cell
**[BookCell](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/BookCell.swift)**    
```swift 
import UIKit

class BookCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    
    @IBOutlet var readMeBookmark: UIImageView!
    @IBOutlet var bookThumbnail: UIImageView!
    
}



```

### Enum
**[LibrarySymbol & Library](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/Library.swift)**    
```swift  
import UIKit

// MARK:- Reusable SFSymbol Images
enum LibrarySymbol {
  case bookmark
  case bookmarkFill
  case book
  case letterSquare(letter: Character?)
  
  var image: UIImage {
    let imageName: String
    switch self {
    case .bookmark, .book:
      imageName = "\(self)"
    case .bookmarkFill:
      imageName = "bookmark.fill"
    case .letterSquare(let letter):
      guard let letter = letter?.lowercased(),
      let image = UIImage(systemName: "\(letter).square")
        else {
          imageName = "square"
          break
      }
      return image
    }
    return UIImage(systemName: imageName)!
  }
}

// MARK:- Library
enum Library {
  private static let starterData = [
    Book(title: "Ein Neues Land", author: "Shaun Tan", readMe: true),
    Book(title: "Bosch", author: "Laurinda Dixon", readMe: true),
    Book(title: "Dare to Lead", author: "Brené Brown", readMe: false),
    Book(title: "Blasting for Optimum Health Recipe Book", author: "NutriBullet", readMe:  false),
    Book(title: "Drinking with the Saints", author: "Michael P. Foley", readMe: true),
    Book(title: "A Guide to Tea", author: "Adagio Teas", readMe: false),
    Book(title: "The Life and Complete Work of Francisco Goya", author: "P. Gassier & J Wilson", readMe: true),
    Book(title: "Lady Cottington's Pressed Fairy Book", author: "Lady Cottington", readMe: false),
    Book(title: "How to Draw Cats", author: "Janet Rancan", readMe: true),
    Book(title: "Drawing People", author: "Barbara Bradley", readMe: false),
    Book(title: "What to Say When You Talk to Yourself", author: "Shad Helmstetter", readMe: true)
  ]
  
  static var books: [Book] = loadBooks()
  
  private static let booksJSONURL = URL(fileURLWithPath: "Books",
                                relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("json")
  
  
  /// This method loads all existing data from the `booksJSONURL`, if available. If not, it will fall back to using `starterData`
  /// - Returns: Returns an array of books, loaded from a JSON file
  private static func loadBooks() -> [Book] {
      let decoder = JSONDecoder()

      guard let booksData = try? Data(contentsOf: booksJSONURL) else {
        return starterData
      }

      do {
        let books = try decoder.decode([Book].self, from: booksData)
        return books.map { libraryBook in
          Book(
            title: libraryBook.title,
            author: libraryBook.author,
            review: libraryBook.review,
            readMe: libraryBook.readMe,
            image: loadImage(forBook: libraryBook)
          )
        }
        
      } catch let error {
        print(error)
        return starterData
      }
  }
  
  private static func saveAllBooks() {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
      let booksData = try encoder.encode(books)
      try booksData.write(to: booksJSONURL, options: .atomicWrite)
    } catch let error {
      print(error)
    }
  }
  
  /// Adds a new book to the `books` array and saves it to disk.
  /// - Parameters:
  ///   - book: The book to be added to the library.
  ///   - image: An optional image to associate with the book.
  static func addNew(book: Book) {
    if let image = book.image { saveImage(image, forBook: book) }
    books.insert(book, at: 0)
    saveAllBooks()
  }
  
  
  /// Updates the stored value for a single book.
  /// - Parameter book: The book to be updated.
  static func update(book: Book) {
    if let newImage = book.image {
      saveImage(newImage, forBook: book)
    }
    
    guard let bookIndex = books.firstIndex(where: { storedBook in
      book.title == storedBook.title } )
    else {
        print("No book to update")
        return
    }
    
    books[bookIndex] = book
    saveAllBooks()
  }
  
  /// Removes a book from the `books` array.
  /// - Parameter book: The book to be deleted from the library.
  static func delete(book: Book) {
    guard let bookIndex = books.firstIndex(where: { storedBook in
      book == storedBook } )
      else { return }
  
    books.remove(at: bookIndex)
    
    let imageURL = FileManager.documentDirectoryURL.appendingPathComponent(book.title)
    do {
      try FileManager().removeItem(at: imageURL)
    } catch let error { print(error) }
    
    saveAllBooks()
  }
  
  static func reorderBooks(bookToMove: Book, bookAtDestination: Book) {
    let destinationIndex = Library.books.firstIndex(of: bookAtDestination) ?? 0
    books.removeAll(where: { $0.title == bookToMove.title })
    books.insert(bookToMove, at: destinationIndex)
    saveAllBooks()
  }
  
  /// Saves an image associated with a given book title.
  /// - Parameters:
  ///   - image: The image to be saved.
  ///   - title: The title of the book associated with the image.
  static func saveImage(_ image: UIImage, forBook book: Book) {
    let imageURL = FileManager.documentDirectoryURL.appendingPathComponent(book.title)
    if let jpgData = image.jpegData(compressionQuality: 0.7) {
      try? jpgData.write(to: imageURL, options: .atomicWrite)
    }
  }
  
  /// Loads and returns an image for a given book title.
  /// - Parameter title: Title of the book you need an image for.
  /// - Returns: The image associated with the given book title.
  static func loadImage(forBook book: Book) -> UIImage? {
    let imageURL = FileManager.documentDirectoryURL.appendingPathComponent(book.title)
    return UIImage(contentsOfFile: imageURL.path)
  }
}

extension FileManager {
  static var documentDirectoryURL: URL {
    return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}



```  

### Model
**[Book](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/Book.swift)**    
```swift  

import UIKit

struct Book: Hashable {
    let title: String
    let author: String
    var review: String?
    var readMe: Bool
    
    var image: UIImage?
    
    static let mockBook = Book(title: "", author: "", readMe: true)
}

extension Book: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case review
        case readMe
    }
}

```   
