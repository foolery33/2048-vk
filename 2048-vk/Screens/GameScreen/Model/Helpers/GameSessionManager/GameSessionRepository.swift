//
//  GameSessionRepository.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import Foundation

protocol GameSessionRepository {
    
    func saveSession(cells: [GameCellViewProtocol])
    func loadSession() -> [GameCellViewProtocol]?
    func deleteCell(withId id: UUID)
    func saveCell(_ cell: GameCellViewProtocol)
    func getCellById(_ id: UUID) -> GameCellModel?
    func updateCell(_ cell: GameCellViewProtocol)
    
}
