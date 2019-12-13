//
//  Post.swift
//  Continuum
//
//  Created by Kyle Jennings on 12/10/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UIKit.UIImage
import CloudKit

class Post: SearchableRecord {
  var photoData: Data?
  let timestamp: Date
  let caption: String
  var comments: [Comment]
  var commentCount: Int
  var photo: UIImage? {
    get {
      guard let photoData = photoData, let image = UIImage(data: photoData) else {return nil}
      return image
    }
    set {
      guard let data = newValue?.jpegData(compressionQuality: 0.5) else {return}
      photoData = data
    }
  }
  
  // CloudKit
  let recordID: CKRecord.ID
  var imageAsset: CKAsset? {
    get {
      let tempDirectory = NSTemporaryDirectory()
      let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
      let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
      do {
        try photoData?.write(to: fileURL)
      } catch {
        print("Error writing to temporary url with error: \(error.localizedDescription)")
      }
      return CKAsset(fileURL: fileURL)
    }
  }
  
  init(photo: UIImage?, timestamp: Date = Date(), caption: String, comments: [Comment], commentCount: Int, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
    self.timestamp = timestamp
    self.caption = caption
    self.comments = comments
    self.commentCount = commentCount
    self.recordID = recordID
    self.photo = photo
  }
  
  func matches(searchTerm: String) -> Bool {
    let comments = self.comments.compactMap {$0.text.uppercased()}.joined(separator: "")
    if caption.uppercased().contains(searchTerm.uppercased()) || comments.contains(searchTerm.uppercased()){
      return true
    } else {
      return false
    }
  }
}

extension Post {
  convenience init?(ckRecord: CKRecord) {
    guard let timestamp = ckRecord[PostStrings.timestampKey] as? Date,
      let caption = ckRecord[PostStrings.captionKey] as? String,
      let commentCount = ckRecord[PostStrings.commentCountKey] as? Int
      else {return nil}
    var foundPhoto: UIImage?
    if let photoAsset = ckRecord[PostStrings.photoAssetKey] as? CKAsset {
      do {
        guard let url = photoAsset.fileURL else {return nil}
        let data = try Data(contentsOf: url)
        foundPhoto = UIImage(data: data)
      } catch {
        print("Could not transform data")
      }
    }
    self.init(photo: foundPhoto, timestamp: timestamp, caption: caption, comments: [], commentCount: commentCount, recordID: ckRecord.recordID)
  }
}

extension CKRecord {
  convenience init(post: Post) {
    self.init(recordType: PostStrings.recordTypeKey, recordID: post.recordID)
    setValue(post.caption, forKey: PostStrings.captionKey)
    setValue(post.timestamp, forKey: PostStrings.timestampKey)
    setValue(post.commentCount, forKey: PostStrings.commentCountKey)
    setValue(post.imageAsset, forKey: PostStrings.photoAssetKey)
  }
}

enum PostStrings {
  static let recordTypeKey = "Post"
  fileprivate static let captionKey = "caption"
  fileprivate static let timestampKey = "timestamp"
  fileprivate static let photoAssetKey = "imageAsset"
  fileprivate static let commentCountKey = "commentCount"
}
