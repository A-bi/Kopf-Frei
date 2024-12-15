//
//  Main.swift
//  Kopf Frei
//
//  Created by Alice Laquerriere on 15.12.24.
//
import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrundfarbe (hellgrau)
                Color(red: 232/255, green: 232/255, blue: 232/255)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Titel
                    Text("Willkommen zu KopfFrei")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.2)) // Dunkelgrau
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Beschreibung
                    Text("Diese App hilft Ihnen dabei, Ihre Herausforderungen besser zu verstehen und neue Perspektiven zu entdecken.")
                        .font(.body)
                        .foregroundColor(Color.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Scrollmenü
                    AppMenu()
                    
                    // Start-Button mit NavigationLink zu ContentView
                    NavigationLink(destination: ContentView()) {
                        Text("Starten")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 34/255, green: 193/255, blue: 195/255), // Türkis
                                    Color(red: 253/255, green: 187/255, blue: 45/255)   // Gelb/Orange
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                }
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
            .navigationTitle("Hauptmenü")
        }
        .navigationViewStyle(StackNavigationViewStyle()) // iPad-Optimierung
    }
}

struct AppMenu: View {
    @State private var expandedItem: String? = nil
    
    let menuItems: [MenuItem] = [
        MenuItem(
            title: "Wie die App funktioniert",
            symbol: "questionmark.circle",
            description: """
                Viele Menschen haben Schwierigkeiten, ihre Probleme klar zu analysieren. 
                Diese Fragen helfen dabei, neue Sichtweisen zu finden und Muster zu erkennen.
                
                Die App kann Klient*innen dabei unterstützen, sich schon vor einer Coaching-Sitzung vorzubereiten oder zwischen den Terminen an ihren Themen zu arbeiten.
                """
        ),
        MenuItem(
            title: "Copyright",
            symbol: "c.circle",
            description: "Diese App unterliegt dem Urheberrecht. Alle Rechte vorbehalten."
        ),
        MenuItem(
            title: "Impressum",
            symbol: "doc.text",
            description: "Für Anne. Bei Problemen oder Fragen bitte an den Developer wenden: A-Bi(github)"
        ),
        MenuItem(
            title: "Hilfreiche Links",
            symbol: "link",
            description: """
                - [OpenAI](https://openai.com)
                - [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
                - Weitere Links folgen in Kürze.
                """
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(menuItems) { item in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: item.symbol)
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 219/255, green: 236/255, blue: 236/255)) // Hellblau/Grün
                            
                            Text(item.title)
                                .font(.headline)
                                .foregroundColor(Color.black.opacity(0.7))
                            
                            Spacer()
                            
                            // Ausklapp-Button
                            Button(action: {
                                withAnimation {
                                    if expandedItem == item.title {
                                        expandedItem = nil
                                    } else {
                                        expandedItem = item.title
                                    }
                                }
                            }) {
                                Image(systemName: expandedItem == item.title ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Beschreibung wird angezeigt, wenn ausgeklappt
                        if expandedItem == item.title {
                            Text(item.description)
                                .font(.body)
                                .foregroundColor(Color.black.opacity(0.6))
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 10)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                }
            }
            .padding()
        }
    }
}

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let symbol: String
    let description: String
}

struct HoneycombView: View {
    var body: some View {
        Text("Hier erscheint die Honeycomb-Ansicht")
            .font(.headline)
            .navigationTitle("Honeycomb")
    }
}

// Vorschau für MainView
struct HoneycombView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
