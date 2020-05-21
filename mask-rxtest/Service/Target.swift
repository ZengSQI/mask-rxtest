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
      return stubbedResponse("FeatureData")
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

  func stubbedResponse(_ filename: String) -> Data! {
    let bundlePath = Bundle.main.path(forResource: "Stubs", ofType: "bundle")
    let bundle = Bundle(path: bundlePath!)
    let path = bundle?.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
  }
}
