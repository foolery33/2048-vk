//
//  GetCellNumberFromNumberUseCase.swift
//  2048-vk
//
//  Created by admin on 07.05.2023.
//

import Foundation

protocol GetCellNumberFromNumberProtocol {
    func getCellNumber(_ number: Int) -> CellNumber
}

final class GetCellNumberFromNumberUseCase: GetCellNumberFromNumberProtocol {
    func getCellNumber(_ number: Int) -> CellNumber {
        switch number {
        case 2:
            return ._2
        case 4:
            return ._4
        case 8:
            return ._8
        case 16:
            return ._16
        case 32:
            return ._32
        case 64:
            return ._64
        case 128:
            return ._128
        case 256:
            return ._256
        case 512:
            return ._512
        case 1024:
            return ._1024
        case 2048:
            return ._2048
        default:
            return ._2
        }
    }
}
