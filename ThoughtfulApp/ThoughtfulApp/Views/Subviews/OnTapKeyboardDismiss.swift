//
//  OnTapKeyboardDismiss.swift
//  ThoughtfulApp
//
//  Created by Caleb Mace on 4/2/26.
//

import SwiftUI

extension View {
    func dismissKeyboardOnTap(onSubmit: (() -> Void)? = nil) -> some View {
        self.onTapGesture {
            onSubmit?()
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
    }
}
