//
//  View+MatchingGeometry.swift
//  RecipeBrowser
//
//  Created by Amira Ajibola  on 3/28/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func applyMatchingGeometryEffect(id: String?, namespace: Namespace.ID?) -> some View {
        if let id, let namespace {
            self.matchedGeometryEffect(id: id, in: namespace)
        } else {
            self
        }
    }
}
