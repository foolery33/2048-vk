//
//  GetMergeResultCellsUseCase.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import Foundation

final class GetMergeResultCellsUseCase {
    
    func getCells(from cells: [GameCellViewProtocol]) -> [GameCellViewProtocol] {
        var mergeResultCells: [GameCellViewProtocol] = []
        var movedIndicies: [Int] = []
        for i in 0..<cells.count {
            for j in i + 1..<cells.count {
                if movedIndicies.contains(j) {
                    continue
                }
                if cells[i].position == cells[j].position &&
                            cells[i].number != cells[j].number {
                    let mergeResultCell = (cells[i].number.rawValue > cells[j].number.rawValue) ? cells[i] : cells[j]
                    mergeResultCells.append(mergeResultCell)
                    movedIndicies.append(j)
                }
            }
            movedIndicies.append(i)
        }
        return mergeResultCells
    }
    
}
