//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Kyle Jennings on 12/10/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController, PhotoSelectorViewControllerDelegate {
  
  // MARK: - Outlets

  @IBOutlet weak var captionTextField: UITextField!
  
  // MARK: - Properties
  var selectedImage: UIImage?
  
  // MARK: - Lifecycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    captionTextField.text = ""
  }
  
  // MARK: - Actions
  
  @IBAction func addPostButtonTapped(_ sender: UIButton) {
    guard let image = selectedImage,
      let caption = captionTextField.text,
      !caption.isEmpty
      else {return}
    PostController.shared.createPostWith(image: image, caption: caption) { (post) in
      
    }
    self.tabBarController?.selectedIndex = 0
  }
  @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
    self.tabBarController?.selectedIndex = 0
  }
  
  // MARK: - Photo Picker Delegate Functions
  func photoSelectorViewControllerSelected(image: UIImage) {
    selectedImage = image
  }
  
  // MARK: - Navigation Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "photoPicker" {
      guard let destinationVC = segue.destination as? PhotoSelectorViewController else {return}
      destinationVC.delegate = self
    }
  }
}
