//
//  MockedGetCellNumberFromNumberUseCase.swift
//  2048-vkTests
//
//  Created by Nikita Usov on 22.12.2023.
//

@testable import _048_vk

final class MockedGetCellNumberFromNumberUseCase: GetCellNumberFromNumberProtocol {
    var methodCallCounter = 0
    var result: CellNumber!

    func getCellNumber(_ number: Int) -> CellNumber {
        methodCallCounter += 1
        return result
    }
}
