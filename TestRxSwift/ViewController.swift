//
//  ViewController.swift
//  TestRxSwift
//
//  Created by Admin on 01.09.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

// https://victorqi.gitbooks.io/rxswift/content/observables-aka-sequences.html
// https://rxmarbles.com

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
        
        testFilterOperator()
        testTransformationOperator()
        testConditionalOpertor()
    }
    
    // фильтрующий опрератор
    func testFilterOperator() {
        let sub = Observable.of(1, 20, 5, 40, 6, 50).filter{ $0 > 10}
        sub.subscribe({ (event) in
            print(event) // 20, 40, 50
            }).disposed(by: disposeBag)
    }
    
    // трансформирующий оператор
    func testTransformationOperator() {
        let items = [1, 2, 3]
        _ = Observable
            .from(items)
            .map{ $0 * 10 }
            .subscribe({ (event) in
                print(event) // 10, 20, 30
            })
    }
    
    // комбинирующий оператор
    func testConditionalOpertor() {
        let firstSeq = Observable.of(1, 2, 4)
        let secondSeq = Observable.of(6, 8, 9)
        
        let bothSeq = Observable.of(firstSeq, secondSeq)
        let mergeSeq = bothSeq.merge()
        
        mergeSeq.subscribe({ (event) in
            print(event) // 1,2,6,4,8,9
        }).disposed(by: disposeBag)
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

