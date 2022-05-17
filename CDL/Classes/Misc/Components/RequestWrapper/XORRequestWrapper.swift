//
//  XORRequestWrapper.swift
//  CDL
//
//  Created by Андрей Чернышев on 17.05.2022.
//

import RxSwift
import RushSDK
import Alamofire

final class XORRequestWrapper {
    func callServerStringApi(requestBody: APIRequestBody) -> Single<Any> {
        execute(request: requestBody)
    }
}

// MARK: Private
private extension XORRequestWrapper {
    func execute(request: APIRequestBody, attempt: Int = 1, maxCount: Int = 3) -> Single<Any> {
        guard attempt <= maxCount else {
            return .deferred { .error(NSError(domain: "Request wrapper attempt limited", code: 404)) }
        }
        
        return SDKStorage.shared.restApiTransport
            .callServerStringApi(requestBody: request)
            .catchAndReturn("")
            .flatMap { [weak self] response -> Single<Any> in
                guard let self = self else {
                    return .never()
                }
                
                let success = self.success(response: response)
                
                return success ? .just(response) : self.execute(request: request, attempt: attempt + 1)
            }
    }
    
    func success(response: Any) -> Bool {
        guard
            let string = response as? String,
            let json = XOREncryption.toJSON(string, key: GlobalDefinitions.apiKey),
            let code = json["_code"] as? Int
        else {
            return false
        }
        
        return code == 200
    }
}
