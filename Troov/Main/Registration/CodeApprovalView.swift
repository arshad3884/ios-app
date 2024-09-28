//
//  CodeApprovalView.swift
//  Troov
//
//  Created by Leo on 01.09.2023.
//

import SwiftUI

struct CodeApprovalView: View {
    @Binding var codeValidationState: ValidationState

    @State private var viewModel = CodeApprovalViewModel()
    @Environment(RegisterViewModel.self) var registerViewModel

    private let textBoxWidth = 43.relative(to: .width)
    private let spaceBetweenBoxes: CGFloat = 12.relative(to: .width)
    private let paddingOfBox: CGFloat = 1

    private var textFieldOriginalWidth: CGFloat {
        (textBoxWidth*6)+(spaceBetweenBoxes*3)+((paddingOfBox*2)*3)
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack (spacing: spaceBetweenBoxes){
                    textIcon(text: viewModel.otp1)
                    textIcon(text: viewModel.otp2)
                    textIcon(text: viewModel.otp3)
                    textIcon(text: viewModel.otp4)
                    textIcon(text: viewModel.otp5)
                    textIcon(text: viewModel.otp6)
                }
                TextField("", text: $viewModel.otpField)
                    .frame(width: textFieldOriginalWidth, height: textBoxWidth)
                    .fontWithLineHeight(font: .poppins400(size: 20), lineHeight: 20)
                    .textContentType(.oneTimeCode)
                    .foregroundColor(.clear)
                    .tint(.clear)
                    .background(Color.clear)
                    .keyboardType(.numberPad)
                    .scrollDismissesKeyboard(.interactively)
                    .onChange(of: viewModel.otpField) { _, newValue in
                        if newValue.count >= 6 {
                            codeValidationState = .valid
                        } else {
                            codeValidationState = .invalid
                        }
                    }
            }
        }.onAppear {
            codeValidationState = .invalid
        }
    }
    
    private func textIcon(text: String) -> some View {
        return HStack {
            Text(text)
                .foregroundColor(.primaryBlack)
        }
        .fontWithLineHeight(font: .poppins400(size: 20), lineHeight: 20)
        .frame(width: textBoxWidth, height: textBoxWidth)
        .background(Color.rgba(250, 250, 251, 1))
        .cornerRadius(textBoxWidth/2)
        .padding(paddingOfBox)
        .overlay(alignment: .center) {
            if text.isClean {
                Text("-")
                    .foregroundColor(.primaryBlack)
                    .fontWithLineHeight(font: .poppins400(size: 20), lineHeight: 20)
            }
        }
    }
}

struct CodeApprovalView_Previews: PreviewProvider {
    static var previews: some View {
        CodeApprovalView(codeValidationState: .constant(.valid))
    }
}
