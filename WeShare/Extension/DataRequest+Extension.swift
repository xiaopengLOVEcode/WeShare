//
//  DataRequest+Extension.swift
//  PowerLoans
//
//  Created by Neo on 2023/8/27.
//

import Foundation
import Alamofire
import RxSwift

extension DataRequest: ReactiveCompatible {}

// MARK: - responseWrapperDecodable
extension Reactive where Base: DataRequest {
    public func responseWrapperDecodable<T: Decodable>(
        of type: T.Type = T.self,
        queue: DispatchQueue = .main,
        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<BaseResponse<T>>.defaultDataPreprocessor,
        decoder: DataDecoder = JSONDecoder(),
        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<BaseResponse<T>>.defaultEmptyResponseCodes,
        emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<BaseResponse<T>>.defaultEmptyRequestMethods
    ) -> Observable<T> {
        return Observable.create { (observer) -> Disposable in
            self.base.responseWrapperDecodable(
                of: type,
                queue: queue,
                dataPreprocessor: dataPreprocessor,
                decoder: decoder,
                emptyResponseCodes: emptyResponseCodes,
                emptyRequestMethods: emptyRequestMethods) { (response) in

                switch response.result {
                case let .success(wrapper):
                    if let data = wrapper.theplantagenet {
                        observer.on(.next(data))
                        observer.onCompleted()
                    } else {
                        observer.onCompleted()
                    }
                case let .failure(error):
                    if
                        case let AFError.responseValidationFailed(reason: .customValidationFailed(_error)) = error,
                        let e = _error as? PLNetworkError
                    {
                        observer.onError(e)
                    } else if case AFError.responseSerializationFailed(reason: .decodingFailed(error: _)) = error {
                        observer.onError(PLNetworkError.responseDecodeError)
                    } else {
                        if let code = response.response?.statusCode {
//                            let e = PLNetworkError.responseCodeError(code, "无法连接至网络，请检查网络设置")
//                            observer.onError(e)
                        } else {
//                            observer.onError(PLNetworkError.responseUnknownError)
                        }
                    }
                }
            }
            return Disposables.create {
                let request = self.base.request ?? (try? self.base.convertible.asURLRequest())
                self.base.cancel()
            }
        }
    }
}

public extension DataRequest {
    @discardableResult
    func responseWrapperDecodable<T: Decodable>(
        of type: T.Type = T.self,
        queue: DispatchQueue = .main,
        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<BaseResponse<T>>.defaultDataPreprocessor,
        decoder: DataDecoder = JSONDecoder(),
        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<BaseResponse<T>>.defaultEmptyResponseCodes,
        emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<BaseResponse<T>>.defaultEmptyRequestMethods,
        completionHandler: @escaping (AFDataResponse<BaseResponse<T>>) -> Void
    ) -> Self {
        // 中间层处理返回状态码
        let interCompletionHandler: (AFDataResponse<BaseResponse<T>>) -> Void = { (response) in
            switch response.result {
            case let .success(wrapper):
                if wrapper.usurper == "0" || wrapper.usurper == "00" {
                    completionHandler(response)
                } else {
//                    DispatchQueue.main.async {
//                        CommonNetworkErrorUtils.commonErrorHandle(
//                            isAFN: true,
//                            errorCode: wrapper.code,
//                            errorMsg: wrapper.msg,
//                            lastModified: (response.response?.allHeaderFields["Last-Modified"] as? String)
//                        ) { _ in }
//                    }

                    let error = PLNetworkError.responseCodeError(wrapper.usurper, wrapper.line)
                    let reason = AFError.ResponseValidationFailureReason.customValidationFailed(error: error)
                    let result: Result<BaseResponse<T>, AFError> = .failure(.responseValidationFailed(reason: reason))
                    let interResponse = AFDataResponse<BaseResponse<T>>(
                        request: response.request,
                        response: response.response,
                        data: response.data,
                        metrics: response.metrics,
                        serializationDuration: response.serializationDuration,
                        result: result
                    )
                    completionHandler(interResponse)
                }
            case .failure:
//                DispatchQueue.main.async {
//                    CommonNetworkErrorUtils.commonErrorHandle(
//                        isAFN: true,
//                        errorCode: response.error?.responseCode ?? 0,
//                        errorMsg: nil,
//                        lastModified: (response.response?.allHeaderFields["Last-Modified"] as? String),
//                        completion: { _ in }
//                    )
//                }
                completionHandler(response)
            }
        }

        return validate(statusCode: 200..<300)
            .response(
                queue: queue,
                responseSerializer: DecodableResponseSerializer(
                    dataPreprocessor: dataPreprocessor,
                    decoder: decoder,
                    emptyResponseCodes: emptyResponseCodes,
                    emptyRequestMethods: emptyRequestMethods
                ),
                completionHandler: interCompletionHandler
        )
    }
}

public extension DataRequest {
    func responseWrapperDecodable<T: Decodable>(
        of type: T.Type = T.self,
        queue: DispatchQueue = .main,
        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<BaseResponse<T>>.defaultDataPreprocessor,
        decoder: DataDecoder = JSONDecoder(),
        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<BaseResponse<T>>.defaultEmptyResponseCodes,
        emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<BaseResponse<T>>.defaultEmptyRequestMethods
    ) -> Observable<T> {
        return rx.responseWrapperDecodable(
            of: type,
            queue: queue,
            dataPreprocessor: dataPreprocessor,
            decoder: decoder,
            emptyResponseCodes: emptyResponseCodes,
            emptyRequestMethods: emptyRequestMethods
        )
    }
}

// MARK: - responseRawDecodable

extension Reactive where Base: DataRequest {
//    public func responseRawDecodable<T: Decodable>(
//        of type: T.Type = T.self,
//        queue: DispatchQueue = .main,
//        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<T>.defaultDataPreprocessor,
//        decoder: DataDecoder = JSONDecoder(),
//        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>.defaultEmptyResponseCodes,
//        emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>.defaultEmptyRequestMethods,
//        useCommandErrorHandler: Bool = true
//    ) -> Observable<T> {
//        return Observable.create { (observer) -> Disposable in
//            self.base.validate(statusCode: 200..<300).responseDecodable(
//                of: type,
//                queue: queue,
//                dataPreprocessor: dataPreprocessor,
//                decoder: decoder,
//                emptyResponseCodes: emptyResponseCodes,
//                emptyRequestMethods: emptyRequestMethods
//            ) { (response) in
//                // 解析包装类型
//                switch response.result {
//                case let .success(data):
//                    observer.on(.next(data))
//                    observer.onCompleted()
//                case let .failure(error):
//                    var errorMsg: String?
//                    if
//                        case let AFError.responseValidationFailed(reason: .customValidationFailed(_error)) = error,
//                        let e = _error as? PLNetworkError
//                    {
//                        observer.onError(e)
//                    } else if case AFError.responseSerializationFailed(reason: .decodingFailed(error: _)) = error {
//                        observer.onError(PLNetworkError.responseDecodeError)
//                    } else {
//                        if let code = response.response?.statusCode {
//                            errorMsg = "无法连接至网络，请检查网络设置"
//                            let e = PLNetworkError.responseCodeError(code, errorMsg!)
//                            observer.onError(e)
//                        } else {
//                            observer.onError(PLNetworkError.responseUnknownError)
//                        }
//                    }
////                    if useCommandErrorHandler {
////                        CommonNetworkErrorUtils.commonErrorHandle(
////                            isAFN: false,
////                            errorCode: response.response?.statusCode ?? 0,
////                            errorMsg: errorMsg,
////                            lastModified: (response.response?.allHeaderFields["Last-Modified"] as? String),
////                            completion: {_ in }
////                        )
////                    }
//                }
//            }
//            return Disposables.create {
//                let request = self.base.request ?? (try? self.base.convertible.asURLRequest())
//                self.base.cancel()
//            }
//        }
//    }
}

public extension DataRequest {
//    func responseRawDecodable<T: Decodable>(
//        of type: T.Type = T.self,
//        queue: DispatchQueue = .main,
//        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<T>.defaultDataPreprocessor,
//        decoder: DataDecoder = JSONDecoder(),
//        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>.defaultEmptyResponseCodes,
//        emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>.defaultEmptyRequestMethods,
//        useCommandErrorHandler: Bool = true
//    ) ->  Observable<T> {
//        return rx.responseRawDecodable(
//            of: type,
//            queue: queue,
//            dataPreprocessor: dataPreprocessor,
//            decoder: decoder,
//            emptyResponseCodes: emptyResponseCodes,
//            emptyRequestMethods: emptyRequestMethods,
//            useCommandErrorHandler: useCommandErrorHandler
//        )
//    }
}
