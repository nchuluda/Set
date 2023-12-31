//
//  ContentView.swift
//  Set - VIEW
//
//  Created by Nathan on 9/13/23.
//

import SwiftUI

struct SetView: View {
    @ObservedObject var viewModel: Set
    @State private var showCompletedSets = false
    @State private var showNewGameAlert = false
    
    var cardAspectRatio: CGFloat = 2/3
    
    var body: some View {
        if !viewModel.winGame {
            VStack {
                cards
                    .padding()
                buttons
            }
        } else {
            gameOverPage
        }
    }
    
    @ViewBuilder
    var cards: some View {
        let gridItemSize = bestWidth(count: viewModel.cardsInPlay.count)
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive (minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(viewModel.cardsInPlay.indices, id: \.self) { index in
                    CardView(viewModel.cardsInPlay[index])
                        .aspectRatio(cardAspectRatio, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(viewModel.cardsInPlay[index])
                        }
                        .padding(4)
                }
            }
        }
    }
    
    @ViewBuilder
    var gameOverPage: some View {
        Text("Congratulations!").font(.largeTitle)
        Text("You've cleared the entire deck of cards!").font(.caption)
        Spacer()
        Button("New Game", action: { viewModel.newGame() })
    }
    
    @ViewBuilder
    var buttons: some View {
        HStack {
            Spacer()
            Button("New Game", action: { viewModel.newGame() })
            Spacer()
            Button("Hint", action: { viewModel.setExistsIn(cardsInPlay: viewModel.cardsInPlay) })
            Spacer()
            Button("Sets", action: { showCompletedSets.toggle() })
                .sheet(isPresented: $showCompletedSets) {
                    CompletedSetsView(viewModel: viewModel, showCompletedSets: self.$showCompletedSets)
                }
            Spacer()
            if !viewModel.deckEmpty {
                Button("Deal 3 Cards", action: { viewModel.dealThreeCards() })
            }
            Spacer()
        }
    }
    
    private func bestWidth(count: Int) -> CGFloat {
        if count <= 12 {
            return 99.0
        } else {
            return 90.0
        }
    }
}

struct CardView: View {
    var card: SetGame.Card
    
    init(_ card: SetGame.Card) { self.card = card }
    
    var body: some View {
        let base = RoundedRectangle(cornerRadius: 12)
        
        ZStack {
            
            if card.isSelected {
                base.fill(.yellow).opacity(0.1)
                base.stroke(.yellow, lineWidth: 4)
                base.stroke(.orange, lineWidth: 2)
                    .overlay(cardShape(shape: card.shape))
            } else if card.showHint {
                    base.fill(.blue).opacity(0.1)
                    base.stroke(.blue, lineWidth: 4)
                    base.stroke(.cyan, lineWidth: 2)
                        .overlay(cardShape(shape: card.shape))
            } else {
                base.fill(.white)
                base.stroke(.black, lineWidth: 2)
                    .overlay(cardShape(shape: card.shape))
            }
        }
    }
    
    @ViewBuilder
    func cardShape(shape: String) -> some View {
        GeometryReader { geo in
            switch shape {
            case "triangle":
                HStack {
                    Spacer()
                    ForEach(1...card.count, id: \.self) { _ in
                        TriangleVariant(fill: card.fill)
                            .frame(maxWidth: geo.size.width / 3, maxHeight: .infinity)
                    }
                    Spacer()
                }
            case "rectangle":
                HStack {
                    Spacer()
                    ForEach(1...card.count, id: \.self) { _ in
                        RectangleVariant(fill: card.fill)
                            .frame(maxWidth: geo.size.width / 3, maxHeight: .infinity)
                    }
                    Spacer()
                }
            case "capsule":
                HStack {
                    Spacer()
                    ForEach(1...card.count, id: \.self) { _ in
                        CapsuleVariant(fill: card.fill)
                            .frame(maxWidth: geo.size.width / 3, maxHeight: .infinity)
                    }
                    Spacer()
                }
            default:
                Text("Error: Default Shape")
            }
        }
    }
    
    @ViewBuilder
    func CapsuleVariant(fill: String) -> some View {
        switch fill {
            case "empty":
                Capsule()
                    .strokeBorder(card.color, lineWidth: 3)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(1)
            case "stripe":
                Capsule()
                    .strokeBorder(card.color, lineWidth: 3)
                    .overlay(Capsule().fill(card.color).opacity(0.5))
                    .opacity(0.5)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(1)
            case "solid":
                Capsule()
                    .strokeBorder(card.color, lineWidth: 2)
                    .overlay(Capsule().fill(card.color))
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(1)
            default:
                Text("Error: Default Capsule")
        }
    }
    
    @ViewBuilder
    func RectangleVariant(fill: String) -> some View {
        switch fill {
            case "empty":
                Rectangle()
                    .strokeBorder(card.color, lineWidth: 3)
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(.degrees(45))
                    .padding(1)
            case "stripe":
                Rectangle()
                    .strokeBorder(card.color, lineWidth: 3)
                    .overlay(Rectangle().fill(card.color).opacity(0.5))
                    .opacity(0.5)
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(.degrees(45))
                    .padding(1)
            case "solid":
                Rectangle()
                    .fill(card.color)
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(.degrees(45))
                    .padding(1)
            default:
                Text("Error: Default Rectangle")
        }
    }
    
    @ViewBuilder
    func TriangleVariant(fill: String) -> some View {
        switch fill {
            case "empty":
                Triangle()
                    .stroke(card.color, lineWidth: 3)
                    .aspectRatio(1, contentMode: .fit)
            case "stripe":
                Triangle()
                    .stroke(card.color, lineWidth: 3)
                    .overlay(Triangle().fill(card.color).opacity(0.5))
                    .opacity(0.5)
                    .aspectRatio(1, contentMode: .fit)
            case "solid":
                Triangle()
                    .fill(card.color)
                    .aspectRatio(1, contentMode: .fit)
            default:
                Text("Error: Default Triangle")
        }
    }
    
    struct Triangle: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()

            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

            return path
        }
    }
}










struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(viewModel: Set())
    }
}
