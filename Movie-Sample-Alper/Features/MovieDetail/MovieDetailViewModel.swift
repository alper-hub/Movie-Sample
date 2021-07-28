import Foundation

protocol MovieDetailViewModelDelegate: AnyObject {
    func showMovieDetails(model: MovieDetailModel?)
    func showFail(error: Error?)
    func setFavouriteMovieStar(isFavourite: Bool)
}

protocol MovieDetailViewModelProtocol: AnyObject {
    var isFavorite: Bool {get}
    var cellIndex: IndexPath? {get set}
    var currentMovieId: Int {get set}
    
    func presentMovieDetails(model: MovieDetailModel?)
    func presentFail(error: Error?)
    func fetchMovieDetails(movieId: Int)
    func addToFavouriteMovies()
    func removeFromFavouriteMovies()
    func checkIsFavoriteMovie()
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {

    // MARK: - Dependencies
    weak var delegate: MovieDetailViewModelDelegate?
    var isFavorite: Bool
    var favoriteMovies: [Int]
    var movieDetailModel: MovieDetailModel?
    var cellIndex: IndexPath?
    var currentMovieId: Int
    let defaults = UserDefaults.standard

    // MARK: - Init
    
    init(delegate: MovieDetailViewModelDelegate?, currentId: Int) {
        self.delegate = delegate
        isFavorite = false
        favoriteMovies = []
        movieDetailModel = MovieDetailModel()
        cellIndex = IndexPath()
        currentMovieId = currentId
        if let savedFavoriteMovies = defaults.array(forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey) as? [Int] {
            favoriteMovies = savedFavoriteMovies
        }
        checkIsFavoriteMovie()
    }

    func presentMovieDetails(model: MovieDetailModel?) {
        movieDetailModel = model
        checkIsFavoriteMovie()
        delegate?.showMovieDetails(model: model)
    }
    
    func presentFail(error: Error?) {
        delegate?.showFail(error: error)
    }
    
    func addToFavouriteMovies() {
        
        favoriteMovies.append(movieDetailModel?.movieId ?? 0)
        defaults.set(favoriteMovies, forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
        isFavorite = true
    }
    
    func removeFromFavouriteMovies() {

        if let index = favoriteMovies.firstIndex(of: movieDetailModel?.movieId ?? 0) {
            favoriteMovies.remove(at: index)
            defaults.set(favoriteMovies, forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
        }
        isFavorite = false
    }
    
    func checkIsFavoriteMovie() {
        for movieID in favoriteMovies {
            if movieID == self.currentMovieId {
                isFavorite = true
                delegate?.setFavouriteMovieStar(isFavourite: true)
            }
        }
    }
    
    func fetchMovieDetails(movieId: Int) {
        if let url = URL(string: NetworkConstants.baseUrl + NetworkConstants.movieEndpoint + "/" + String(movieId) + NetworkConstants.languageEndPoint + NetworkConstants.englishUs + NetworkConstants.apiKeyEndPoint + NetworkConstants.apiKey) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        
                        let parsedMovieListModel = try jsonDecoder.decode(MovieDetailModel.self, from: data)
                        self.presentMovieDetails(model: parsedMovieListModel)
                        
                    } catch {
                        self.presentFail(error: error)
                    }
                }
                if let networkError = error {
                    self.presentFail(error: networkError)
                }
            }.resume()
        }
    }
}
