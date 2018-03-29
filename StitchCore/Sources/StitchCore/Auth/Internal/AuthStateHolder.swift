import Foundation

/**
 * A struct containing all information necessary to represent a user's authentication state with respect to Stitch.
 */
internal struct AuthStateHolder {
    /**
     * Basic authentication information such as user ID, device ID, and access and refresh tokens.
     */
    var apiAuthInfo: APIAuthInfo?

    /**
     * Extended authentication information such as user profile, and currently logged in authentication provider type.
     */
    var extendedAuthInfo: ExtendedAuthInfo?

    /**
     * The combination of `apiAuthInfo` and `extendedAuthInfo`.
     */
    var authInfo: AuthInfo?

    /**
     * Whether or not a user is currently logged in.
     */
    var isLoggedIn: Bool {
        return apiAuthInfo != nil || authInfo != nil
    }

    /**
     * The temporary access token of the current user.
     */
    var accessToken: String? {
        return apiAuthInfo?.accessToken ?? authInfo?.accessToken
    }

    /**
     * The permanent refresh token of the current user.
     */
    var refreshToken: String? {
        return apiAuthInfo?.refreshToken ?? authInfo?.refreshToken
    }

    /**
     * The ID of the current user.
     */
    var userId: String? {
        return apiAuthInfo?.userId ?? authInfo?.userId
    }

    /**
     * A function to clear the authentication state.
     *
     * - important: Does not clear authentication state from underlying storage.
     */
    mutating func clearState() {
        self.apiAuthInfo = nil
        self.extendedAuthInfo = nil
        self.authInfo = nil
    }
}
