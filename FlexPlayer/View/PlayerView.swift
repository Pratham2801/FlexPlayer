import SwiftUI
import Kingfisher

struct PlayerView: View {
    @StateObject private var viewModel = PlayerViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.gray.opacity(0.4), Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                ).edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Picker("Source", selection: $viewModel.currentSource) {
                        Text("Local").tag(MusicSourceType.local)
                        Text("Spotify").tag(MusicSourceType.spotify)
                        
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .onChange(of: viewModel.currentSource) { _, newSource in
                        viewModel.selectSource(newSource)
                    }

                    Spacer()

                    KFImage(viewModel.albumArtURL)
                        .placeholder {
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .aspectRatio(1.0, contentMode: .fit)
                                .cornerRadius(12)
                                .overlay(
                                    Image(systemName: "music.note")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                )
                        }
                        .retry(maxCount: 3, interval: .seconds(5))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal, 40)

                    VStack {
                        Text(viewModel.songTitle)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(viewModel.artistName)
                            .font(.headline)
                            .foregroundColor(.gray)
                    }

                    VStack(spacing: 4) {
                        Slider(value: $viewModel.progress, in: 0...1)
                            .accentColor(.white)
                        
                        HStack {
                            Text(viewModel.currentTimeText)
                            Spacer()
                            Text(viewModel.durationText)
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)

                    HStack(spacing: 40) {
                        Button(action: viewModel.skipPreviousTapped) {
                            Image(systemName: "backward.fill").font(.largeTitle)
                        }
                        
                        Button(action: viewModel.playPauseTapped) {
                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 60))
                        }
                        
                        Button(action: viewModel.skipNextTapped) {
                            Image(systemName: "forward.fill").font(.largeTitle)
                        }
                    }
                    .foregroundColor(.white)

                    Spacer()

                    List {
                        ForEach(viewModel.songQueue) { song in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(song.title).foregroundColor(.white)
                                    Text(song.artist).font(.caption).foregroundColor(.gray)
                                }
                                Spacer()
                                if playerService.currentSong?.id == song.id && viewModel.isPlaying {
                                    Image(systemName: "waveform")
                                        .foregroundColor(.green)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.playSong(song)
                            }
                        }
                        .onDelete(perform: viewModel.deleteSong)
                        .onMove(perform: viewModel.moveSong)
                        .listRowBackground(Color.white.opacity(0.1))
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 200)
                }
                .padding(.vertical)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                viewModel.selectSource(.local)
            }
        }
    }

    private var playerService: MusicPlayerService {
        MusicPlayerService.shared
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
