//
//  ValidatorView.swift
//  Troov
//
//  Created by Levon Arakelyan on 08.10.23.
//

import SwiftUI

struct ValidatorView<B: Comparable & BinaryInteger,
                     F: Comparable & FloatingPoint>: View {
    var input: Input
    var output: ((ValidationState) -> ())?
    var action: ((ValidatorViewAction) -> ())?
    
    @State private var validStateOpacity = 1.0
    
    private var state: ValidationState {
        do {
            switch input {
            case .string(let value, let rule):
                if value.isEmpty {
                    return .missing
                }
                var rule = rule
                if var pattern = rule.pattern {
                    pattern = "\(pattern.dropFirst())"
                    pattern = "\(pattern.dropLast())"
                    rule.pattern = pattern
                }

                let _ = try Validator.validate(value,
                                               against: rule)
            case .binary(let value, let rule):
                let _ = try Validator.validate(value,
                                                  against: rule)
            case .floating(let value, let rule):
                let _ = try Validator.validate(value,
                                                  against: rule)
            }
            return .valid
        } catch {
            return .invalid
        }
    }
    
    var body: some View {
        VStack {
            switch state {
            case .missing:
                Image(systemName: "circle")
                    .foregroundStyle(Color.primaryTroovChatOrange)
                    .opacity(0)
                /**
                 L.A.
                 I'm hiding this part temporarely, since probably we're going
                 to return back to this later
                 */
            case .valid:
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(Color.primaryTroovColor)
                    .onAppear(perform: validAnimationOnAppear)
                    .onDisappear {
                        validStateOpacity = 0.0
                    }.opacity(validStateOpacity)
            case .invalid:
                Button(action: { action?(.cleanup) }) {
                    Image(systemName: "x.circle")
                        .foregroundStyle(Color.primaryTroovRed)
                }
            }
        }.onChange(of: state, { _, newValue in
            update(newValue)
        })
        .onAppear { update(state) }
    }

    private func validAnimationOnAppear() {
        if validStateOpacity != 1 {
            withAnimation(.easeInOut(duration: 0.2)) {
                validStateOpacity = 1
            }
            withAnimation(.easeInOut(duration: 1).delay(0.4)) {
                validStateOpacity = 0
            }
        } else {
            withAnimation(.easeInOut(duration: 1)) {
                validStateOpacity = 0
            }
        }
    }

    private func update(_ state: ValidationState) {
        DispatchQueue.main.async {
            output?(state)
        }
    }
}

#Preview {
    ValidatorView<Int, Float>(input: .string(input: "", rule: .init()))
}

extension ValidatorView {
    enum Input {
        case string(input: String, rule: StringRule)
        case binary(input: B, rule: NumericRule<B>)
        case floating(input: F, rule: NumericRule<F>)
    }
}

enum ValidationState {
    case missing
    case valid
    case invalid
}

enum ValidatorViewAction {
    case cleanup
}

