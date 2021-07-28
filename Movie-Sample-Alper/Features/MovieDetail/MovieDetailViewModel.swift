import Foundation

protocol MovieDetailViewModelDelegate: AnyObject {
    
    func showMovieDetails(model: MovieDetailModel?)
    func showFail(error: Error?)
    func changeRatingStar(isFavorite: Bool)
}

protocol MovieDetailViewModelProtocol: AnyObject {
    
    var isFavorite: Bool { get }
    var cellIndex: IndexPath? { get set }
    var currentMovieId: Int { get set }
    var finalLikeState: Bool { get set }
    var initialLikeState: Bool { get set }
    
    func presentMovieDetails(model: MovieDetailModel?)
    func presentFail(error: Error?)
    func fetchMovieDetails()
    func addToFavouriteMovies()
    func removeFromFavouriteMovies()
    func checkIsFavoriteMovie()
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {

    // MARK: - Dependencies
    weak var delegate: MovieDetailViewModelDelegate?
    
    // MARK: - Variables

    let defaults = UserDefaults.standard
    
    private var favoriteMovies: [Int]
    private var movieDetailModel: MovieDetailModel?
    var initialLikeState: Bool
    var finalLikeState: Bool
    var isFavorite: Bool
    var cellIndex: IndexPath?
    var currentMovieId: Int
    
    // MARK: - Init
    
    init(delegate: MovieDetailViewModelDelegate?, currentId: Int, cellIndexPath: IndexPath) {
        self.delegate = delegate
        isFavorite = false
        initialLikeState = false
        finalLikeState = false
        favoriteMovies = []
        movieDetailModel = MovieDetailModel()
        cellIndex = cellIndexPath
        currentMovieId = currentId
        checkIsFavoriteMovie()
    }

    func presentMovieDetails(model: MovieDetailModel?) {
        movieDetailModel = model
        delegate?.showMovieDetails(model: model)
    }
    
    func presentFail(error: Error?) {
        delegate?.showFail(error: error)
    }
    
    func addToFavouriteMovies() {
        favoriteMovies.append(movieDetailModel?.movieId ?? 0)
        defaults.set(favoriteMovies, forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
        isFavorite = true
        delegate?.changeRatingStar(isFavorite: isFavorite)
    }
    
    func removeFromFavouriteMovies() {
        if let index = favoriteMovies.firstIndex(of: movieDetailModel?.movieId ?? 0) {
            favoriteMovies.remove(at: index)
            defaults.set(favoriteMovies,
                         forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
        }
        isFavorite = false
        delegate?.changeRatingStar(isFavorite: isFavorite)
    }
    
    func checkIsFavoriteMovie() {
        if let savedFavoriteMovies = defaults.array(forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey) as? [Int] {
            favoriteMovies = savedFavoriteMovies
        }
        
        for savedMovieID in favoriteMovies {
            if savedMovieID == self.currentMovieId {
                isFavorite = true
                initialLikeState = isFavorite
            }
        }
    }
    
    func fetchMovieDetails() {
        if let url = URL(string: NetworkConstants.baseUrl + NetworkConstants.movieEndpoint + "/" + String(currentMovieId) + NetworkConstants.languageEndPoint + NetworkConstants.englishUs + NetworkConstants.apiKeyEndPoint + NetworkConstants.apiKey) {
            URLSession.shared.dataTask(with: url) { data, _, error in
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
