//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Kyle Jennings on 12/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

protocol SearchableRecord {
  func matches(searchTerm: String) -> Bool
}
