//
//  MapSettingsViewModel.swift
//  ELEC3644 Property
//
//  Created by Mak Yilam on 25/11/2024.
//

import Combine
import Foundation
import SwiftUI

class MapSettingsViewModel: ObservableObject {
    @Published var mapZoomEnabled: Bool {
        didSet {
            UserDefaults.standard.set(mapZoomEnabled, forKey: "mapZoomEnabled")
        }
    }

    @Published var mapPanEnabled: Bool {
        didSet {
            UserDefaults.standard.set(mapPanEnabled, forKey: "mapPanEnabled")
        }
    }

    init() {
        self.mapZoomEnabled = UserDefaults.standard.bool(forKey: "mapZoomEnabled")
        self.mapPanEnabled = UserDefaults.standard.bool(forKey: "mapPanEnabled")
    }
}
