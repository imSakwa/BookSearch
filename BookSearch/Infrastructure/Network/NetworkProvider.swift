//
//  NetworkProvider.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

import RxSwift

protocol NetworkProviderProtocol {
    func request<R: Decodable, E: RequesteResponsable>(
        with endpoint: E,
        completion: @escaping (Result<R, Error>) -> Void
    ) where E.Response == R

    func request<R: Decodable, E: RequesteResponsable>(
        with endpoint: E
    ) -> Observable<R> where E.Response == R
}

final class NetworkProvider: NetworkProviderProtocol {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<R: Decodable, E: RequesteResponsable>(
        with endpoint: E,
        completion: @escaping (Result<R, Error>) -> Void
    ) where E.Response == R {
        do {
            let urlRequest = try endpoint.getURLRequest()
            
            session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.needErrorControl))
                    return
                }
                
                guard (200...299).contains(response.statusCode) else {
                    completion(.failure(NetworkError.needErrorControl))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.needErrorControl))
                    return
                }
                
                do {
                    let decodeData = try JSONDecoder().decode(R.self, from: data)
                    completion(.success(decodeData))

                } catch {
                    completion(.failure(NetworkError.needErrorControl))
                }
                
            }.resume()
            
            
        } catch {
            completion(.failure(NetworkError.needErrorControl))
        }
    }
    
    func request<R: Decodable, E: RequesteResponsable>(
        with endpoint: E
    ) -> Observable<R> where E.Response == R {
        return Observable<R>.create { observer in
            do {
                let urlRequest = try endpoint.getURLRequest()
                
                let task = self.session.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else {
                        observer.onError(NetworkError.needErrorControl)
                        return
                    }
                    
                    guard (200...299).contains(response.statusCode) else {
                        observer.onError(NetworkError.needErrorControl)
                        return
                    }
                    
                    guard let data = data else {
                        observer.onError(NetworkError.needErrorControl)
                        return
                    }
                    
                    do {
                        let decodeData = try JSONDecoder().decode(R.self, from: data)
                        observer.onNext(decodeData)
                        
                    } catch {
                        observer.onError(NetworkError.needErrorControl)
                    }
                }
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
                
            } catch {
                observer.onError(NetworkError.needErrorControl)
            }
        }
    }
    
    private func decode<T: Decodable>(data: Data) -> Result<T, Error> {
          do {
              let decoded = try JSONDecoder().decode(T.self, from: data)
              return .success(decoded)
          } catch {
              return .failure(NetworkError.needErrorControl)
          }
      }
}
