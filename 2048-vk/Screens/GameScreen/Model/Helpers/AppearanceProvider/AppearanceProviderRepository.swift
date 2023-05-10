//
//  AppearanceProviderRepository.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import UIKit

protocol AppearanceProviderRepository: AnyObject {
    func getCellBackgroundColor(for value: CellNumber) -> UIColor
    func getCellFontColor(for value: CellNumber) -> UIColor
}
