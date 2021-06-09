//
//  NetworkDataFetcher.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 22/05/2021.
//
import Moya
class NetworkDataFetcher: DataFetcher {
    private var provider = MoyaProvider<PSApi>(plugins: [NetworkLoggerPlugin()])
    
    typealias ResponseClosure<T:Codable> = (Result<T,Error>) -> ()
    typealias BaseResponseClosure<T:Codable> = (Result<BaseResponse<T>,Error>) -> ()
    
    func getResponse(completion: @escaping (Result<Bool, Error>) -> ()) {
        provider.request(.temperature) { (result) in
            switch result {
            case .success(let response):
                let status = response.statusCode == 200
                completion(.success(status))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTemperatures(completion: @escaping (Result<[Month], Error>) -> ()) {
        request(target: .temperature, completion: mapBlock(completion: completion))
    }
    
    private func mapBlock<T:Codable>(completion:@escaping ResponseClosure<T>) -> BaseResponseClosure<T> {
        let block:BaseResponseClosure<T> = { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return block
    }
}

private extension NetworkDataFetcher {
    
    private func request<T: Codable>(target: PSApi, completion: @escaping ResponseClosure<T>) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func requestWithRetry<T: Codable>(target: PSApi, completion: @escaping ResponseClosure<T>) {
        var maxRetryCount = 3 {
            didSet {
                print("RetryCount: \(maxRetryCount)")
            }
        }
        
        let retryInterval:(() -> DispatchTime) = { return .now() + 1 }

        func requestBlock() {
            provider.request(target) { result in
                switch result {
                case let .success(response):
                    do {
                        let results = try JSONDecoder().decode(T.self, from: response.data)
                        completion(.success(results))
                    } catch let error {
                        retryBlock(error: error)
                    }
                case let .failure(error):
                    retryBlock(error: error)
                }
            }
        }
        
        func retryBlock(error:Error) {
            maxRetryCount -= 1
            if maxRetryCount == 0 {
                completion(.failure(error))
            } else {
                DispatchQueue.main.asyncAfter(deadline: retryInterval()) {
                    requestBlock()
                }
            }
        }
        requestBlock()
    }
}
