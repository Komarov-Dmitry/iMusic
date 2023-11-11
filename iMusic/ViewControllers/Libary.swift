import SwiftUI
import URLImage

struct Libary: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    
    @State private var showingAlert = false
    
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    
    var body: some View {
        NavigationView {
            VStack{
                GeometryReader { geometry in
                    HStack(spacing: 20)  {
                        Button {
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                            
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(red: 232/255, green: 69/255, blue: 90/255))
                                .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                                .cornerRadius(8)
                        }
                        Button {
                            self.tracks = UserDefaults.standard.savedTracks()
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
                    ForEach(tracks) { track in
                        LibraryCell(cell: track).gesture(LongPressGesture().onEnded({ (_) in
                            print("Pressed")
                            self.track = track
                            self.showingAlert = true
                        }).simultaneously(with: TapGesture().onEnded({ (_) in
                            let keyWindow = UIApplication.shared.connectedScenes.filter({
                                $0.activationState == .foregroundActive
                            }).map({$0 as? UIWindowScene}).compactMap ({$0}).first?.windows.filter({$0.isKeyWindow}).first
                            let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                            tabBarVC?.trackDetailView.delegate = self
                            self.track = track
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                        })))
                    }.onDelete(perform: delete)
                    
                }
            }.actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(title: Text("Are you sure you want to delete this track?"), buttons: [.destructive(Text("Delete"), action: {
                    self.delete(track: self.track)
                }), .cancel()
                                                                                                 ])
            })
            .navigationBarTitle("Libary")
        }
    }
    
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        do {
            let savedData = try NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false)
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        } catch {
            print("Error archiving tracks: \(error.localizedDescription)")
        }

    }
    
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        do {
            let savedData = try NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false)
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        } catch {
            print("Error archiving tracks: \(error.localizedDescription)")
        }

    }
}



struct LibraryCell: View {
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: cell.iconUrlString ?? "")) { image in
                image
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(7)
            } placeholder: {
                // Placeholder view, пока изображение загружается
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text(cell.trackName)
                Text(cell.artistName)
            }
        }
    }
}

#Preview {
    Libary()
}


extension Libary: TrackMovingDelegate {
    func moveBackForTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var backTrack: SearchViewModel.Cell
        if myIndex - 1 == -1 {
            backTrack = tracks[tracks.count - 1]
        } else {
            backTrack = tracks[myIndex - 1]
        }
        self.track = backTrack
        return backTrack
    }
    
    func moveForwardForTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
            
        
    }
    
    
}

