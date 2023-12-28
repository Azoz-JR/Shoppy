//
//  Observable.swift
//  Shoppy
//
//  Created by Azoz Salah on 05/12/2023.
//

import Foundation

class Observable<T> {
    typealias Observer = (T?) -> Void
    var observers: [Observer] = []
    
    var value: T? {
        didSet {
            DispatchQueue.mainAsyncIfNeeded {
                self.notifyObservers()
            }
        }
    }
        
    init(_ value: T?) {
        self.value = value
    }
    
    func addObserver(_ observer: @escaping Observer) {
        observers.append(observer)
        observer(value)
    }
    
    func notifyObservers() {
        observers.forEach { observer in
            observer(value)
        }
    }
    
}
