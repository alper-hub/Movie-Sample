enum NetworkResponse<T> {
    case success(T)
    case failure(NetworkError)
}
