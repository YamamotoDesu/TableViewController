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

### Toolbar
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
**[NewBookTableViewController](https://github.com/YamamotoDesu/TableViewController/blob/main/ReadMe/NewBookTableViewController.swift)**    
```swift  
class NewBookTableViewController: UITableViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var authorextField: UITextField!
    @IBOutlet var bookImageView: UIImageView!
    
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
