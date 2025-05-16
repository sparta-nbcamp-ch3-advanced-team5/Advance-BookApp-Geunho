//
//  NetworkManager.swift
//  BookApp
//
//  Created by 정근호 on 5/10/25.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
    case apiKeyLoadingFail
}

class BookResponseRepository {
    static let shared = BookResponseRepository()
    private init() {}
    
    // 네트워크 로직을 수행하고, 결과를 Single 로 리턴
    func fetchBookResponse<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            
            if let apiKey = self.getAPIKey(named: "KAKAO_API_KEY") { // .plist에서 키 읽어오기
                request.allHTTPHeaderFields = ["Authorization": "KakaoAK \(apiKey)"]
            } else {
                observer(.failure(NetworkError.apiKeyLoadingFail))
                
                return Disposables.create()
            }
            
            let task = session.dataTask(with: request) { data, response, error in
                // error 가 있다면 Single 에 fail 방출
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                // data 가 없거나 http 통신 에러 일 때 dataFetchFail 방출
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchFail))
                    return
                }
                
                do {
                    // data 를 받고 json 디코딩 과정까지 성공한다면 결과를 success 와 함께 방출
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decodedData))
                } catch {
                    // 디코딩 실패했다면 decodingFail 방출
                    observer(.failure(NetworkError.decodingFail))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func getAPIKey(named keyname: String) -> String? {
        guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
            print("오류: APIKeys.plist 파일을 찾을 수 없습니다.")
            return nil
        }
        
        // NSDictionary: 불변이며 참조타입인 Dictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: keyname) as? String else {
            print("오류: APIKeys.plist 파일에서 '\(keyname)' 키를 찾거나 문자열로 변환할 수 없습니다.")
            return nil
        }
        
        return value
    }
}
