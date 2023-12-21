//
//  SwipeGestureUseCase.swift
//  2048-vk
//
//  Created by admin on 07.05.2023.
//

import UIKit

final class SwipeGestureUseCase {
    
    var getCellNumberFromNumberUseCase: GetCellNumberFromNumberProtocol

    init(getCellNumberFromNumberUseCase: GetCellNumberFromNumberProtocol) {
        self.getCellNumberFromNumberUseCase = getCellNumberFromNumberUseCase
    }
    
    // На примере функции onUpSwipe объясняю принцип работы придуманного мной алгоритма. Для остальных функций всё делается аналогично
    func onUpSwipe(cells: inout [GameCellViewProtocol]) -> Bool {
        
        var newCells: [GameCellViewProtocol] = []
        var mergedIndicies: [Int] = []
        cells = cells.sorted { $0.position.1 < $1.position.1 }
        let startedCells = cells.map( { $0.position } )
        
        // Мёрджим клетки и добавляем новые клетки в массив newCells
        for i in 0..<cells.count {
            for j in i + 1..<cells.count {
                if cells[i].position.0 == cells[j].position.0 && cells[i].number == cells[j].number && !mergedIndicies.contains(i) && !mergedIndicies.contains(j) {
                    // Если между ними есть клетки, то выходим из цикла
                    var foundBetween = false
                    for k in 0..<cells.count {
                        if cells[k].position.0 == cells[i].position.0 && ((cells[k].position.1 > cells[i].position.1 && cells[k].position.1 < cells[j].position.1) || (cells[k].position.1 < cells[i].position.1 && cells[k].position.1 > cells[j].position.1)) {
                            foundBetween = true
                        }
                    }
                    if foundBetween {
                        break
                    }
                    cells[j].position.1 = cells[i].position.1
                    mergedIndicies.append(contentsOf: [i, j])
                    let newCell: GameCellViewProtocol = GameCellView(number: getCellNumberFromNumberUseCase.getCellNumber(cells[i].number.rawValue + cells[j].number.rawValue), position: cells[i].position)
                    newCells.append(newCell)
                    break
                }
            }
        }
        
        /*
         На текущем этапе все клетки смёрджены и помещены на свои законные места, поэтому если клетка идёт максимально вверх, то она "упрётся" в ту,
         которая находится на ближайшем от неё расстоянии сверху. Так как мы идём по циклу "сверху вниз", то мы однозначно можем сказать,
         что мы сначала будем поднимать верхние клетки, затем клетки ниже, ниже, ниже и так до конца. То есть, после этого цикла все клетки будут на своих местах.
         То есть, мы для каждой клетки будем искать ближайшую клетку сверху и после цикла присваивать клетке position = position ближайшей клетке сверху -1 (по .1)
         Если ближайшей клетки сверху не нашлось, то эта клетка и так самая верхняя. Тогда меняем её position.1 на 0
         */
        
        // Сдвигаем все клетки максимально вверх
        var movedCells: [Int] = []
        for i in 0..<cells.count {
            if movedCells.contains(i) {
                continue
            }
            var nearestCellYPosition: Int? = nil
            var minDistance: Int? = nil
            for j in 0..<i {
                if cells[i].position.0 == cells[j].position.0 {
                    if minDistance == nil {
                        nearestCellYPosition = cells[j].position.1
                        minDistance = abs(cells[i].position.1 - cells[j].position.1)
                    }
                    else {
                        if abs(cells[i].position.1 - cells[j].position.1) < minDistance! {
                            nearestCellYPosition = cells[j].position.1
                            minDistance = abs(cells[i].position.1 - cells[j].position.1)
                        }
                    }
                }
            }
            // Не нашли ближайшую для i-ой клетку => ставим её в самый верх
            if nearestCellYPosition == nil {
                // Если i-ая клетка была смёрджена, то ищем её пару и помещаем их обе в нулевую по игреку позицию
                if mergedIndicies.contains(i) {
                    for k in 0..<mergedIndicies.count {
                        if cells[i].position == cells[mergedIndicies[k]].position && i != mergedIndicies[k] {
                            // Сначала ищем новую клетку, являющуюся результатом этого мёрджа
                            for l in 0..<newCells.count {
                                if cells[mergedIndicies[k]].position == newCells[l].position {
                                    newCells[l].position.1 = 0
                                    break
                                }
                            }
                            movedCells.append(contentsOf: [i, mergedIndicies[k]])
                            cells[i].position.1 = 0
                            cells[mergedIndicies[k]].position.1 = 0
                        }
                    }
                }
                else {
                    movedCells.append(i)
                    cells[i].position.1 = 0
                }
            }
            // Нашли ближайшую для i-ой клетку => ставим i-ую клетку и её пару (если она есть) в позицию под ней
            else {
                if mergedIndicies.contains(i) {
                    for k in 0..<mergedIndicies.count {
                        if cells[i].position == cells[mergedIndicies[k]].position && i != mergedIndicies[k] {
                            // Сначала ищем новую клетку, являющуюся результатом этого мёрджа
                            for l in 0..<newCells.count {
                                if cells[mergedIndicies[k]].position == newCells[l].position {
                                    newCells[l].position.1 = nearestCellYPosition! + 1
                                    break
                                }
                            }
                            movedCells.append(contentsOf: [i, mergedIndicies[k]])
                            cells[i].position.1 = nearestCellYPosition! + 1
                            cells[mergedIndicies[k]].position.1 = nearestCellYPosition! + 1
                        }
                    }
                }
                else {
                    movedCells.append(i)
                    cells[i].position.1 = nearestCellYPosition! + 1
                }
            }
        }
        
        // Добавляем новые клетки в массив cells
        cells.append(contentsOf: newCells)
        
        // Проверяем, были ли изменения в массиве cells
        if cells.count != startedCells.count {
            return true
        }
        else {
            for i in 0..<cells.count {
                if cells[i].position.0 != startedCells[i].0 || cells[i].position.1 != startedCells[i].1 {
                    return true
                }
            }
        }
        return false
        
    }
    
    func onDownSwipe(cells: inout [GameCellViewProtocol], dimension: Int) -> Bool {

        var newCells: [GameCellViewProtocol] = []
        var mergedIndicies: [Int] = []
        cells = cells.sorted { $0.position.1 > $1.position.1 }
        let startedCells = cells.map( { $0.position } )

        for i in 0..<cells.count {
            for j in i + 1..<cells.count {
                if cells[i].position.0 == cells[j].position.0 && cells[i].number == cells[j].number && !mergedIndicies.contains(i) && !mergedIndicies.contains(j) {
                    var foundBetween = false
                    for k in 0..<cells.count {
                        if cells[k].position.0 == cells[i].position.0 && ((cells[k].position.1 > cells[i].position.1 && cells[k].position.1 < cells[j].position.1) || (cells[k].position.1 < cells[i].position.1 && cells[k].position.1 > cells[j].position.1)) {
                            foundBetween = true
                        }
                    }
                    if foundBetween {
                        break
                    }
                    cells[j].position.1 = cells[i].position.1
                    mergedIndicies.append(contentsOf: [i, j])
                    let newCell: GameCellViewProtocol = GameCellView(number: getCellNumberFromNumberUseCase.getCellNumber(cells[i].number.rawValue + cells[j].number.rawValue), position: cells[i].position)
                    newCells.append(newCell)
                    break
                }
            }
        }

        var movedCells: [Int] = []
        for i in 0..<cells.count {
            if movedCells.contains(i) {
                continue
            }
            var nearestCellYPosition: Int? = nil
            var minDistance: Int? = nil
            for j in 0..<i {
                if cells[i].position.0 == cells[j].position.0 {
                    if minDistance == nil {
                        nearestCellYPosition = cells[j].position.1
                        minDistance = abs(cells[i].position.1 - cells[j].position.1)
                    }
                    else {
                        if abs(cells[i].position.1 - cells[j].position.1) < minDistance! {
                            nearestCellYPosition = cells[j].position.1
                            minDistance = abs(cells[i].position.1 - cells[j].position.1)
                        }
                    }
                }
            }
            if nearestCellYPosition == nil {
                if mergedIndicies.contains(i) {
                    for k in 0..<mergedIndicies.count {
                        if cells[i].position == cells[mergedIndicies[k]].position && i != mergedIndicies[k] {
                            for l in 0..<newCells.count {
                                if cells[mergedIndicies[k]].position == newCells[l].position {
                                    newCells[l].position.1 = dimension - 1
                                    break
                                }
                            }
                            movedCells.append(contentsOf: [i, mergedIndicies[k]])
                            cells[i].position.1 = dimension - 1
                            cells[mergedIndicies[k]].position.1 = dimension - 1
                        }
                    }
                }
                else {
                    movedCells.append(i)
                    cells[i].position.1 = dimension - 1
                }
            }
            else {
                if mergedIndicies.contains(i) {
                    for k in 0..<mergedIndicies.count {
                        if cells[i].position == cells[mergedIndicies[k]].position && i != mergedIndicies[k] {
                            for l in 0..<newCells.count {
                                if cells[mergedIndicies[k]].position == newCells[l].position {
                                    newCells[l].position.1 = nearestCellYPosition! - 1
                                    break
                                }
                            }
                            movedCells.append(contentsOf: [i, mergedIndicies[k]])
                            cells[i].position.1 = nearestCellYPosition! - 1
                            cells[mergedIndicies[k]].position.1 = nearestCellYPosition! - 1
                        }
                    }
                }
                else {
                    movedCells.append(i)
                    cells[i].position.1 = nearestCellYPosition! - 1
                }
            }
        }

        cells.append(contentsOf: newCells)

        if cells.count != startedCells.count {
            return true
        }
        else {
            for i in 0..<cells.count {
                if cells[i].position.0 != startedCells[i].0 || cells[i].position.1 != startedCells[i].1 {
                    return true
                }
            }
        }
        return false
    }
    
    func onLeftSwipe(cells: inout [GameCellViewProtocol]) -> Bool {
        
        var newCells: [GameCellViewProtocol] = []
        var mergedIndicies: [Int] = []
        cells = cells.sorted { $0.position.0 < $1.position.0 }
        let startedCells = cells.map( { $0.position } )
        
        for i in 0..<cells.count {
            for j in i + 1..<cells.count {
                if cells[i].position.1 == cells[j].position.1 && cells[i].number == cells[j].number && !mergedIndicies.contains(i) && !mergedIndicies.contains(j) {
                    var foundBetween = false
                    for k in 0..<cells.count {
                        if cells[k].position.1 == cells[i].position.1 && ((cells[k].position.0 > cells[i].position.0 && cells[k].position.0 < cells[j].position.0) || (cells[k].position.0 < cells[i].position.0 && cells[k].position.0 > cells[j].position.0)) {
                            foundBetween = true
                        }
                    }
                    if foundBetween {
                        break
                    }
                    cells[j].position.0 = cells[i].position.0
                    mergedIndicies.append(contentsOf: [i, j])
                    let newCell: GameCellViewProtocol = GameCellView(number: getCellNumberFromNumberUseCase.getCellNumber(cells[i].number.rawValue + cells[j].number.rawValue), position: cells[i].position)
                    newCells.append(newCell)
                    break
                }
            }
        }

        var movedCells: [Int] = []
        for i in 0..<cells.count {
            if movedCells.contains(i) {
                continue
            }
            var nearestCellYPosition: Int? = nil
            var minDistance: Int? = nil
            for j in 0..<i {
                if cells[i].position.1 == cells[j].position.1 {
                    if minDistance == nil {
                        nearestCellYPosition = cells[j].position.0
                        minDistance = abs(cells[i].position.0 - cells[j].position.0)
                    }
                    else {
                        if abs(cells[i].position.0 - cells[j].position.0) < minDistance! {
                            nearestCellYPosition = cells[j].position.0
                            minDistance = abs(cells[i].position.0 - cells[j].position.0)
                        }
                    }
                }
            }
            if nearestCellYPosition == nil {
                if mergedIndicies.contains(i) {
                    for k in 0..<mergedIndicies.count {
                        if cells[i].position == cells[mergedIndicies[k]].position && i != mergedIndicies[k] {
                            for l in 0..<newCells.count {
                                if cells[mergedIndicies[k]].position == newCells[l].position {
                                    newCells[l].position.0 = 0
                                    break
                                }
                            }
                            movedCells.append(contentsOf: [i, mergedIndicies[k]])
                            cells[i].position.0 = 0
                            cells[mergedIndicies[k]].position.0 = 0
                        }
                    }
                }
                else {
                    movedCells.append(i)
                    cells[i].position.0 = 0
                }
            }
            else {
                if mergedIndicies.contains(i) {
                    for k in 0..<mergedIndicies.count {
                        if cells[i].position == cells[mergedIndicies[k]].position && i != mergedIndicies[k] {
                            for l in 0..<newCells.count {
                                if cells[mergedIndicies[k]].position == newCells[l].position {
                                    newCells[l].position.0 = nearestCellYPosition! + 1
                                    break
                                }
                            }
                            movedCells.append(contentsOf: [i, mergedIndicies[k]])
                            cells[i].position.0 = nearestCellYPosition! + 1
                            cells[mergedIndicies[k]].position.0 = nearestCellYPosition! + 1
                        }
                    }
                }
                else {
                    movedCells.append(i)
                    cells[i].position.0 = nearestCellYPosition! + 1
                }
            }
        }

        cells.append(contentsOf: newCells)

        if cells.count != startedCells.count {
            return true
        }
        else {
            for i in 0..<cells.count {
                if cells[i].position.0 != startedCells[i].0 || cells[i].position.1 != startedCells[i].1 {
                    return true
                }
            }
        }
        return false
        
    }
    
    func onRightSwipe(cells: inout [GameCellViewProtocol], dimension: Int) -> Bool {
        
        var newCells: [GameCellViewProtocol] = []
        var mergedIndicies: [Int] = []
        cells = cells.sorted { $0.position.0 > $1.position.0 }
        let startedCells = cells.map( { $0.position } )

        for i in 0..<cells.count {
            for j in i + 1..<cells.count {
                if cells[i].position.1 == cells[j].position.1 && cells[i].number == cells[j].number && !mergedIndicies.contains(i) && !mergedIndicies.contains(j) {
                    var foundBetween = false
                    for k in 0..<cells.count {
                        if cells[k].position.1 == cells[i].position.1 && ((cells[k].position.0 > cells[i].position.0 && cells[k].position.0 < cells[j].position.0) || (cells[k].position.0 < cells[i].position.0 && cells[k].position.0 > cells[j].position.0)) {
                            foundBetween = true
                        }
                    }
                    if foundBetween {
                        break
                    }
                    cells[j].position.0 = cells[i].position.0
                    mergedIndicies.append(contentsOf: [i, j])
                    let newCell: GameCellViewProtocol = GameCellView(number: getCellNumberFromNumberUseCase.getCellNumber(cells[i].number.rawValue + cells[j].number.rawValue), position: cells[i].position)
                    newCells.append(newCell)
                    break
                }
            }
        }

        var movedCells: [Int] = []
        for i in 0..<cells.count {
            if movedCells.contains(i) {
                continue
            }
            var nearestCellYPosition: Int? = nil
            var minDistance: Int? = nil
            for j in 0..<i {
                if cells[i].position.1 == cells[j].position.1 {
                    if minDistance == nil {
                        nearestCellYPosition = cells[j].position.0
                        minDistance = abs(cells[i].position.0 - cells[j].position.0)
                    }
                    else {
                        if abs(cells[i].position.0 - cells[j].position.0) < minDistance! {
                            nearestCellYPosition = cells[j].position.0
                            minDistance = abs(cells[i].position.0 - cells[j].position.0)
                        }
                    }
                }
            }
            if nearestCellYPosition == nil {
                if mergedIndicies.contains(i) {
                    for k in 0..<mergedIndicies.count {
                        if cells[i].position == cells[mergedIndicies[k]].position && i != mergedIndicies[k] {
                            for l in 0..<newCells.count {
                                if cells[mergedIndicies[k]].position == newCells[l].position {
                                    newCells[l].position.0 = dimension - 1
                                    break
                                }
                            }
                            movedCells.append(contentsOf: [i, mergedIndicies[k]])
                            cells[i].position.0 = dimension - 1
                            cells[mergedIndicies[k]].position.0 = dimension - 1
                        }
                    }
                }
                else {
                    movedCells.append(i)
                    cells[i].position.0 = dimension - 1
                }
            }
            else {
                if mergedIndicies.contains(i) {
                    for k in 0..<mergedIndicies.count {
                        if cells[i].position == cells[mergedIndicies[k]].position && i != mergedIndicies[k] {
                            for l in 0..<newCells.count {
                                if cells[mergedIndicies[k]].position == newCells[l].position {
                                    newCells[l].position.0 = nearestCellYPosition! - 1
                                    break
                                }
                            }
                            movedCells.append(contentsOf: [i, mergedIndicies[k]])
                            cells[i].position.0 = nearestCellYPosition! - 1
                            cells[mergedIndicies[k]].position.0 = nearestCellYPosition! - 1
                        }
                    }
                }
                else {
                    movedCells.append(i)
                    cells[i].position.0 = nearestCellYPosition! - 1
                }
            }
        }

        cells.append(contentsOf: newCells)

        if cells.count != startedCells.count {
            return true
        }
        else {
            for i in 0..<cells.count {
                if cells[i].position.0 != startedCells[i].0 || cells[i].position.1 != startedCells[i].1 {
                    return true
                }
            }
        }
        return false
    }
    
}
