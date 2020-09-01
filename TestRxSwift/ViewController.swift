//
//  ViewController.swift
//  TestRxSwift
//
//  Created by Admin on 01.09.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
        
    var showCities = [String]()
    let fakeApi = ["Москва", "Уфа", "Казань", "Питер", "Пермь", "Гаага"]
    let disposeBag = DisposeBag() // корзина для используемых переменных, чтобы освободить место после уничтожения View и не было retain cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        rxSearchBar()
    }
    
    func rxSearchBar() {
        searchBar
            .rx.text // наблюдатель
            .throttle(0.5, scheduler: MainScheduler.instance) // задержка перед запросом
            .distinctUntilChanged() // проверка на уникальные значения
            .subscribe(onNext: { (querry) in // подписываемся на новые значения
                self.showCities = self.fakeApi.filter { $0.hasPrefix(querry ?? "1") } // делаем запрос, также можно было сделать с колбэками
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return showCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        cell.textLabel?.text = showCities[indexPath.row]
        
        return cell
    }
    
    
}

