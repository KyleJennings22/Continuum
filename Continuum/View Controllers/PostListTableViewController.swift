//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Kyle Jennings on 12/10/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, UISearchBarDelegate {
  
  // MARK: - Outlets
  @IBOutlet weak var searchBar: UISearchBar!
  
  // MARK: - Properties
  var resultsArray: [Post] = []
  var isSearching = false
  var dataSource: [Post] {
    return isSearching ? resultsArray : PostController.shared.posts
  }
  
  // MARK: - Lifecycle Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    fetchPosts()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    resultsArray = PostController.shared.posts
    fetchPosts()
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return dataSource.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
    
    let post = dataSource[indexPath.row]
    cell.post = post
    
    return cell
  }
  
  // MARK: - Search Bar Delegate Functions
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if !searchText.isEmpty {
      let posts = PostController.shared.posts.filter {$0.matches(searchTerm: searchText)}
      resultsArray = posts
      tableView.reloadData()
    } else {
      resultsArray = PostController.shared.posts
      tableView.reloadData()
    }
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    resultsArray = PostController.shared.posts
    tableView.reloadData()
  }
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    isSearching = true
  }
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    isSearching = false
  }
  
  // MARK: Custom Functions
  func fetchPosts() {
    PostController.shared.fetchPosts { (posts) in
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
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
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPostDetail" {
      guard let destinationVC = segue.destination as? PostDetailTableViewController,
        let indexPath = tableView.indexPathForSelectedRow
        else {return}
      destinationVC.postLanding = PostController.shared.posts[indexPath.row]
    }
  }
  
  
}
