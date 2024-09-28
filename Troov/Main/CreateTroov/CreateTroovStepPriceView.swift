//
//  CreateTroovStepPriceView.swift
//  Troov
//
//  Created by Levon Arakelyan on 15.09.23.
//

import SwiftUI

struct CreateTroovStepPriceView: View, KeyboardReadable {
    @Environment(CreateTroovViewModel.self) var viewModel
    @FocusState private var isFocused: Bool

    @State private var details: String = ""
    @State private var selectedRating: ExpenseRating?
    @State private var detailsIsValid: ValidationState = .missing
    @State private var priceIsValid: ValidationState = .missing

    private var ratings: [ExpenseRating] {
        ExpenseRating.allCases
    }

    private var troov: Troov? {
        viewModel.troov
    }
    
    var body: some View {
        VStack(alignment: .center,
               spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                TextField("",
                          text: $details,
                          prompt: Text("Enter any additional details about your troov here...")
                    .foregroundStyle(Color.textFieldForeground), axis: .vertical)
                .focused($isFocused)
                .keyboardType(.asciiCapable)
                .lineLimit(5...8)
                .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 21)
                .padding(20.relative(to: .height))
            }
            .frame(maxWidth: .infinity)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 16).stroke(isFocused ? .primaryTroovColor : Color.overlayGray, lineWidth: 1)
            })
            .overlay(alignment: .topTrailing) {
                ValidatorView<Int, Float>(input: .string(input: details,
                                                         rule: TroovCoreDetails.detailsRule),
                                          output: checkDetailsValidate(_:))
                    .padding(20.relative(to: .height))
            }.softAttentionAnimation(triggerAttention: viewModel.triggerValidationAttention,
                                     ceaseAnimation: isFocused,
                                     background: .roundedRectangle(radius: 16))
            HStack {
                Spacer()
                Text("\(details.count)/\(TroovCoreDetails.detailsRule.maxLength ?? 65)")
                    .fontWithLineHeight(font: .poppins400(size: 14), lineHeight: 18)
                    .foregroundColor(.rgba(167, 175, 184, 1))
            }.padding(.top, 12.relative(to: .height))
            HStack {
                Text("How much will this troov cost the other person?")
                    .fontWithLineHeight(font: .poppins500(size: 14), lineHeight: 14)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .foregroundColor(.rgba(33, 33, 33, 1))
                Spacer()
            }
            .padding(.top, 22.relative(to: .height))
            .padding(.horizontal, 14.relative(to: .width))
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10.relative(to: .height), content: {
                    ForEach(ratings, id: \.id) { rating in
                        Button { select(rating) } label: {
                            if selectedRating == rating {
                                TSecondaryLabel(text: rating.priceRangeText,
                                                isFilled: true)
                            } else {
                                TTertiaryLabel(text: rating.priceRangeText)
                            }
                        }.buttonStyle(.scalable)
                            .padding(1)
                    }
                })
            }.padding(.horizontal, 14.relative(to: .width))
                .padding(.top, 10.relative(to: .height))
        }.onAppear(perform: appear)
         .onDisappear(perform: disappear)
         .onChange(of: selectedRating, { _, newValue in
             checkPriceValidity(newValue)
         })
    }
    
    
    private func appear() {
        selectedRating = troov?.troovCoreDetails?.expenseRating
        details = troov?.troovCoreDetails?.details ?? ""
        checkPriceValidity(selectedRating)
    }
    
    private func disappear() {
        viewModel.save(rating: selectedRating, and: details)
    }
    
    private func select(_ rating: ExpenseRating) {
        endEditing()
        withAnimation {
            if rating == selectedRating {
                selectedRating = nil
            } else {
                selectedRating = rating
            }
        }
    }

    private func checkDetailsValidate(_ state: ValidationState) {
        detailsIsValid = state
        checkValidity()
    }

    private func checkPriceValidity(_ price: ExpenseRating?) {
        if price == nil {
            priceIsValid = .missing
        } else {
            priceIsValid = .valid
        }
        checkValidity()
    }

    private func checkValidity() {
        if priceIsValid == .valid &&
            detailsIsValid == .valid {
            viewModel.validate(.valid)
        } else {
            viewModel.validate(.missing)
        }
    }
}

struct CreateTroovStepPriceView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTroovStepPriceView()
    }
}
