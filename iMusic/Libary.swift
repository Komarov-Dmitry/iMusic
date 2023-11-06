

import SwiftUI

struct Libary: View {
    var body: some View {
        NavigationView {
            VStack{
                GeometryReader { geometry in
                    HStack(spacing: 20)  {
                        Button {
                            print("12345")
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(red: 232/255, green: 69/255, blue: 90/255))
                                .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                                .cornerRadius(8)
                        }
                        Button {
                            print("4321")
                        } label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(red: 232/255, green: 69/255, blue: 90/255))
                                .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                                .cornerRadius(8)
                        }
                    }
                }.padding().frame(height: 65)
                Divider().padding(.leading).padding(.trailing)
                List {
                    LibaryCell()
                }
            }
            .navigationBarTitle("Libary")
        }
    }
}


struct LibaryCell: View {
    var body: some View {
        HStack {
            Image("Image").resizable().frame(width: 60, height: 60).cornerRadius(7)
            VStack {
                Text("Track name")
                Text("Artist name")
            }
        }

    }
}

#Preview {
    Libary()
}
