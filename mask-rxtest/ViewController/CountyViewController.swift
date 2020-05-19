//
//  CountyViewController.swift
//  mask-rxtest
//
//  Created by Steven Zeng on 2020/5/19.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import UIKit
import Moya
import RxCocoa
import RxSwift

class CountyViewController: UIViewController {
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    title = "Counties"
    bindViewModel()
  }

  private func bindViewModel() {
    let viewModel = CountyViewModel()

    let output = viewModel.transform(input: CountyViewModel.Input(
      refreshSignal: Signal<Void>.of(()),
      provider: MoyaProvider<Service>())
    )

    
  }
}
