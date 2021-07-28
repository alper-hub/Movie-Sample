protocol ProviderProtocol {
    
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (NetworkResponse<T>) -> Void) where T: Decodable
}
