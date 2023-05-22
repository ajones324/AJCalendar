//
//  Array+toDictionary.swift
//  AJCalendar
//
//  Created by Andrew Ikenna Jones on 5/22/23.
//

import Foundation

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
