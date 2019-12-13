//
//  PhotoSelectorViewController.swift
//  Continuum
//
//  Created by Kyle Jennings on 12/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

protocol PhotoSelectorViewControllerDelegate: class {
  func photoSelectorViewControllerSelected(image: UIImage)
}

class PhotoSelectorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // MARK: - Outlets
  @IBOutlet weak var selectImageButton: UIButton!
  @IBOutlet weak var photoImageView: UIImageView!
  
  // MARK: - Properties
  let imagePicker = UIImagePickerController()
  weak var delegate: PhotoSelectorViewControllerDelegate?
  
  // MARK: - Lifecycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    selectImageButton.setTitle("SelectImage", for: .normal)
    photoImageView.image = nil
  }
  
  // MARK: - Actions
  @IBAction func selectImageButtonTapped(_ sender: UIButton) {
    imagePickerAlert()
  }
  
  func imagePickerAlert() {
    selectImageButton.setTitle("", for: .normal)
    let alertController = UIAlertController(title: "Select an image", message: nil, preferredStyle: .actionSheet)
    let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
      self.imagePicker.sourceType = .camera
      self.present(self.imagePicker, animated: true, completion: nil)
    }
    let selectPhotoAction = UIAlertAction(title: "Select Photo", style: .default) { (_) in
      self.imagePicker.sourceType = .photoLibrary
      self.present(self.imagePicker, animated: true, completion: nil)
    }
    alertController.addAction(takePhotoAction)
    alertController.addAction(selectPhotoAction)
    
    imagePicker.allowsEditing = false
    imagePicker.mediaTypes = ["public.image"]
    
    present(alertController, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      delegate?.photoSelectorViewControllerSelected(image: pickedImage)
      photoImageView.image = pickedImage
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
