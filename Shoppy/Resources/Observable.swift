//
//  Observable.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/12/2023.
//

import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T?) -> Void)?
    
    init(_ value: T?) {
        self.value = value
    }
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
    
}
