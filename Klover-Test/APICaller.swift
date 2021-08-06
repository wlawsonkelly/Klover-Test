//
//  ApiCaller.swift
//  Klover-Test
//
//  Created by Lawson Kelly on 8/4/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()

    private let url = "http://mockbin.org/bin/dc24c4de-102f-49bf-9c80-9ed52d4ea7f6?"

    private init() {}

    private enum APIError: Error {
        case noDataReturned
        case invalidURL
    }

    public func getSliceInfo(
        completion: @escaping (Result<[SliceResponse], Error>) -> Void
    ) {
        let url = URL(string: url)

        request(url: url, expecting: [SliceResponse].self,
                completion: completion)
    }

    private func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping ((Result<T, Error>) -> Void)
    ) {
        guard let url = url else {
            completion(.failure(APIError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in

            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }

            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
