//
//  CreateTroovStepTitleView.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import SwiftUI

struct CreateTroovStepTitleView: View {
    private let horizontalPadding = 14.0

    @Environment(CreateTroovViewModel.self) var viewModel
    @State private var activityIdea: TActivityIdea = .init(text: "")
    @State private var showingGenerateIdeas = false

    private var troov: Troov? {
        viewModel.troov
    }

    var body: some View {
        VStack(alignment: .center,
               spacing: 0) {
            if let troov = troov {
                TroovCellExpandedImageSlider(name: troov.firstName,
                                   age: troov.age,
                                   images: troov.serverImages ?? [])
            }
    
            RegistrationTextFieldView(text: Binding(get: { activityIdea.text },
                                                    set: { newValue in activityIdea = .init(text: newValue)}),
                                      prompt: "Enter Troov Title or select from “+”",
                                      trailingPadding: 59,
                                      triggerAttention: viewModel.triggerValidationAttention,
                                      ceaseAnimation: showingGenerateIdeas)
            .overlay(alignment: .trailing) {
                ValidatorView<Int, Float>(input: .string(input: activityIdea.text,
                                                         rule: TroovCoreDetails.titleRule),
                                          output: viewModel.validate(_:),
                                          action: validation(action:))
                    .padding(.trailing, 59)
            }
            .overlay(alignment: .trailing) {
                Button(action: generateTitleIdeas) {
                    Image("t.light.bulb.ideas")
                        .padding(5)
                        .background(Circle().fill(Color.primaryTroovColor))
                        .padding(.trailing, 10)
                }.buttonStyle(.scalable(value: 0.95))
            }.padding(.top, 12.relative(to: .height))
            HStack {
                Spacer()
                Text("\(activityIdea.text.count)/\(TroovCoreDetails.titleRule.maxLength ?? 65)")
                    .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 18)
                    .foregroundColor(.rgba(167, 175, 184, 1))
            }.padding(.top, 12.relative(to: .height))
            InfoFillLabel(text: "Your first image will appear in your Troov")
        }.sheet(isPresented: $showingGenerateIdeas) {
            CreateTroovStepTitleGenerateView(selectedIdea: $activityIdea)
        }.onAppear(perform: appear)
         .onDisappear(perform: disappear)
    }

    
    private func appear() {
        activityIdea = .init(text: troov?.title ?? "")
    }

    private func disappear() {
        viewModel.save(title: activityIdea.text)
    }
    
    private func generateTitleIdeas() {
        showingGenerateIdeas = true
    }

    private func validation(action: ValidatorViewAction) {
        switch action {
        case .cleanup:
            activityIdea = .init(text: "")
        }
    }
}

struct CreateTroovStepTitleView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTroovStepTitleView()
    }
}
