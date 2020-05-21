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
import RxDataSources

class CountyViewController: UIViewController {
  let disposeBag = DisposeBag()
  var viewModel: CountyViewModel?

  var tableView: UITableView = {
    let tableView = UITableView()
    tableView.accessibilityIdentifier = "tableView"
    return tableView
  }()

  var refreshButton: UIBarButtonItem = {
    let button = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
    return button
  }()

  var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.startAnimating()
    return activityIndicator
  }()

  let dataSource = RxTableViewSectionedReloadDataSource<CountySection>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "cell")
    cell.accessibilityIdentifier = "\(indexPath.row)"
    cell.textLabel?.text = item.name.isEmpty ? "未分類" : item.name
    cell.textLabel?.accessibilityIdentifier = "nameLabel"
    cell.detailTextLabel?.text = "成人：\(item.adultMaskCount)"
    cell.detailTextLabel?.accessibilityIdentifier = "countLabel"
     return cell
   })

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Counties"
    setupSubview()
    bindViewModel()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
    activityIndicator.center = view.center
  }

  private func setupSubview() {
    view.addSubview(tableView)
    view.addSubview(activityIndicator)
    navigationItem.rightBarButtonItem = refreshButton
    view.backgroundColor = .systemBackground
  }

  private func bindViewModel() {
    let viewModel = CountyViewModel()
    self.viewModel = viewModel

    let output = viewModel.transform(input: CountyViewModel.Input(
      refreshSignal: Signal<Void>.merge(Signal<Void>.of(()), refreshButton.rx.tap.asSignal()),
      provider: MoyaProvider<Service>())
    )

    output.isLoading.drive(activityIndicator.rx.isAnimating).disposed(by: disposeBag)

    output.countiesRelay
      .map { [CountySection(header: "", items: $0)] }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
