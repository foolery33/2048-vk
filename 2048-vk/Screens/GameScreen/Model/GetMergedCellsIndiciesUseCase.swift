//
//  GetMergedCellsIndiciesUseCase.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import Foundation

final class GetMergedCellsIndiciesUseCase {
    
    func getMergedIndicies(cells: [GameCellViewProtocol]) -> [Int] {
        var mergedIndicies: [Int] = []
        var movedIndicies: [Int] = []
        for i in 0..<cells.count {
            for j in i + 1..<cells.count {
                if movedIndicies.contains(j) {
                    continue
                }
                if cells[i].position == cells[j].position &&
                    cells[i].number == cells[j].number {
                    mergedIndicies.append(contentsOf: [i, j])
                }
                else if cells[i].position == cells[j].position &&
                            cells[i].number != cells[j].number {
                    movedIndicies.append(j)
                }
            }
            movedIndicies.append(i)
        }
        return mergedIndicies
    }
    
}
