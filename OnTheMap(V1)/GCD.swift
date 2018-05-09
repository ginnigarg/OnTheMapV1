//
//  GCD.swift
//  OnTheMap(V1)
//
//  Created by Guneet Garg on 06/05/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation

func performUIUpdatesOnMainThread (_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
