//
//  Target.swift
//  mask-rxtest
//
//  Created by Steven Zeng on 2020/5/20.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import Moya

enum Service {
  case fetchFeatureData
}

extension Service: TargetType {
  var baseURL: URL {
    return URL(string: "https://raw.githubusercontent.com/kiang/pharmacies/master/json")!
  }

  var path: String {
    switch self {
    case .fetchFeatureData:
      return "/points.json"
    }
  }

  var method: Method {
    switch self {
    case .fetchFeatureData:
      return .get
    }
  }

  var sampleData: Data {
    switch self {
    case .fetchFeatureData:
      return Data()
    }
  }

  var task: Task {
    switch self {
    case .fetchFeatureData:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }


}
