//
//  SideProfileTableViewDelegate.swift
//  Shoppy
//
//  Created by Azoz Salah on 22/01/2024.
//

import UIKit

final class SideProfileTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let data: [SideProfileCellType] = SideProfileCellType.allCases
    weak var parentController: MainTabBarPresenter?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SideProfileCell.identifier, for: indexPath) as? SideProfileCell {
            let row = data[indexPath.row]
            cell.configure(label: row.title, image: row.image)
            
            return cell
        }
        fatalError("Unable to dequeue SideProfileCell")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentController?.itemSelected(item: data[indexPath.row])
    }
    
}
