//
//  ChipGrid.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 21/10/2024.
//
import SwiftUI

struct ChipGrid: View {
    let items: [String]
    @Binding var selectedItems: Set<String>
    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            let rows = self.generateRows(for: items, in: containerWidth)
            VStack(alignment: .leading) {
                ForEach(rows, id: \.self) { rowItems in
                    HStack {
                        ForEach(rowItems, id: \.self) { item in
                            Chip(content: item, isSelected: selectedItems.contains(item)) {
                                if selectedItems.contains(item) {
                                    selectedItems.remove(item)
                                } else {
                                    selectedItems.insert(item)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(height: calculateHeight(for: items, in: UIScreen.main.bounds.width))
    }

    private func generateRows(for items: [String], in containerWidth: CGFloat) -> [[String]] {
        var rows: [[String]] = [[]]
        var currentRowWidth: CGFloat = 0
        for item in items {
            if currentRowWidth + 120 > containerWidth {
                rows.append([item])
                currentRowWidth = 120
            } else {
                rows[rows.count - 1].append(item)
                currentRowWidth += 120
            }
        }
        return rows
    }

    private func calculateHeight(for items: [String], in containerWidth: CGFloat) -> CGFloat {
        let rows = generateRows(for: items, in: containerWidth)
        return CGFloat(rows.count) * 51
    }
}

#Preview {
    struct ChipGrid_Preview: View {
        @State private var selectedItems: Set<String> = []
        var body: some View {
            ChipGrid(items: (1...20).map { "Example\($0)" }, selectedItems: $selectedItems)
        }
    }
    return ChipGrid_Preview()
}
