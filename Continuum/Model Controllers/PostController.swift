//
//  PostController.swift
//  Continuum
//
//  Created by Kyle Jennings on 12/10/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UIKit.UIImage
import CloudKit
class PostController {
  static let shared = PostController()
  var posts: [Post] = []
  let publicDB = CKContainer.default().publicCloudDatabase
  
  func addComment(text: String, post: Post, completion: @escaping (Bool) -> Void) {
    let comment = Comment(text: text, post: post)
    let record = CKRecord(comment: comment)
    post.commentCount += 1
    let recordToSave = CKRecord(post: post)
    
    publicDB.save(record) { (record, error) in
      if let error = error {
        print("Error saving comment:", error.localizedDescription)
        return completion(false)
      }
      guard record != nil
        else {return completion(false)}
      //return completion(true)
    }
    
    let operation = CKModifyRecordsOperation(recordsToSave: [recordToSave])
    operation.savePolicy = .changedKeys
    operation.qualityOfService = .userInteractive
    operation.modifyRecordsCompletionBlock = { (records, _, error) in
      if let error = error {
        print(error.localizedDescription)
        return completion(false)
      }
      guard records?.first != nil else {return completion(false)}
      return completion(true)
    }
    
    
  }
  
  func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void) {
    let post = Post(photo: image, caption: caption, comments: [], commentCount: 0)
    let record = CKRecord(post: post)
    publicDB.save(record) { (record, error) in
      if let error = error {
        print("Error saving post:", error.localizedDescription)
        return completion(nil)
      }
      guard let record = record,
      let newPost = Post(ckRecord: record)
        else {return completion(nil)}
      
      self.posts.insert(newPost, at: 0)
      return completion(post)
    }
  }
  
  func fetchPosts(completion: @escaping ([Post]?) -> Void) {
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: PostStrings.recordTypeKey, predicate: predicate)
    publicDB.perform(query, inZoneWith: nil) { (records, error) in
      if let error = error {
        print("Error fetching posts:", error.localizedDescription)
        return completion(nil)
      }
      guard let records = records else {return completion(nil)}
      let fetchedRecords = records.compactMap {Post(ckRecord: $0)}
      self.posts = fetchedRecords
      return completion(fetchedRecords)
    }
  }
  
  func fetchComments(for post: Post, completion: @escaping ([Comment]?) -> Void) {
    let predicate = NSPredicate(format: "%K == %@", CommentStrings.postReferenceKey, post.recordID)
    let commentIDs = post.comments.compactMap {$0.recordID}
    let predicate2 = NSPredicate(format: "NOT(recordID in %@)",commentIDs)
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
    let query = CKQuery(recordType: CommentStrings.recordTypeKey, predicate: compoundPredicate)
    publicDB.perform(query, inZoneWith: nil) { (records, error) in
      if let error = error {
        print("Error fetching comments for post:", error.localizedDescription)
        return completion(nil)
      }
      guard let records = records else {return completion(nil)}
      let commentsArray = records.compactMap {Comment(ckRecord: $0, post: post)}
      return completion(commentsArray)
    }
  }
}
