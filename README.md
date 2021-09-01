# TableViewController  
## Preview  
<table border="0">
    <tr>
        <tr>
            <th>Home</th>
            <th>Detail</th>
            <th>Register</th>
        </tr>
        <td><img src="https://user-images.githubusercontent.com/47273077/131757637-347c429b-5261-4ea7-90cf-cf65ee82bd2f.png" width="300"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131757681-91b14c3d-2858-4d3f-be7d-44eec5cd5787.png" width="300"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131757740-1b7d83ab-5784-4086-9e64-56b2bebc3e55.png" width="300"></td>
    </tr>
</table>

### Storyboard   
<img src="https://user-images.githubusercontent.com/47273077/131757840-7cb0ff28-a542-4061-8490-a25d82b84a93.png" width="900" height="600">  


### Xib  
<img src="https://user-images.githubusercontent.com/47273077/131757926-01ff7337-c30e-452e-9359-fa86918ab848.png" width="500" height="300">

### TableViewController   
**[LibarayViewController](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/LibarayViewController.swift)**    
```swift  
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

        tableView.register(UINib(nibName: "\(LibraryHeaderView.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: LibraryHeaderView.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        
        headerView.titleLabel.text = "Read Me!"
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ? 60 : 0
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


```  

### ViewController   
**[DetailViewController](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/DetailViewController.swift)**    
```swift  
class DetailTableViewController: UITableViewController {
    let book: Book
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var reviewTextview: UITextView!
    
    @IBAction func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = book.image
        imageView.layer.cornerRadius = 60
        titleLabel.text = book.title
        authorLabel.text = book.author
        
        if let review = book.review {
            reviewTextview.text = review
        }
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
        Library.saveImage(selectedImage, forBook: book)
        dismiss(animated: true)
    }
}

extension DetailTableViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
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
/ MARK:- Reusable SFSymbol Images
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
    static let books: [Book] = [
        Book(title: "Ein Neues Land", author: "Shaun Tan"),
        Book(title: "Bosch", author: "Laurinda Dixon"),
        Book(title: "Dare to Lead", author: "Brené Brown"),
        Book(title: "Blasting for Optimum Health Recipe Book", author: "NutriBullet"),
        Book(title: "Drinking with the Saints", author: "Michael P. Foley"),
        Book(title: "A Guide to Tea", author: "Adagio Teas"),
        Book(title: "The Life and Complete Work of Francisco Goya", author: "P. Gassier & J Wilson"),
        Book(title: "Lady Cottington's Pressed Fairy Book", author: "Lady Cottington"),
        Book(title: "How to Draw Cats", author: "Janet Rancan"),
        Book(title: "Drawing People", author: "Barbara Bradley"),
        Book(title: "What to Say When You Talk to Yourself", author: "Shad Helmstetter")
    ]
    
    static func saveImage(_ image: UIImage, forBook book: Book) {
        let imageURL = FileManager.documentDirectoryURL.appendingPathComponent(book.title)
        if let jpgData = image.jpegData(compressionQuality: 0.7) {
            try? jpgData.write(to: imageURL, options: .atomicWrite)
        }
    }
    
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

struct Book {
    let title: String
    let author: String
    var review: String?
    
    var image: UIImage {
        Library.loadImage(forBook: self) ?? LibrarySymbol.letterSquare(letter: title.first).image
    }
}


```   
