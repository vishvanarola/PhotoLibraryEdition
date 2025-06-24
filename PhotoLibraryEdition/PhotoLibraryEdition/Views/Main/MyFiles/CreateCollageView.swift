//
//  CreateCollageView.swift
//  PhotoLibraryEdition
//
//  Created by vishva narola on 24/06/25.
//

import SwiftUI

struct CreateCollageView: View {
    @Environment(\.modelContext) private var modelContext
    @State var collageName: String = ""
    @Binding var isPresented: Bool
    var collageToEdit: Collage?

    init(isPresented: Binding<Bool>, collageToEdit: Collage? = nil) {
        self._isPresented = isPresented
        self.collageToEdit = collageToEdit
        if let collage = collageToEdit {
            _collageName = State(initialValue: collage.name)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(collageToEdit == nil ? "Create a Collage" : "Edit Collage")
                .font(FontConstants.MontserratFonts.medium(size: 24))
                .foregroundStyle(Color.black)
            
            TextField("", text: $collageName, prompt: Text("Name..").font(FontConstants.MontserratFonts.medium(size: 18)).foregroundColor(.gray))
                .font(FontConstants.MontserratFonts.semiBold(size: 18))
                .keyboardType(.default)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Text("Cancel")
                        .font(FontConstants.MontserratFonts.medium(size: 20))
                        .foregroundStyle(Color.black)
                }
                Spacer()
                Divider()
                    .frame(width: 1, height: 40)
                    .background(textGrayColor)
                Spacer()
                Button {
                    if let collage = collageToEdit {
                        collage.name = collageName
                    } else {
                        let newCollage = Collage(name: collageName)
                        modelContext.insert(newCollage)
                    }
                    do {
                        try modelContext.save()
                    } catch {
                        print("Failed to save collage: \(error)")
                    }
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Text(collageToEdit == nil ? "Create" : "Save")
                        .font(FontConstants.MontserratFonts.medium(size: 20))
                        .foregroundStyle(Color.black)
                }
                Spacer()
            }
            .frame(height: 35)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity)
        .background(pinkOpacityColor.opacity(0.06))
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 45)
        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 0)
    }
}

#Preview {
    CreateCollageView(isPresented: .constant(false))
}

