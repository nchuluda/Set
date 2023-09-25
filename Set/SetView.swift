//
//  ContentView.swift
//  Set - VIEW
//
//  Created by Nathan on 9/13/23.
//

import SwiftUI

struct SetView: View {
    @ObservedObject var viewModel: Set
    
    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            .padding()
            HStack {
                Button("New Game", action: { viewModel.newGame() })
                if !viewModel.deckEmpty {
                    Button("Deal 3 Cards", action: { viewModel.dealThreeCards() })
                }
            }
//            .padding()
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive (minimum: 85))]) {
            ForEach(viewModel.cardsInPlay.indices, id: \.self) { index in
                CardView(viewModel.cardsInPlay[index])
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        viewModel.choose(viewModel.cardsInPlay[index])
                    }
            }
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
                base.fill(.white)
                base.stroke(.yellow, lineWidth: 4)
                base.stroke(.orange, lineWidth: 2)
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
                        TriangleView(fill: card.fill)
                            .frame(maxWidth: geo.size.width / 3, maxHeight: .infinity)
                    }
                    Spacer()
                }
            case "rectangle":
                HStack {
                    Spacer()
                    ForEach(1...card.count, id: \.self) { _ in
                        RectangleView(fill: card.fill)
                            .frame(maxWidth: geo.size.width / 3, maxHeight: .infinity)
                    }
                    Spacer()
                }
            case "capsule":
                HStack {
                    Spacer()
                    ForEach(1...card.count, id: \.self) { _ in
                        CapsuleView(fill: card.fill)
                            .frame(maxWidth: geo.size.width / 3, maxHeight: .infinity)
                    }
                    Spacer()
                }
            default:
                Text("Default")
            }
        }
    }
    
    @ViewBuilder
    func CapsuleView(fill: String) -> some View {
        switch fill {
            case "empty":
                Capsule()
                    .strokeBorder(card.color, lineWidth: 5)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(2)
            case "stripe":
                Capsule()
                    .strokeBorder(card.color, lineWidth: 5)
                    .overlay(Capsule().fill(card.color).opacity(0.5))
                    .opacity(0.5)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(2)
            case "solid":
                Capsule()
                    .strokeBorder(card.color, lineWidth: 5)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(2)
            default:
                Text("Error: Default Capsule")
        }
    }
    
    @ViewBuilder
    func RectangleView(fill: String) -> some View {
        switch fill {
            case "empty":
                Rectangle()
                    .strokeBorder(card.color, lineWidth: 5)
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(.degrees(45))
                    .padding(2)
            case "stripe":
                Rectangle()
                    .strokeBorder(card.color, lineWidth: 5)
                    .overlay(Rectangle().fill(card.color).opacity(0.5))
                    .opacity(0.5)
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(.degrees(45))
                    .padding(2)
            case "solid":
                Rectangle()
                    .fill(card.color)
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(.degrees(45))
                    .padding(2)
            default:
                Text("Error: Default Rectangle")
        }
    }
    
    @ViewBuilder
    func TriangleView(fill: String) -> some View {
        switch fill {
            case "empty":
                Triangle()
                    .stroke(card.color, lineWidth: 5)
                    .aspectRatio(1, contentMode: .fit)
            case "stripe":
                Triangle()
                    .stroke(card.color, lineWidth: 5)
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
