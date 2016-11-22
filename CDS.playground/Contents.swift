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

enum UpdateSection {
    case insert([IndexSet])
    case delete([IndexSet])
}

enum Update {
    case insert([IndexPath])
    case update([IndexPath])
    case delete([IndexPath])
}

protocol DataSourceParent {
    func reload(from: DataSource)
    
    typealias UpdateFunc = ((UpdateSection) -> Void, (Update) -> Void) -> Void
    
    func update(sections: UpdateFunc)
}

func f(dsp: DataSourceParent) {
    dsp.update { sections, rows in
        rows(.insert([ IndexPath(row: 0, section: 1) ]))
        rows(.delete([ IndexPath(row: 0, section: 1) ]))
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

