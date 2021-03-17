//
//  SessionManager.swift
//  avana
//
//  Created by Apit Gilang Aprida on 3/17/21.
//

import Foundation

class SessionManager: NSObject {

    static var currentSession: User? {
        get {
            if let data = UserDefaults.standard.data(forKey: "user-session"), let session = try? JSONDecoder().decode(User.self, from: data) {
                return session
            }
            return nil
        }

        set {
            let session = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(session, forKey: "user-session")
        }
    }

    class func deleteSession() {
        UserDefaults.standard.removeObject(forKey: "user-session")
    }

    static var validSession: Bool {
        if let session = currentSession, let token = session.token {
            return !token.isEmpty
        }
        return false
    }
}
