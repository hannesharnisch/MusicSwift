//
//  MusicFinder.swift
//  
//
//  Created by Hannes Harnisch on 04.05.20.
//
#if os(iOS)
import Foundation
import SwiftJWT
import MediaPlayer


public class MusicFinder{
    let appleMusicLib:AppleMusicLibrary?

    public init(fileName:String, kid:String, iss:String){
        if let token = JWTGenerator.createJWTForAppleWith(fileName: fileName, kid: kid, iss: iss){
            print(token)
            self.appleMusicLib = AppleMusicLibrary(token: token)
        }else{
            appleMusicLib = nil
        }
    }
    public func getSearchResult(from text:String,callback:@escaping (Result<[Song],MusicFinderError>) -> Void){
        if appleMusicLib == nil{
            callback(.failure(.noMusicLibrary))
            return
        }
        appleMusicLib!.getSongsFrom(text: text, limit: 15) { (result) in
            switch result{
                case .success(let items):
                    callback(.success(items))
                case .failure(let err):
                    callback(.failure(err))
            }
        }
    }
    public func findSong(song:Song,callback:@escaping (Result<Song,MusicFinderError>) -> Void){
        if appleMusicLib == nil{
            callback(.failure(.noMusicLibrary))
            return
        }
        appleMusicLib!.getSongFrom(song: song) { (result) in
            switch result{
            case .success(let items):
                callback(.success(items[0]))
            case .failure(let err):
                callback(.failure(err))
            }
        }
    }
}
public enum MusicFinderError:Error{
    case noMusicLibrary
    case noFound
    case other
}

struct MyClaims: Claims {
    let iss: String
    let iat: Date
    let exp: Date
}
class JWTGenerator{
    static func createJWTForAppleWith(fileName:String, kid:String, iss:String) -> String?{
        do{
            let privateKeyPath =  Bundle.main.url(forResource: fileName, withExtension: nil)!
            let attrs = try FileManager.default.attributesOfItem(atPath: privateKeyPath.path) as NSDictionary
            let myHeader = Header(kid: kid)
            let creationDate = attrs.fileCreationDate()!
            let timediff = DateInterval.init(start:creationDate,duration:15777000)
            let claims = MyClaims(iss: iss, iat: creationDate, exp: timediff.end)
            print(attrs.fileCreationDate()!)
            var myJWT = JWT(header: myHeader, claims: claims)
            let privateKey: Data = try Data(contentsOf: privateKeyPath, options: .alwaysMapped)
            let jwtSigner = JWTSigner.es256(privateKey: privateKey)
            let signedJWT = try myJWT.sign(using: jwtSigner)
            return signedJWT
        }catch(let err){
            print(err)
            return nil
        }
    }
}
#endif
