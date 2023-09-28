//
//  CompletedSetsView.swift
//  Set
//
//  Created by Nathan on 9/26/23.
//

import Foundation
import SwiftUI

struct CompletedSetsView: View {
    @ObservedObject var viewModel: Set
    @Binding var showCompletedSets: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.completedSets.indices, id: \.self) { index in
                        
//                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack{
                            Text("\(index + 1).").font(.largeTitle)
                            Spacer()
                            ForEach(viewModel.completedSets[index].cards, id: \.self) { card in
                                CardView(card)
                                    .aspectRatio(2/3, contentMode: .fit)
                                
                                    .padding(4)
                            Spacer()
                            }
                        }
                        Divider()
                    }
                }
            }
            .navigationBarTitle(Text("Completed Sets"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showCompletedSets = false
            }) {
                Text("Done").bold()
            })
        }
    }
}

//struct SheetView: View {
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        NavigationView {
//            Text("Hello")
//            .navigationBarTitle(Text("Sheet 1 Title"), displayMode: .inline)
//            .navigationBarItems(trailing: Button(action: {
//                showingPopover = false
//            }) {
//                Text("Done").bold()
//            })
//        }
//    }
//}
