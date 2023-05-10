//
//  GameCellModel+CoreDataProperties.swift
//  2048-vk
//
//  Created by admin on 10.05.2023.
//
//

import Foundation
import CoreData


extension GameCellModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameCellModel> {
        return NSFetchRequest<GameCellModel>(entityName: "GameCellModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var numberValue: Int16
    @NSManaged public var positionX: Int16
    @NSManaged public var positionY: Int16

}

extension GameCellModel : Identifiable {

}
