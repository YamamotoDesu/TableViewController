# TableViewController  
## Preview  
<table border="0">
    <tr>
        <tr>
            <th>Home</th>
            <th>Detail</th>
        </tr>
        <td><img src="https://user-images.githubusercontent.com/47273077/131290794-1a7b931d-8248-4c95-aa30-28aada59f2d6.png" width="300"></td>
        <td><img src="https://user-images.githubusercontent.com/47273077/131290810-1f712584-e144-44e8-a378-c80cc9c00e01.png" width="300"></td>
    </tr>
</table>

### Storyboard   
<img src="https://user-images.githubusercontent.com/47273077/131291000-38aac9af-971e-4c2e-85bb-dc5b3f0b6381.png" width="900" height="600">

### TableViewController   
**[LibarayViewController](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/LibarayViewController.swift)**    
```swift  
class LibarayViewController: UITableViewController {

    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("Nothing selected")
        }
        
        let book = Library.books[indexPath.row]
        return DetailViewController(coder: coder, book: book)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK:- Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Library.books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        let book = Library.books[indexPath.row]
        cell.textLabel?.text = book.title
        cell.imageView?.image = book.image
        return cell
    }

}

```  

### ViewController   
**[DetailViewController](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/DetailViewController.swift)**    
```swift  
class DetailViewController: UIViewController {
    let book: Book
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = book.image
        titleLabel.text = book.title
        authorLabel.text = book.author
    }
    
    required init?(coder: NSCoder) {
        fatalError("This should never be called!")
    }
    
    init?(coder: NSCoder, book: Book) {
        self.book = book
        super.init(coder: coder)
    }
}

extension DetailViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        imageView.image = selectedImage
        Library.saveImage(selectedImage, forBook: book)
        dismiss(animated: true)
    }
}

extension DetailViewController: UINavigationControllerDelegate {
    @IBAction func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
}

```

### Enum
**[LibrarySymbol & Library](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/LibrarySymbol.swift)**    
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
