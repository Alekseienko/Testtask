//
//  NetworkManager.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import Foundation

final class NetworkManager: NetworkService {

    private var token: String?
    
    init() {
        Task {
            do {
                let tokenResponse = try await fetchToken()
                self.token = tokenResponse.token
            } catch {
                print("Background fetch failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchToken() async throws -> TokenResponse {
        guard let url = Endpoint.fetchToken.url else {
            throw NetworkError.invalidURL
        }

        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }
            }
            
            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            return tokenResponse
            
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternetConnection
            default:
                throw NetworkError.unknownError
            }
        } catch _ as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknownError
        }
    }

    func fetchUsers(page: Int, count: Int) async throws -> UsersResponse {
        guard let url = Endpoint.fetchUsers(page: page, count: count).url else {
            throw NetworkError.invalidURL
        }

        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }
            }

            let usersResponse = try JSONDecoder().decode(UsersResponse.self, from: data)
            return usersResponse
            
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternetConnection
            default:
                throw NetworkError.unknownError
            }
        } catch _ as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknownError
        }
    }

    func registerUser(request: UserRegistrationRequest) async throws -> UserRegistrationResponse {
        guard let url = Endpoint.registerUser.url else {
            throw NetworkError.invalidURL
        }
        guard let bearerToken = token else {
            throw NetworkError.serverError(statusCode: 401)
        }

        let boundary = UUID().uuidString
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(bearerToken, forHTTPHeaderField: "Token")
        
        var body = Data()

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(request.name)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(request.email)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"phone\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(request.phone)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"position_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(request.position_id)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(request.photo)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        urlRequest.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...422).contains(httpResponse.statusCode) else {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }
            }
            let userRegistrationResponse = try JSONDecoder().decode(UserRegistrationResponse.self, from: data)
            return userRegistrationResponse
            
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternetConnection
            default:
                throw NetworkError.unknownError
            }
        } catch _ as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknownError
        }
    }
    
    func fetchPositions() async throws -> PositionsResponse {
        guard let url = Endpoint.fetchPositions.url else {
            throw NetworkError.invalidURL
        }

        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }
            }

            let positionsResponse = try JSONDecoder().decode(PositionsResponse.self, from: data)
            return positionsResponse
            
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternetConnection
            default:
                throw NetworkError.unknownError
            }
        } catch _ as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknownError
        }
    }
    
    func getUserBy(id: Int?) async throws -> UserResponse {
        
        guard let id = id else {
            throw NetworkError.invalidID
        }
        
        guard let url = Endpoint.getUserBy(id: id).url else {
            throw NetworkError.invalidURL
        }

        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }
            }

            let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
            return userResponse
            
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternetConnection
            default:
                throw NetworkError.unknownError
            }
        } catch _ as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknownError
        }
    }
}
