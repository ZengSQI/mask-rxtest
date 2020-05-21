//
//  mask_rxtestTests.swift
//  mask-rxtestTests
//
//  Created by Steven Zeng on 2020/5/19.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import Moya
@testable import mask_rxtest

class mask_rxtestTests: XCTestCase {

  let viewModel = CountyViewModel()
  var disposeBag = DisposeBag()

  var scheduler: TestScheduler!
  var output: CountyViewModel.Output!

  override func setUpWithError() throws {
    scheduler = TestScheduler(initialClock: 0)
    let refreshSignal = scheduler.createHotObservable(
      [
        .next(100, ())
      ]
    ).asSignal(onErrorSignalWith: .empty())

    let input = CountyViewModel.Input(
      refreshSignal: refreshSignal,
      provider: MoyaProvider<Service>(stubClosure: { (service) -> StubBehavior in
        return .immediate
      })
    )

    output = viewModel.transform(input: input)
  }

  func testIndicator() throws {
    let observer = scheduler.createObserver(Bool.self)

    output.isLoading.drive(observer).disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<Bool>>] = [
      .next(0, false),
      .next(100, true),
      .next(100, false),

    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }

  func testCountiesCount() throws {
    let observer = scheduler.createObserver(Int.self)

    output.countiesRelay.map { $0.count }.bind(to: observer).disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<Int>>] = [
      .next(0, 0),
      .next(100, 11),
    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }

  func testCountiesSort() throws {
    let observer = scheduler.createObserver([String].self)

    output.countiesRelay.map { $0.map { $0.name } }.bind(to: observer).disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<[String]>>] = [
      .next(0, []),
      .next(100, ["桃園市", "臺北市", "彰化縣", "雲林縣", "新北市", "基隆市", "屏東縣", "花蓮縣", "高雄市", "臺中市", "臺南市"]),
    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }

  func testAdultMaskCountInCounties() throws {
    let observer = scheduler.createObserver([Int].self)

    output.countiesRelay.map { $0.map { $0.adultMaskCount } }.bind(to: observer).disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<[Int]>>] = [
      .next(0, []),
      .next(100, [11820, 5814, 4392, 4332, 3420, 3186, 2994, 2529, 2286, 1403, 1165]),
    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }

  func testPharmaciesCountInCounties() throws {
    let observer = scheduler.createObserver([Int].self)

    output.countiesRelay.map { $0.map { $0.pharmacies.count } }.bind(to: observer).disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<[Int]>>] = [
      .next(0, []),
      .next(100, [4, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1]),
    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }
}

