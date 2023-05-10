//
//  GameSessionRepositoryImplementation.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import CoreData

final class GameSessionRepositoryImplementation: GameSessionRepository {
    func saveSession(cells: [GameCellViewProtocol]) {
        let fetchRequest: NSFetchRequest<GameCellModel> = GameCellModel.fetchRequest()
        
        do {
            let fetchedCells = try managedObjectContext.fetch(fetchRequest)
            
            let oldIDs = fetchedCells.map { $0.id }
            let newIDs = cells.map { $0.id }
            
            // Удаляем старые клетки из базы данных
            let cellsToDelete = fetchedCells.filter { !newIDs.contains($0.id ?? UUID()) }
            for cell in cellsToDelete {
                managedObjectContext.delete(cell)
            }
            
            // Обновляем существующие клетки в базе данных
            for cell in cells {
                if let databaseCell = fetchedCells.first(where: { $0.id == cell.id }) {
                    databaseCell.positionX = Int16(cell.position.0)
                    databaseCell.positionY = Int16(cell.position.1)
                    databaseCell.numberValue = Int16(cell.number.rawValue)
                }
            }
            
            // Добавляем новые клетки в базу данных
            let cellsToAdd = cells.filter { !oldIDs.contains($0.id) }
            for cell in cellsToAdd {
                let newCell = GameCellModel(context: managedObjectContext)
                newCell.id = cell.id
                newCell.positionX = Int16(cell.position.0)
                newCell.positionY = Int16(cell.position.1)
                newCell.numberValue = Int16(cell.number.rawValue)
            }
            
            try managedObjectContext.save()
        } catch {
            print("Error saving game session: \(error.localizedDescription)")
        }
    }
    
    func loadSession() -> [GameCellViewProtocol]? {
        let fetchRequest: NSFetchRequest<GameCellModel> = GameCellModel.fetchRequest()
        do {
            let databaseCells = try managedObjectContext.fetch(fetchRequest)
            if databaseCells.isEmpty {
                return nil
            }
            var gameCells: [GameCellViewProtocol] = []
            for cell in databaseCells {
                let currentCell = GameCellView(number: getCellNumberFromNumberUseCase.getCellNumber(Int(cell.numberValue)), position: (Int(cell.positionX), Int(cell.positionY)))
                gameCells.append(currentCell)
            }
            return gameCells
        } catch {
            print("Error fetching game cells: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteCell(withId id: UUID) {
        if let cell = getCellById(id) {
            managedObjectContext.delete(cell)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save managed object context: \(error)")
        }
    }
    
    func saveCell(_ cell: GameCellViewProtocol) {
        let newCell = GameCellModel(context: managedObjectContext)
        newCell.id = cell.id
        newCell.numberValue = Int16(cell.number.rawValue)
        newCell.positionX = Int16(cell.position.0)
        newCell.positionY = Int16(cell.position.1)
        
        saveContext()
    }
    
    func updateCell(_ cell: GameCellViewProtocol) {
        
        if let databaseCell = getCellById(cell.id) {
            databaseCell.positionX = Int16(cell.position.0)
            databaseCell.positionY = Int16(cell.position.1)
            databaseCell.numberValue = Int16(cell.number.rawValue)
            
            saveContext()
        }
    }
    
    
    private let getCellNumberFromNumberUseCase: GetCellNumberFromNumberUseCase
    private let managedObjectContext: NSManagedObjectContext
    
    init(getCellNumberFromNumberUseCase: GetCellNumberFromNumberUseCase, managedObjectContext: NSManagedObjectContext) {
        self.getCellNumberFromNumberUseCase = getCellNumberFromNumberUseCase
        self.managedObjectContext = managedObjectContext
    }
    
    func getCellById(_ id: UUID) -> GameCellModel? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GameCellModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result.first as? GameCellModel
        } catch {
            print("Failed to fetch game cell: \(error)")
            return nil
        }
    }
    
}
