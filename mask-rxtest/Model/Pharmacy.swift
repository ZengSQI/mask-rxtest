//
//  Pharmacy.swift
//  mask-rxtest
//
//  Created by Steven Zeng on 2020/5/19.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import Foundation

struct Pharmacy: Codable {
  let id: String
  let name: String
  let phone: String
  let address: String
  let adultMaskCount: Int
  let childMaskCount: Int
  let available: String
  let note: String
  let customNote: String
  let county: String
  let town: String
  let cunli: String

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case phone
    case address
    case adultMaskCount = "mask_adult"
    case childMaskCount = "mask_child"
    case available
    case note
    case customNote = "custom_note"
    case county
    case town
    case cunli
  }

  
}
