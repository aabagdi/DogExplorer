//
//  Router.swift
//  DogExplorer
//
//  Created by Aadit Bagdi on 1/29/25.
//

import Foundation
import SwiftUI

@Observable
class Router {
    var navigationPath = NavigationPath()

    func navigateTo(route: Route) {
        navigationPath.append(route)
    }
}
