//
//  AppearanceProvider.swift
//  2048-vk
//
//  Created by admin on 06.05.2023.
//

import UIKit

final class AppearanceProviderImplementation: AppearanceProviderRepository {
    func getCellBackgroundColor(for value: CellNumber) -> UIColor {
        switch value {
        case ._2:
            return .background2
        case ._4:
            return .background4
        case ._8:
            return .background8
        case ._16:
            return .background16
        case ._32:
            return .background32
        case ._64:
            return .background64
        case ._128:
            return .background128
        case ._256:
            return .background256
        case ._512:
            return .background512
        case ._1024:
            return .background1024
        case ._2048:
            return .background2048
        }
    }
    func getCellFontColor(for value: CellNumber) -> UIColor {
        switch value {
        case ._2:
            return .font2
        case ._4:
            return .font4
        case ._8:
            return .font8
        case ._16:
            return .font16
        case ._32:
            return .font32
        case ._64:
            return .font64
        case ._128:
            return .font128
        case ._256:
            return .font256
        case ._512:
            return .font512
        case ._1024:
            return .font1024
        case ._2048:
            return .font2048
        }
    }
}

enum CellNumber {
    case _2
    case _4
    case _8
    case _16
    case _32
    case _64
    case _128
    case _256
    case _512
    case _1024
    case _2048
    
    var rawValue: Int {
        switch self {
        case ._2:
            return 2
        case ._4:
            return 4
        case ._8:
            return 8
        case ._16:
            return 16
        case ._32:
            return 32
        case ._64:
            return 64
        case ._128:
            return 128
        case ._256:
            return 256
        case ._512:
            return 512
        case ._1024:
            return 1024
        case ._2048:
            return 2048
        }
    }
}
