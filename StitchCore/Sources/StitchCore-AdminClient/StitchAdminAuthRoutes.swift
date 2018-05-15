import Foundation
import StitchCore

/**
 * The set of authentication routes on the Stitch server to authenticate as an admin user. 
 */
class StitchAdminAuthRoutes: StitchAuthRoutes {
    var apiKeysRoute: String {
        fatalError("user API keys not implemented in admin API")
    }
    
    /**
     * The route on the server for getting a new access token.
     */
    var sessionRoute: String {
        return "\(StitchAdminClient.apiPath)/auth/session"
    }

    /**
     * The route on the server for fetching the currently authenticated user's profile.
     */
    var profileRoute: String {
        return "\(StitchAdminClient.apiPath)/auth/profile"
    }

    /**
     * Returns the route on the server for a particular authentication provider.
     */
    func authProviderRoute(withProviderName providerName: String) -> String {
        return "\(StitchAdminClient.apiPath)/auth/providers/\(providerName)"
    }

    /**
     * Returns the route on the server for logging in with a particular authentication provider.
     */
    func authProviderLoginRoute(withProviderName providerName: String) -> String {
        return "\(authProviderRoute(withProviderName: providerName))/login"
    }

    /**
     * Returns the route on the server for linking the currently authenticated user with an identity associated with a
     * particular authentication provider.
     */
    func authProviderLinkRoute(withProviderName providerName: String) -> String {
        return "\(authProviderLoginRoute(withProviderName: providerName))?link=true"
    }
}
