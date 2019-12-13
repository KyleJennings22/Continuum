//
//  Comment.swift
//  Continuum
//
//  Created by Kyle Jennings on 12/10/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit

class Comment: SearchableRecord {
  var text: String
  var timestamp: Date
  weak var post: Post?
  
  // Cloudkit
  var recordID: CKRecord.ID
  var postReference: CKRecord.Reference? {
    guard let post = post else {return nil}
    return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
  }
  
  init(text: String, timestamp: Date = Date(), post: Post?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
    self.text = text
    self.timestamp = timestamp
    self.post = post
    self.recordID = recordID
  }
  
  func matches(searchTerm: String) -> Bool {
    if text.uppercased().contains(searchTerm.uppercased()) {
      return true
    } else {
      return false
    }
  }
}

extension Comment {
  convenience init?(ckRecord: CKRecord, post: Post) {
    guard let text = ckRecord[CommentStrings.textKey] as? String,
      let timestamp = ckRecord[CommentStrings.timestampKey] as? Date
      else {return nil}
    
    self.init(text: text, timestamp: timestamp, post: post, recordID: ckRecord.recordID)
  }
}

extension CKRecord {
  convenience init(comment: Comment) {
    self.init(recordType: CommentStrings.recordTypeKey, recordID: comment.recordID)
    setValue(comment.text, forKey: CommentStrings.textKey)
    setValue(comment.timestamp, forKey: CommentStrings.timestampKey)
    setValue(comment.postReference, forKey: CommentStrings.postReferenceKey)
  }
}

enum CommentStrings {
  static let recordTypeKey = "Comment"
  fileprivate static let textKey = "text"
  fileprivate static let timestampKey = "timestamp"
  static let postReferenceKey = "postReference"
}
