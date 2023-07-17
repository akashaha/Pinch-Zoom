//
//  PageModel.swift
//  Pinch App
//
//  Created by Arman Akash on 1/22/22.
//

import Foundation
struct Page: Identifiable {
  let id: Int
  let imageName: String
}

extension Page {
  var thumbnailName: String {
    return "thumb-" + imageName
  }
}
