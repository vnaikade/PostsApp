//
//  PostListView.swift
//  TechieButlerApp
//


import SwiftUI

struct PostListView: View {

    @ObservedObject var viewModel = PostsViewModel()
    let numberOfColumns: Double = 3
    let spaceBetweenColumns: Double = 5
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - ((numberOfColumns - 1) * spaceBetweenColumns)) / numberOfColumns
            NavigationStack {
                ZStack {
                    List {
                            ForEach(viewModel.posts, id: \.id) { article in
                                NavigationLink(destination: PostDetails(article: article), label: {
                                    VStack(alignment: .leading) {
                                        Text(article.title)
                                            .font(.headline.weight(.bold))
                                            .lineLimit(2)
                                        Text(article.body)
                                            .font(.subheadline)
                                            .lineLimit(2)
                                            .foregroundStyle(Color.gray)
                                    }
                                })
                            }
                        }
                    .listStyle(.plain)
                    
                    ZStack {
                        if let error = viewModel.error {
                            ErrorView(errorTitle: error.localizedDescription , viewModel: viewModel)
                        }
                    }
                }
                .padding(.all, 0)
                .navigationTitle(String(localized:"\(viewModel.posts.count)"))
                .navigationBarTitleDisplayMode(.inline)
            }
        })
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}


struct PostDetails: View {
    
    let article: Post
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.largeTitle.bold())
                    .padding(.top)
                Text(article.body)
                    .font(.caption)
                    .padding(.top)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .navigationTitle(String(localized: "Details"))
        })
    }
}
