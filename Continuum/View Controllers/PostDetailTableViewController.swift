//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Kyle Jennings on 12/10/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var photoImageView: UIImageView!
  
  // MARK: - Properties
  var postLanding: Post? {
    didSet {
      updateViews()
    }
  }
  
  var commentsArray: [Comment] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let post = postLanding else {return}
    PostController.shared.fetchComments(for: post) { (comments) in
      if let comments = comments {
        self.commentsArray = comments
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  // MARK: - Actions
  @IBAction func commentButtonClicked(_ sender: UIButton) {
    createCommentAlert()
  }
  
  @IBAction func shareButtonCicked(_ sender: UIButton) {
    shareAction()
  }
  @IBAction func followPostButtonTapped(_ sender: UIButton) {
  }
  
  // MARK: - Table view data source
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return commentsArray.count
    
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
    
    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.lineBreakMode = .byWordWrapping
    
    let comment = commentsArray[indexPath.row]
    cell.textLabel?.text = comment.text
    cell.detailTextLabel?.text = Date.formattedString(comment.timestamp)()
    
    return cell
  }
  
  // MARK: - Custom Functions
  func updateViews() {
    guard let post = postLanding,
      let image = post.photo
      else {return}
    DispatchQueue.main.async {
      self.photoImageView.image = image
      self.tableView.reloadData()
    }
    
  }
  
  func createCommentAlert() {
    let alertController = UIAlertController(title: "Comment", message: "Enter a comment", preferredStyle: .alert)
    alertController.addTextField { (textField) in
      textField.placeholder = "Enter a comment"
    }
    let addComment = UIAlertAction(title: "Add", style: .default) { (_) in
      guard let post = self.postLanding,
        let text = alertController.textFields?.first?.text,
        !text.isEmpty
        else {return}
      print("derp")
      PostController.shared.addComment(text: text, post: post) { (comment) in
        
        //self.postLanding?.comments.append(comment)
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(addComment)
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true)
  }
  
  func shareAction() {
    guard let image = postLanding?.photo,
      let caption = postLanding?.caption
      else {return}
    let shareActivity = UIActivityViewController(activityItems: [image, caption], applicationActivities: nil)
    present(shareActivity, animated: true)
  }
  
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
