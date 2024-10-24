//
//  MenuItem.swift
//  ELEC3644 Property App
//
//  Created by Filbert Tejalaksana on 9/10/2024.
//

import Foundation

enum MenuItem: String, CaseIterable {
  case buy = "Buy"
  case rent = "Rent"
  case lease = "Lease"
  case transaction = "Transaction"
  case estate = "Estate"
  case agents = "Agents"

  var systemImage: String {
    switch self {
    case .buy:
      return "house"
    case .rent:
      return "house.fill"
    case .lease:
      return "text.document.fill"
    case .transaction:
      return "chart.line.uptrend.xyaxis"
    case .estate:
      return "building"
    case .agents:
      return "person.crop.circle"
    }
  }
}
