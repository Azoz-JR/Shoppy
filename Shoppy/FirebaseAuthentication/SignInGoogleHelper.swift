//
//  SignInGoogleHelper.swift
//  Shoppy
//
//  Created by Azoz Salah on 15/01/2024.
//

import UIKit
import GoogleSignIn
import GoogleSignInSwift

final class SignInGoogleHelper {
    
    @MainActor
    func signIn(presenter: UIViewController) async throws -> GoogleSignInResultModel {
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenter)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let email = gidSignInResult.user.profile?.email
        let name = gidSignInResult.user.profile?.name
        
        return GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
    }
}
