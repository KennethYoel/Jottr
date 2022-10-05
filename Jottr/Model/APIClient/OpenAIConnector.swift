//
//  OpenAIConnector.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/10/22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class OpenAIConnector {
    // MARK: - OpenAI API URL's:
    
    /*
     OpenAI has four models,
     daVinci, which is the most powerful (and most expensive) model,
     Curie, which is faster and cheaper but slightly less powerful than daVinci,
     Babbage, which is capable of standard tasks and isn’t as powerful, but is faster and cheaper,
     And Ada, which is much less powerful than the others but is the fastest and cheapest.
     
     daVinci: https://api.openai.com/v1/engines/text-davinci-002/completions
     Curie: https://api.openai.com/v1/engines/text-curie-001/completions
     Babbage: https://api.openai.com/v1/engines/text-babbage-001/completions
     Ada: https://api.openai.com/v1/engines/text-ada-001/completions
     */
    
    enum Endpoints {
        static let base = "https://api.openai.com/v1"
        static let daVinciPath = "/engines/text-davinci-002/completions"
        static let curiePath = "/engines/text-curie-001/completions"
        static let babbagePath = "/engines/text-babbage-001/completions"
        static let adaPath = "/engines/text-ada-001/completions"
        static let openAIModerationPath = "/moderations"
        
        case daVinciEngine
        case curieEngine
        case babbageEngine
        case adaEngine
        case openAIModeration // moderation endpoint
        
        var stringValue: String {
            switch self {
            case .daVinciEngine:
                return Endpoints.base + Endpoints.daVinciPath
            // specifies the maximum number of StudentLocation objects to return in the JSON response:
            case .curieEngine:
                return Endpoints.base + Endpoints.curiePath
            // use this parameter with limit to paginate through results:
            case .babbageEngine:
                return Endpoints.base + Endpoints.babbagePath
            /*
             a comma-separate list of key names that specify the sorted order of the results:
             Prefixing a key name with a negative sign reverses the order (default order is ascending)
             such as -updatedAt:
             */
            case .adaEngine:
                return Endpoints.base + Endpoints.adaPath
            // a unique key (user ID). Gets only student locations with a given user ID:
            case .openAIModeration:
                return Endpoints.base + Endpoints.openAIModerationPath
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Authentication Properties
    
    static var openAIKey: String {
      get {
        // obtain the path to our Plist file
        guard let filePath = Bundle.main.path(forResource: "OpenAI-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'OpenAI-Info.plist'.")
        }
        // reading a Plist file by loading the Plist file into a dictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'OpenAI-Info.plist'.")
        }
        return value
      }
    }
    
    // MARK: Helper Methods for API Requests
    
    class func executeRequest(request: URLRequest, withSessionConfig sessionConfig: URLSessionConfiguration?) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        let session: URLSession
        if (sessionConfig != nil) {
            session = URLSession(configuration: sessionConfig!)
        } else {
            session = URLSession.shared
        }
        var requestData: Data?
        let task = session.dataTask(with: request as URLRequest, completionHandler:{ (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print("error: \(error!.localizedDescription): \(error!.localizedDescription)")
            } else if data != nil {
                requestData = data
            }
            
            print("Semaphore signalled")
            semaphore.signal()
        })
        task.resume()
        
        // Handle async with semaphores. Max wait of 10 seconds
        let timeout = DispatchTime.now() + .seconds(20)
        print("Waiting for semaphore signal")
        let retVal = semaphore.wait(timeout: timeout)
        print("Done waiting, obtained - \(retVal)")
        return requestData
    }
    
    class func processPrompt(prompt: String, completionHandler: @escaping (Result<OpenAIResponse?, Error>) -> Void) {
        var urlRequest: URLRequest!
        
        resolveURL(sessionPrompt: prompt) { result in
            switch result {
            case .success(let urlData):
                urlRequest = urlData
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
        if let requestData = executeRequest(request: urlRequest, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            debugPrint(jsonStr)
            
            decodeJson(jsonString: jsonStr, responseType: OpenAIResponse.self) { result in
                switch result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    // before returning text checks first if content is not prohibited
    class func processModeratePrompt(prompt: String, completionHandler: @escaping (Result<OpenAIResponse?, Error>) -> Void) {
        var urlRequest: URLRequest!
        
        resolveURL(sessionPrompt: prompt) { result in
            switch result {
            case .success(let urlData):
                urlRequest = urlData
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
        if let requestData = executeRequest(request: urlRequest, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            debugPrint(jsonStr)
            
            decodeJson(jsonString: jsonStr, responseType: OpenAIResponse.self) { [self] result in
                switch result {
                case .success(let data):
                    guard let data = data else { return }
                    requestModeration(textToClassify: data.choices[0].completionText) { result in
                        switch result {
                        case .success(let flag):
                            var textOutput: OpenAIResponse!
                            // if OpenAI finds the text to be appropriate then return text else don't show it
                            if flag == false {
                                textOutput = data
                            } else {
                                // need to add a method to show a text stating prohibited content.
                                debugPrint("Unable to show prohibited content: \(data)")
                            }
                            completionHandler(.success(textOutput))
                        case .failure(let error):
                            debugPrint("\(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    // The moderation endpoint can be used to detect whether text generated by the API violates OpenAI's content policy.
    class func requestModeration(textToClassify: String, completionHandler: @escaping (Result<Bool, Error>) -> Void){
        var request = URLRequest(url: Endpoints.openAIModeration.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
        let httpBody: [String: Any] = [
            "input" : textToClassify
        ]
        
        var httpBodyJson: Data!
        
        do {
            httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        } catch {
            debugPrint("Unable to convert to JSON \(error)")
        }
        request.httpBody = httpBodyJson
        
        if let requestData = executeRequest(request: request, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            debugPrint(jsonStr)
            
            // decoding OpenAI moderation response which identify content that our content policy prohibits
            decodeJson(jsonString: jsonStr, responseType: ModerationResponse.self) { result in
                switch result {
                case .success(let data):
                    guard let isFlagged = data else { return }
                    if isFlagged.results[0].flagged {
                        let moderatedCategories = isFlagged.results[0].categories
                        // prints to console which category the content violated
                        print("The prohibited categories: \(String(describing: moderatedCategories))")
                    }
                    completionHandler(.success(isFlagged.results[0].flagged))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    class func resolveURL(sessionPrompt: String, completionHandler: @escaping (Result<URLRequest?, Error>) -> Void) {
        var request = URLRequest(url: Endpoints.daVinciEngine.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
        let httpBody: [String: Any] = [
            "prompt": sessionPrompt,
            "max_tokens": 100,
            "temperature": 0.6, // float from 0 to 1, generally recommend altering this or top_p but not both.
            "top_p": 1.0, // An alternative to sampling with temperature, called nucleus sampling.
//            "n": 1, // How many completions to generate for each prompt.
//            "stop": "\n" // Up to 4 sequences where the API will stop generating further tokens.
            "echo": false, // Concatenate the prompt and the completion text (which the API will do for you if you set the echo parameter to true)
            "presence_penalty": 0.0,
            "frequency_penalty": 0.5
        ]
        
        var httpBodyJson: Data!
        
        do {
            httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        } catch {
            completionHandler(.failure(error))
            debugPrint("Unable to convert to JSON \(error)")
        }
        request.httpBody = httpBodyJson
        
        completionHandler(.success(request))
    }
    
    class func decodeJson<ResponseType: Decodable>(jsonString: String, responseType: ResponseType.Type, completionHandler: @escaping (Result<ResponseType?, Error>) -> Void) {
        let json = jsonString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(responseType.self, from: json)
            completionHandler(.success(product))
        } catch {
            completionHandler(.failure(error))
            debugPrint("Error decoding OpenAI API Response")
        }
    }
}
