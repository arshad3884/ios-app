//
//  CostInfoSheetView.swift
//  Troov
//
//  Created by Levon Arakelyan on 03.10.23.
//

import SwiftUI

struct CostInfoSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    private let costInfo: [Info] = Info.info

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            ZStack {
                Color(red: 0.91, green: 0.92, blue: 0.93)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                Image("t.info")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.primaryTroovColor)
                    .frame(width: 60, height: 60)
            }
            Text("Please refer to chart below to get to know what number of “$” icons mean:")
                .frame(maxWidth: .infinity, alignment: .top)
                .multilineTextAlignment(.center)
            ForEach(costInfo, id: \.id) { info in
                CostInfoRow(info: info)
            }
            Button(action: { dismiss() },
                   label: {
                TPrimaryLabel(text: "Okay", height: 56)
            })
        }
        .fontWithLineHeight(font: .poppins400(size: 16), lineHeight: 16)
        .padding(.horizontal, 36.relative(to: .width))
    }
}

#Preview {
    CostInfoSheetView()
}


extension CostInfoSheetView {
    struct Info: Equatable {
        let id = UUID().uuidString
        var selectedTags: [String]
    
        static func == (lhs: Info, rhs: Info) -> Bool {
            return lhs.selectedTags == rhs.selectedTags && lhs.id == rhs.id
        }
    }
}


extension CostInfoSheetView.Info {
    static var info: [CostInfoSheetView.Info] {
        [
            CostInfoSheetView.Info(selectedTags: ["0"]),
            CostInfoSheetView.Info(selectedTags: ["0", "1"]),
            CostInfoSheetView.Info(selectedTags: ["0", "1", "2"]),
            CostInfoSheetView.Info(selectedTags: ["0", "1", "2", "3"])
        ]
    }

    var price: String {
        if selectedTags.count < 1 {
            return ExpenseRating.free.priceRangeBareText
        } else if selectedTags.count == 1 {
            return ExpenseRating.dollar.priceRangeBareText
        } else if selectedTags.count == 2 {
            return ExpenseRating.dollarDollar.priceRangeBareText
        } else if selectedTags.count == 3 {
            return ExpenseRating.dollarDollarDollar.priceRangeBareText
        } else {
            return ExpenseRating.dollarDollarDollarDollar.priceRangeBareText
        }
    }
    
    var expenseRating: ExpenseRating {
        if selectedTags.count < 1 {
            return ExpenseRating.free
        } else if selectedTags.count == 1 {
            return ExpenseRating.dollar
        } else if selectedTags.count == 2 {
            return ExpenseRating.dollarDollar
        } else if selectedTags.count == 3 {
            return ExpenseRating.dollarDollarDollar
        } else {
            return ExpenseRating.dollarDollarDollarDollar
        }
    }
}

extension ExpenseRating {
    var costInfo: CostInfoSheetView.Info? {
        let selectedTags: [String]?
        switch self {
        case .free:
            selectedTags = nil
        case .dollar:
            selectedTags = ["0"]
        case .dollarDollar:
            selectedTags = ["0", "1"]
        case .dollarDollarDollar:
            selectedTags = ["0", "1", "2"]
        case .dollarDollarDollarDollar:
            selectedTags = ["0", "1", "2", "3"]
        }
        if let selectedTags = selectedTags {
            return .init(selectedTags: selectedTags)
        }
        return nil
    }
}
