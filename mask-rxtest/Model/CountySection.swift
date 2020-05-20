//
//  CountySection.swift
//  mask-rxtest
//
//  Created by Steven Zeng on 2020/5/21.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import RxDataSources

struct CountySection {
  let header: String
  var items: [County]
}

extension CountySection: SectionModelType {
  init(original: CountySection, items: [County]) {
    self = original
    self.items = items
  }
}
