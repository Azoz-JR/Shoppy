//
//  Helper.swift
//  Shoppy
//
//  Created by Azoz Salah on 09/12/2023.
//

import UIKit

extension DispatchQueue {
    static func mainAsyncIfNeeded(execute work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            main.async(execute: work)
        }
    }
}
