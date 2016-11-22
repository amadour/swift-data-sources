//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

protocol DataSource {
    var numberOfSections: Int { get }
    func numberOfObjects(in section: Int) -> Int
    func object(at indexPath: IndexPath) -> Any
    func title(for section: String) -> String
    
    var parent: DataSourceParent? { get }
}

enum DataSourceUpdate {
    case insertSection(IndexSet)
    case deleteSection(IndexSet)
    
    case insertRow([IndexPath])
    case updateRow([IndexPath])
    case deleteRow([IndexPath])
}

protocol DataSourceParent {
    func reload(from: DataSource)
    
    typealias UpdateFunc = ((DataSourceUpdate) -> Void) -> Void
    
    func update(block: UpdateFunc)
}

extension UITableView: DataSourceParent {
    func reload(from: DataSource) {
        reloadData()
    }
    
    func update(block: DataSourceParent.UpdateFunc) {
        beginUpdates()
        
        let animation: UITableViewRowAnimation = .automatic
        block { update in
            switch update {
            case .insertSection(let idxSet): insertSections(idxSet, with: animation)
            case .deleteSection(let idxSet): deleteSections(idxSet, with: animation)
            case .insertRow(let idxPath): insertRows(at: idxPath, with: animation)
            case .updateRow(let idxPath): reloadRows(at: idxPath, with: animation)
            case .deleteRow(let idxPath): deleteRows(at: idxPath, with: animation)
            }
        }
        endUpdates()
    }
}

func f(dsp: DataSourceParent) {
    dsp.update { transaction in
        transaction(.insertRow([ IndexPath(row: 0, section: 1) ]))
        transaction(.deleteRow([ IndexPath(row: 0, section: 1) ]))
    }
}

let data = [ "🍓", "🍓", "🍌", "🍆", "🍆", "💵" ]

class Datasource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bob", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell;
    }
}

let frame = CGRect(x: 0, y: 0, width: 320, height: 640)
let ds = Datasource()
let tableView = UITableView(frame: frame, style: .plain)
tableView.dataSource = ds

tableView.register(UITableViewCell.self, forCellReuseIdentifier: "bob")

PlaygroundPage.current.liveView = tableView

