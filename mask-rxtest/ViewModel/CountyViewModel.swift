//
//  CountyViewModel.swift
//  mask-rxtest
//
//  Created by Steven Zeng on 2020/5/19.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa

class CountyViewModel: ViewModelType {

  struct Input {
    let refreshSignal: Signal<Void>
    let provider: MoyaProvider<Service>
  }

  struct Output {
    let isLoading: Driver<Bool>
    let countiesRelay: BehaviorRelay<[County]>
  }

  let disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let activityIndicator = ActivityIndicator()
    let countiesRelay = BehaviorRelay<[County]>(value: [])

    let featureData = input.refreshSignal.asObservable()
      .flatMapLatest {
        input.provider.rx.request(.fetchFeatureData)
          .filterSuccessfulStatusCodes()
          .map([FeatureData].self, atKeyPath: "features")
          .trackActivity(activityIndicator)
    }

    let pharmacies = featureData.map { $0.map { $0.properties } }

    pharmacies.map { Dictionary(grouping: $0, by: { $0.county }) }
      .map { $0.map { key, value -> County in
        let adultMaskCount = value.reduce(0, { $0 + $1.adultMaskCount })
        let childMaskCount = value.reduce(0, { $0 + $1.childMaskCount })
        return County(name: key, adultMaskCount: adultMaskCount, childMaskCount: childMaskCount, pharmacies: value)
        }}.map { $0.sorted { (lhs, rhs) -> Bool in
          lhs.adultMaskCount > rhs.adultMaskCount
        }}.bind(to: countiesRelay).disposed(by: disposeBag)

    return Output(isLoading: activityIndicator.asDriver(), countiesRelay: countiesRelay)
  }
}
