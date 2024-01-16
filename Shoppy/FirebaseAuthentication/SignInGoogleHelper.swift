//
//  SignInGoogleHelper.swift
//  Shoppy
//
//  Created by Azoz Salah on 15/01/2024.
//

import Foundation

//final class SignInGoogleHelper {
//    
//    @MainActor
//    func signIn() async throws -> GoogleSignInResultModel {
//        guard let topVC = Utilities.shared.topViewController() else {
//            throw URLError(.cannotFindHost)
//        }
//        
//        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
//        
//        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let accessToken = gidSignInResult.user.accessToken.tokenString
//        let email = gidSignInResult.user.profile?.email
//        let name = gidSignInResult.user.profile?.email
//        
//        return GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
//    }
//}
