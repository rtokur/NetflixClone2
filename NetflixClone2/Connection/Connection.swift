//
//  Connection.swift
//  NetflixClone2
//
//  Created by Rumeysa Tokur on 1.02.2025.
//

import Foundation
class Connection {
    // MARK: - Creating url for movies with path
    func createUrlMovie(path:String) async throws -> MovieResponse {
        let url = URL(string: "https://api.themoviedb.org/3"+path)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMTkwNGQzZTNhMWFjMjM0ZWVkZGNkM2JjMGQzZmY0MCIsIm5iZiI6MTczNzk5MTUzMS40MzkwMDAxLCJzdWIiOiI2Nzk3YTU2YjBhMzBkNmQwNTkyNDFkZmQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.INlafD8n0JNusAK0r_0vDOZ24fQx7KwqhEV-Yc5py40"
        ]

        let (data, respons) = try await URLSession.shared.data(for: request)
        guard let httpResponse = respons as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        let responsee = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return response
    }
    // MARK: - Creating url for series with path
    func createUrlSerie(path:String) async throws -> SerieResponse {
        let url = URL(string: "https://api.themoviedb.org/3"+path)!

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMTkwNGQzZTNhMWFjMjM0ZWVkZGNkM2JjMGQzZmY0MCIsIm5iZiI6MTczNzk5MTUzMS40MzkwMDAxLCJzdWIiOiI2Nzk3YTU2YjBhMzBkNmQwNTkyNDFkZmQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.INlafD8n0JNusAK0r_0vDOZ24fQx7KwqhEV-Yc5py40"
        ]

        let (data, respons) = try await URLSession.shared.data(for: request)
        guard let httpResponse = respons as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        let response = try JSONDecoder().decode(SerieResponse.self, from: data)
        return response
    }
    // MARK: - Creating url detail for selected movie or serie with path
    func createUrlDetail(path:String) async throws -> Detail {
        let url = URL(string: "https://api.themoviedb.org/3"+path)!

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMTkwNGQzZTNhMWFjMjM0ZWVkZGNkM2JjMGQzZmY0MCIsIm5iZiI6MTczNzk5MTUzMS40MzkwMDAxLCJzdWIiOiI2Nzk3YTU2YjBhMzBkNmQwNTkyNDFkZmQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.INlafD8n0JNusAK0r_0vDOZ24fQx7KwqhEV-Yc5py40"
        ]

        let (data, respons) = try await URLSession.shared.data(for: request)
        guard let httpResponse = respons as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        let response = try JSONDecoder().decode(Detail.self, from: data)
        let response2 = try? JSONSerialization.jsonObject(with: data, options: [])
        print(response2)
        return response
    }
    // MARK: - Calling the creating url func and return the popular movie response
    func getPopularMovies() async throws -> [Movie] {
        let movieResponse: MovieResponse = try await createUrlMovie(path: "/movie/popular")
        let movies: [Movie] = []
        return movieResponse.results ?? movies
    }
    // MARK: - Calling the creating url func and return the popular serie response
    func getPopularSeries() async throws -> [Serie] {
        let serieResponse: SerieResponse = try await createUrlSerie(path: "/tv/popular")
        let series : [Serie] = []
        return serieResponse.results ?? series
    }
    // MARK: - Calling the creating url func and return the upcoming movie response
    func getUpComingMovies() async throws -> [Movie] {
        let upComingResponse: MovieResponse = try await createUrlMovie(path: "/movie/upcoming")
        let upComing : [Movie] = []
        return upComingResponse.results ?? upComing
        
    }
    // MARK: - Calling the creating url func and return the top rated movie response
    func getTopRatedMovies() async throws -> [Movie] {
        let topRatedResponse : MovieResponse = try await createUrlMovie(path: "/movie/top_rated")
        let topRated : [Movie] = []
        return topRatedResponse.results ?? topRated
    }
    // MARK: - Calling the creating url func and return the selected movie's detail response
    func getMovieDetail(movieId: Int) async throws -> Detail {
        return try await createUrlDetail(path: "/movie/\(movieId)")
    }
    // MARK: - Calling the creating url func and return the selected serie's detail response
    func getSerieDetail(serieId: Int) async throws -> Detail {
        return try await createUrlDetail(path: "/tv/\(serieId)")
    }
}
