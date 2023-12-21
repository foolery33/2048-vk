//
//  SwipeGestureUseCaseTest.swift
//  2048-vkTests
//
//  Created by Nikita Usov on 21.12.2023.
//

import XCTest
@testable import _048_vk

final class SwipeGestureUseCaseTest: XCTestCase {

    private var sut: SwipeGestureUseCase!
    private var mock: MockedGetCellNumberFromNumberUseCase!

    override func setUpWithError() throws {
        mock = MockedGetCellNumberFromNumberUseCase()
        sut = SwipeGestureUseCase(
            getCellNumberFromNumberUseCase: mock
        )
    }

    override func tearDownWithError() throws {
        mock = nil
        sut = nil
    }

    func testOnUpSwipe_OneNewCellGenerated_ReturnsOneMockCallCounter() {
        // Arrange
        var cells: [GameCellViewProtocol] = [
            GameCellView(
                number: ._2,
                position: (0, 3)
            ),
            GameCellView(
                number: ._2,
                position: (0, 1)
            )
        ]
        mock.result = ._4

        // Act
        let result = sut.onUpSwipe(cells: &cells)

        // Assert
        XCTAssertEqual(mock.methodCallCounter, 1)
    }

    func testOnUpSwipe_ZeroNewCellsGenerated_ReturnsZeroMockCallCounter() {
        // Arrange
        var cells: [GameCellViewProtocol] = [
            GameCellView(
                number: ._2,
                position: (0, 3)
            ),
            GameCellView(
                number: ._2,
                position: (1, 1)
            )
        ]

        // Act
        let result = sut.onUpSwipe(cells: &cells)

        // Assert
        XCTAssertEqual(mock.methodCallCounter, 0)
    }

    func testOnUpSwipe_FourNewCellsGenerated_ReturnsFourMockCallCounter() {
        // Arrange
        var cells: [GameCellViewProtocol] = [
            GameCellView(
                number: ._2,
                position: (0, 3)
            ),
            GameCellView(
                number: ._2,
                position: (0, 1)
            ),
            GameCellView(
                number: ._2,
                position: (1, 3)
            ),
            GameCellView(
                number: ._2,
                position: (1, 1)
            ),
            GameCellView(
                number: ._2,
                position: (2, 3)
            ),
            GameCellView(
                number: ._2,
                position: (2, 1)
            ),
            GameCellView(
                number: ._2,
                position: (3, 3)
            ),
            GameCellView(
                number: ._2,
                position: (3, 1)
            )
        ]
        mock.result = ._4

        // Act
        let result = sut.onUpSwipe(cells: &cells)

        // Assert
        XCTAssertEqual(mock.methodCallCounter, 4)
    }

}
