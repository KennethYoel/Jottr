//
//  OpenAIConnector.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/10/22.
//

import Foundation

class OpenAIConnector {
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
    static let openAIURL = URL(string: "https://api.openai.com/v1/engines/text-davinci-002/completions")
    
    // moderation endpoint
    static let openAIModeration = URL(string: "https://api.openai.com/v1/moderations")
    
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
    
    class func fetchGETRequest<ResponseType: Decodable>(urlString: String, responseType: ResponseType.Type) async -> String {
        let fetchTask = Task { () -> String in
            let url = URL(string: urlString)! //"https://hws.dev/readings.json"
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode(responseType.self, from: data)
            return readings as! String //"Found \(readings.count) readings"
        }
        let result = await fetchTask.result
        switch result {
            case .success(let str):
                return str
            case .failure(let error):
                return "Error: \(error.localizedDescription)"
        }
    }
    
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
    /*
     Just call the function OpenAIConnector.processPrompt(prompt: “Insert the prompt here”) and you’ll be
     good to go!
     */
    class func processPrompt(prompt: String, completionHandler: @escaping (Result<OpenAIResponse?, Error>) -> Void) {
        var request = URLRequest(url: self.openAIURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
        let httpBody: [String: Any] = [
            "prompt": prompt,
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
            debugPrint("Unable to convert to JSON \(error)")
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
        }
        request.httpBody = httpBodyJson
        if let requestData = executeRequest(request: request, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            print(jsonStr)
            
            decodeJson(jsonString: jsonStr) { result in
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
        var request = URLRequest(url: self.openAIURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
        let httpBody: [String: Any] = [
            "prompt" : prompt,
            "max_tokens" : 100,
            "temperature": 0.6, //String(temperature) a float from 0 to 1
            "echo": false
        ]
        
        var httpBodyJson: Data!
        
        do {
            httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        } catch {
            debugPrint("Unable to convert to JSON \(error.localizedDescription)")
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
        }
        request.httpBody = httpBodyJson
        
        if let requestData = executeRequest(request: request, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            print(jsonStr)
            
            decodeJson(jsonString: jsonStr) { [self] result in
                switch result {
                case .success(let data):
                    // TODO: change Optional Bool to non-optional
                    let moderationResponse = requestModeration(textToClassify: (data?.choices[0].completionText)!)
                    var textOutput: OpenAIResponse!//String = ""
                    // if OpenAI finds the text to be appropriate then return text else don't show it
                    if moderationResponse == false {
                        if let moderatedData = data { //?.choices[0].text
                            textOutput = moderatedData
                        }
                    } else {
                        // need to add a method to show a text stating prohibited content.
                        debugPrint("Unable to show prohibited content.")
                    }
                    completionHandler(.success(textOutput))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    // The moderation endpoint can be used to detect whether text generated by the API violates OpenAI's content policy.
    class func requestModeration(textToClassify: String) -> Optional<Bool> {
        var request = URLRequest(url: self.openAIModeration!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
        let httpBody: [String: Any] = [
            "input" : textToClassify
        ]
        
        var httpBodyJson: Data
        
        do {
            httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        } catch {
            print("Unable to convert to JSON \(error)")
            return nil
        }
        request.httpBody = httpBodyJson
        if let requestData = executeRequest(request: request, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            print(jsonStr)
            
            let moderationResponseHandler = ModerationResponseHandler()
            guard let isFlagged = moderationResponseHandler.decodeJson(jsonString: jsonStr)?.results[0].flagged else {
                return nil
            }
            
            if isFlagged {
                let moderatedCategories = moderationResponseHandler.decodeJson(jsonString: jsonStr)?.results[0].categories
                // prints to console which category the content violated
                print("The prohibited categories: \(String(describing: moderatedCategories))")
            }
            
            return isFlagged
            
        }
        
        return nil
    }
    
    class func decodeJson(jsonString: String, completionHandler: @escaping (Result<OpenAIResponse?, Error>) -> Void) {
        let json = jsonString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(OpenAIResponse.self, from: json)
            completionHandler(.success(product))
        } catch {
            debugPrint("Error decoding OpenAI API Response")
            completionHandler(.failure(error))
        }
    }
}


//struct OpenAIResponseHandler {
//    func decodeJson(jsonString: String, completionHandler: @escaping (Result<OpenAIResponse?, Error>) -> Void) {
//        let json = jsonString.data(using: .utf8)!
//
//        let decoder = JSONDecoder()
//        do {
//            let product = try decoder.decode(OpenAIResponse.self, from: json)
//            DispatchQueue.main.async {
//                completionHandler(.success(product))
//            }
//        } catch {
//            debugPrint("Error decoding OpenAI API Response")
//            DispatchQueue.main.async {
//                completionHandler(.failure(error))
//            }
//        }
//    }
//}
// decoding OpenAI moderation response which identify content that our content policy prohibits
struct ModerationResponseHandler {
    func decodeJson(jsonString: String) -> ModerationResponse? {
        let json = jsonString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(ModerationResponse.self, from: json)
            return product
            
        } catch {
            print("Error decoding OpenAI Moderation Response")
        }
        
        return nil
    }
}

//struct OpenAIResponse: Codable {
//    var id: String
//    var object: String
//    var created: Int
//    var model: String
//    var choices: [Choice]
//}
//
//struct Choice: Codable {
//    var text: String
//    var index: Int
//    var logprobs: String?
//    var finish_reason: String
//}


//struct ModerationResponse: Codable {
//    var id: String
//    var model: String
//    var results: [Results]
//}
//
//struct Results: Codable {
//    struct Categories: Codable {
//        var hate: Bool
//        var hateThreatening: Bool
//        var selfHarm: Bool
//        var sexual: Bool
//        var sexualMinors: Bool
//        var violence: Bool
//        var violenceGraphic: Bool
//        
//        enum CodingKeys: String, CodingKey {
//            case hate
//            case hateThreatening = "hate/threatening"
//            case selfHarm = "self-harm"
//            case sexual
//            case sexualMinors = "sexual/minors"
//            case violence
//            case violenceGraphic = "violence/graphic"
//        }
//    }
//    struct CategoryScores: Codable {
//        var hate: Double
//        var hateThreatening: Double
//        var selfHarm: Double
//        var sexual: Double
//        var sexualMinors: Double
//        var violence: Double
//        var violenceGraphic: Double
//        
//        enum CodingKeys: String, CodingKey {
//            case hate
//            case hateThreatening = "hate/threatening"
//            case selfHarm = "self-harm"
//            case sexual
//            case sexualMinors = "sexual/minors"
//            case violence
//            case violenceGraphic = "violence/graphic"
//        }
//    }
//    
//    var categories: Categories
//    var categoryScores: CategoryScores
//    var flagged: Bool
//    
//    enum CodingKeys: String, CodingKey {
//        case categories
//        case categoryScores = "category_scores"
//        case flagged
//    }
//}

/*
 {
   "id": "modr-XXXXX",
   "model": "text-moderation-001",
   "results": [
     {
       "categories": {
         "hate": 0, <- this is a Bool
         "hate/threatening": 0, <- this is a Bool
         "self-harm": 0, <- this is a Bool
         "sexual": 0, <- this is a Bool
         "sexual/minors": 0, <- this is a Bool
         "violence": 0, <- this is a Bool
         "violence/graphic": 0 <- this is a Bool
       },
       "category_scores": {
         "hate": 0.18805529177188873,
         "hate/threatening": 0.0001250059431185946,
         "self-harm": 0.0003706029092427343,
         "sexual": 0.0008735615410842001,
         "sexual/minors": 0.0007470346172340214,
         "violence": 0.0041268812492489815,
         "violence/graphic": 0.00023186142789199948
       },
       "flagged": 0 <- this is a Bool
     }
   ]
 }
 */
