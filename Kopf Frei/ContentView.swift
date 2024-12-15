//
//  Honeycomb.swift
//  Kopf Frei
//
//  Created by Alice Laquerriere on 15.12.24.
//
import SwiftUI

// Datenmodell für Hexagon-Inhalte
struct HexagonContent: Identifiable {
    let id = UUID()
    let title: String
    let symbol: String
    let description: String
    let imageName: String
}

// Erweiterung für sicheres Array-Zugreifen
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// Die Honeycomb-Ansicht
struct Honeycomb: View {
    private let dimension: Int
    private let cellSideLength: CGFloat
    private let cellHeight: CGFloat
    private let cellWidth: CGFloat

    let hexagonContents: [HexagonContent]

    @State private var selectedContent: HexagonContent? = nil

    init(dimension: Int = 6, cellSideLength: CGFloat = 50, hexagonContents: [HexagonContent]) {
        self.dimension = dimension
        self.cellSideLength = cellSideLength
        self.cellHeight = cellSideLength * 2
        self.cellWidth = 2 * ((cellSideLength * cellSideLength) - ((cellSideLength / 2) * (cellSideLength / 2))).squareRoot()
        self.hexagonContents = hexagonContents
    }

    private func aCell(content: HexagonContent) -> some View {
        Hexagon()
            .foregroundColor(Color(red: 0.6, green: 0.8, blue: 0.7)) // Farbpalette angepasst
            .frame(width: cellWidth, height: cellHeight)
            .overlay {
                VStack {
                    Image(systemName: content.symbol)
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.2))
                    Text(content.title)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)

                }
            }
            .overlay {
                Hexagon()
                    .stroke(Color(red: 0.5, green: 0.7, blue: 0.6), lineWidth: 2)

            }
            .shadow(color: Color(red: 0.4, green: 0.6, blue: 0.5), radius: 5, x: 0, y: 5)
            .onTapGesture {
                withAnimation {
                    selectedContent = content
                }
            }
    }

    var body: some View {
        ZStack {
            ScrollView([.vertical, .horizontal]) {
                VStack(spacing: cellHeight / 2) {
                    ForEach(0..<(dimension + 1) / 2, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<dimension, id: \.self) { col in
                                let index = col + row * dimension
                                if let content = hexagonContents[safe: index] {
                                    aCell(content: content)
                                }
                            }
                        }
                        .offset(x: row % 2 == 0 ? 0 : cellWidth / 2)
                    }
                }
            }

            if let content = selectedContent {
                DetailView(content: content) {
                    withAnimation {
                        selectedContent = nil
                    }
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}

// Detailansicht für Hexagon-Inhalte
struct DetailView: View {
    let content: HexagonContent
    let onClose: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(content.title)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()

                Image(content.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()

                Text(content.description)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding()

                Button("Schließen") {
                    onClose()
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(color: Color(UIColor.secondaryLabel), radius: 5, x: 0, y: 5)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

// Hexagon-Form
struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.size.width, rect.size.height) / 2
        let angleOffset = CGFloat.pi / 6
        for i in 0..<6 {
            let angle = CGFloat(i) * CGFloat.pi / 3 + angleOffset
            let point = CGPoint(x: center.x + cos(angle) * size, y: center.y + sin(angle) * size)
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

// Hauptansicht ContentView
    struct ContentView: View {
        let hexagonContents: [HexagonContent] = [
            HexagonContent(
                title: "Stress",
                symbol: "flame.fill",
                description: "Aktivieren Sie den dorsalen Vagus. Gehen Sie eine Runde spazieren oder gönnen Sie sich eine Auszeit.",
                imageName: "Stress.png"
            ),
            HexagonContent(
                title: "Selbstzweifel",
                symbol: "questionmark.circle.fill",
                description: "Was glauben Sie über sich selbst, wenn Sie Selbstzweifel haben?\n\nWas wollen Ihnen die Selbstzweifel mitteilen?\n\nWas würde Ihnen eine nahe stehende Person sagen zu den Selbstzweifeln?\n\nWelche Erwartungen haben Sie an sich selbst?\n\nWie würde Ihr Leben aussehen, wenn Sie sich selbst die Chance geben, sich mehr zuzutrauen?",
                imageName: "hope"
            ),
            HexagonContent(
                title: "Überforderung",
                symbol: "cloud.fill",
                description: "Was genau überfordert Sie zurzeit?\n\nIst es die Arbeitsmenge, die Erwartungen an sich selbst oder die Erwartungen von anderen?\n\nWelche Stärken können Sie einsetzen, um Ihre Überforderung zu bewältigen?\n\nWie viel von der Belastung ist real, und was entsteht vielleicht durch Erwartungen, die Sie an sich selbst stellen?\n\nWas können Sie delegieren oder reduzieren?\n\nWelche Aufgaben oder Projekte würden Ihnen wieder Energie und Freude geben?",
                imageName: "calm"
            ),
            HexagonContent(
                title: "Karriereweg",
                symbol: "briefcase.fill",
                description: "Wie definieren Sie Erfolg für sich?\n\nWelche Werte sind Ihnen an Ihrere Karriere wichtig?\n\nWo möchten sie in 10 Jahren stehen?\n\nWelchen Weg würden Sie spontan gehen?\n\nWelche Stärken und Talente bringen Sie mit, die sie auf ihrem Karriereweg unterstützen würden?\n\nWann und wie möchten Sie eine Entscheidung treffen?",
                imageName: "decision.tree"
            ),
            HexagonContent(
                title: "'Nein' sagen",
                symbol: "hand.raised.fill",
                description: "Was brauchen Sie, um sich wohl und respektiert zu werden?\n\nWo sind klare Grenzen und wie kommunizieren Sie sie?\n\nWelche Werte möchten Sie schützen?\n\nWie würde es sich anfühlen wenn sie eine Grenze ziehen?\n\nWie würde ihr Arbeitgerber*in/Kolleg*in reagieren wenn Sie eine Grenze ziehen?",
                imageName: "No"
            ),
            HexagonContent(
                title: "Bedürfnisse",
                symbol: "heart.fill",
                description: "Welche Bedürfnisse haben Sie und welche werden zurzeit nicht erfüllt?\n\nWann und in welcher Situation ignorieren sie ihre Bedürfnisse?\n\nWie empfinden sie ihre Bedürfnisse genau?\n\nWas befürchrten Sie wenn Sie ihre Bedürfnisse beachten?\n\nWas würde sich verändern, wenn Sie ihre Bedürfnisse ernst nehmen würden?\n\nWelche Grenzen können Sie setzten, um ihre Bedürfnisse zu erfüllen?\n\nWelche Signale ihres Körpers könnten Sie ernster nehmen?\n\nWie haben Sie es das letzte Mal geschafft ihre Bedürfnisse wahr zu nehmen und wie könnten sie das wiederholen?",
                imageName: "Bedürfnispyramide.png"
            ),
            HexagonContent(
                title: "Doktorarbeit",
                symbol: "graduationcap.fill",
                description: "Lektüre: Titel: Survival Guide Wissenschaft: (Über-)Lebenstipps für akademische Karrieren ,Autoren: Kai Noeske, Benjamin Rott, Katrin Hille, Verlag: Springer Berlin, Heidelberg, Erscheinungsjahr: 2023, ISBN: 978-3-662-67796-4 (Print)\n\nWas müsste passieren, dass ihre Doktorarbeit für sie erfüllend ist?\n\nWelche Stärken haben Ihnen bisher geholfen mit ihrer Doktorarbeit weiter zu  machen?\n\nWas würden sie als Abbruchkriterien für sich definieren?\n\nGibt es äußere Erwartungen, die sie blockieren?\n\nWelche Ideen oder Lösungen haben Sie bisher vielleicht ausgeschlossen?\n\nWelche Bedeutung hat sie für Ihre berufliche oder persönliche Entwicklung?",
                imageName: "Doktorhut.png"
            ),
        ]
        var body: some View {
                NavigationView {
                    Honeycomb(dimension: 3, hexagonContents: hexagonContents)
                        .navigationTitle("Themenübersicht")
                }
            }
        }

        // Vorschau
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
