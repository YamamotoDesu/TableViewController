//
//  RegisterTableViewController.swift
//  ReadMe
//
//  Created by 山本響 on 2021/08/30.
//

import UIKit

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
