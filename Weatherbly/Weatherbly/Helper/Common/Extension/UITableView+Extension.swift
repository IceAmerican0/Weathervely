//
//  UITableView+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/05.
//

import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell")
        }
        return cell
    }
    
    func register<T: UITableViewCell>(withType type: T.Type) {
        register(type.self, forCellReuseIdentifier: type.identifier)
    }
}
