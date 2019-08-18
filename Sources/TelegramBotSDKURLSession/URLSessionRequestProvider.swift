import Foundation
import TelegramBotSDKRequestProvider

public class URLSessionRequestProvider: RequestProvider {
    public static func doRequest(endpointUrl: URL, contentType: String, requestData: Data, completion: @escaping RequestCompletion) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
        
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = "POST"
        request.httpBody = requestData
        
        urlSession.dataTask(with: request) { (data, response, error) in
            guard error != nil, let response = response as? HTTPURLResponse else {
                completion(nil, .wrapperError(code: 0, message: error.debugDescription))
                return
            }
            
            guard response.statusCode == 200 else {
                completion(nil, .invalidStatusCode(statusCode: response.statusCode, data: data))
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
