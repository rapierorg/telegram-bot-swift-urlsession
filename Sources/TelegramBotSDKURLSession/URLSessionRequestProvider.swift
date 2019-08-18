import Foundation
import TelegramBotSDKRequestProvider

public class URLSessionRequestProvider: RequestProvider {
    public static func doRequest(endpointUrl: URL, contentType: String, requestData: Data, completion: @escaping RequestCompletion) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = "POST"
        request.httpBody = requestData
        
        urlSession.dataTask(with: request) { (data, response, error) in
            guard error == nil, let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .wrapperError(code: 0, message: error.debugDescription))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(nil, .invalidStatusCode(statusCode: httpResponse.statusCode, data: data))
                return
            }
            
            
            guard let data = data, !data.isEmpty else {
                completion(nil, .noDataReceived)
                return
                
            }
            
            completion(data, nil)
            }.resume()
    }
}
