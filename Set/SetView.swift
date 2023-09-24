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
            
            if !viewModel.deckEmpty {
                Button("Deal 3 More Cards", action: { viewModel.dealThreeCards() })
            }
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
//    var cards: some View {
//        LazyVGrid(columns: [GridItem(.adaptive (minimum: 85))]) {
//            ForEach(viewModel.cardsInPlay) { card in
//                CardView(card)
//                    .aspectRatio(2/3, contentMode: .fit)
//                    .onTapGesture {
//                        viewModel.choose(card)
//                    }
//            }
//        }
//    }
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
                switch card.shape {
                case "triangle":
                    HStack {
                        ForEach(1...card.count, id: \.self) { _ in TriangleView() }
                    }
                case "rectangle":
                    HStack {
                        ForEach(1...card.count, id: \.self) { _ in RectangleView() }
                    }
                case "capsule":
                    HStack {
                        ForEach(1...card.count, id: \.self) { _ in CapsuleView() }
                    }
                default:
                    Text("Default")
                }
            } else {
                base.fill(.white)
                base.stroke(.black, lineWidth: 2)
                
                switch card.shape {
                    case "triangle":
                        HStack {
                            ForEach(1...card.count, id: \.self) { _ in TriangleView() }
                        }
                    case "rectangle":
                        HStack {
                            ForEach(1...card.count, id: \.self) { _ in RectangleView() }
                        }
                    case "capsule":
                        HStack {
                            ForEach(1...card.count, id: \.self) { _ in CapsuleView() }
                        }
                    default:
                        Text("Default")
                }
            }
        }
    }
    
    func CapsuleView() -> some View {
        if card.fill == "empty" {
            return(AnyView(
                Capsule()
                    .strokeBorder(card.color, lineWidth: 5)
                    .frame(width: 20, height: 40)
            ))
        } else if card.fill == "stripe" {
            return(AnyView(
                Capsule()
                    .strokeBorder(card.color, lineWidth: 5)
                    .overlay(Capsule().fill(card.color).opacity(0.5))
                    .opacity(0.5)
                    .frame(width: 25, height: 40)
            ))
        } else {
            return(AnyView(
                Capsule()
                    .strokeBorder(card.color, lineWidth: 5)
                    .overlay(Capsule().fill(card.color))
                    .frame(width: 25, height: 40)
            ))
        }
    }
    
    func RectangleView() -> some View {
        if card.fill == "empty" {
            return(AnyView(
                Rectangle()
                    .strokeBorder(card.color, lineWidth: 5)
                    .frame(width: 25, height: 25)
                    .rotationEffect(.degrees(45))
                    .padding(2)
            ))
        } else if card.fill == "stripe" {
            return(AnyView(
                Rectangle()
                    .strokeBorder(card.color, lineWidth: 5)
                    .overlay(Rectangle().fill(card.color).opacity(0.5))
                    .opacity(0.5)
                    .frame(width: 25, height: 25)
                    .rotationEffect(.degrees(45))
                    .padding(2)
            ))
        } else {
            return(AnyView(
                Rectangle()
                    .fill(card.color)
                    .frame(width: 25, height: 25)
                    .rotationEffect(.degrees(45))
                    .padding(2)
            ))
        }
    }
    
    func TriangleView() -> some View {
        if card.fill == "empty" {
            return(AnyView(
                Triangle()
                    .stroke(card.color, lineWidth: 5)
                    .frame(width: 25, height: 25)
            ))
        } else if card.fill == "stripe" {
            return(AnyView(
                Triangle()
                    .stroke(card.color, lineWidth: 5)
                    .overlay(Triangle().fill(card.color).opacity(0.5))
                    .opacity(0.5)
                    .frame(width: 25, height: 25)
            ))
        } else {
            return(AnyView(
                Triangle()
                    .fill(card.color)
                    .frame(width: 25, height: 25)
            ))
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
