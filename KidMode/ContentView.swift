//
//  ContentView.swift
//  KidMode
//
//  Created by Olimpia Compean on 4/28/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

@main
struct KidModeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class ShieldingViewModel: ObservableObject {
    let store = ManagedSettingsStore()
    @Published var selection = FamilyActivitySelection()
    
    func activateKidMode() {
        store.shield.applications = selection.applicationTokens
    }
    
    func deactivateKidMode() {
        store.shield.applications = []
    }
}

struct ContentView: View {
    @StateObject var viewModel = ShieldingViewModel()
    @State private var isPresentingPicker = false
    @State private var kidModeOn = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Toggle("Kid Mode", isOn: $kidModeOn)
                    .onChange(of: kidModeOn) { value in
                        if value {
                            viewModel.activateKidMode()
                        } else {
                            viewModel.deactivateKidMode()
                        }
                    }
                    .padding()
                
                Button("Choose Apps to Block") {
                    isPresentingPicker = true
                }
                .familyActivityPicker(
                    isPresented: $isPresentingPicker,
                    selection: $viewModel.selection
                )
                Spacer()
            }
            .navigationTitle("Kid Mode Control")
        }
        
    }
}

#Preview {
    ContentView()
}



