import Foundation
import StitchCoreSDK
import MongoSwift

/**
 * A utility class which contains a property that can be used with `StitchAuth` to retrieve a
 * `UserAPIKeyAuthProviderClient`.
 */
public final class UserAPIKeyAuthProvider {
    /**
     * An `AuthProviderClientFactory` which can be used with `StitchAuth` to retrieve an
     * `UserAPIKeyAuthProviderClient`.
     */
    public static let clientFactory: ClientFactoryImpl
        = ClientFactoryImpl.init()

    /**
     * :nodoc:
     * An implementation of `AuthProviderClientFactory` that produces an
     * `UserAPIKeyAuthProviderClient`.
     */
    public final class ClientFactoryImpl: AuthProviderClientFactory {
        public typealias ClientT = UserAPIKeyAuthProviderClient
        public typealias RequestClientT = StitchAuthRequestClient

        public func client(withRequestClient authRequestClient: StitchAuthRequestClient,
                           withRoutes routes: StitchAuthRoutes,
                           withDispatcher dispatcher: OperationDispatcher) -> ClientT {
            return UserAPIKeyAuthProviderClientImpl.init(
                withAuthRequestClient: authRequestClient,
                withAuthRoutes: routes,
                withDispatcher: dispatcher
            )
        }
    }
}

public protocol UserAPIKeyAuthProviderClient {
    /**
     * Creates a user API key that can be used to authenticate as the current user.
     *
     * - parameters:
     *     - withName: The name of the API key to be created.
     *     - completionHandler: The handler to be executed when the request is complete. If the operation is
     *                          successful, the result will contain the created user API key as a `UserAPIKey`.
     */
    func createAPIKey(withName name: String, _ completionHandler: @escaping (StitchResult<UserAPIKey>) -> Void)

    /**
     * Fetches a user API key associated with the current user.
     *
     * - parameters:
     *     - withID: The id of the API key to fetch.
     *     - completionHandler: The handler to be executed when the request is complete. If the operation is
     *                          successful, the result will contain the created user API key as a `UserAPIKey`. The
     *                          fetched API key will not contain the actual key string.
     */
    func fetchAPIKey(withID id: ObjectId, _ completionHandler: @escaping (StitchResult<UserAPIKey>) -> Void)

    /**
     * Fetches the user API keys associated with the current user.
     *
     * - parameters:
     *     - completionHandler: The handler to be executed when the request is complete. If the operation is
     *                          successful, the result will contain the fetched API keys as an `[UserAPIKey]`.
     *                          The fetched API keys will not contain the actual key string.
     */
    func fetchAPIKeys(_ completionHandler: @escaping (StitchResult<[UserAPIKey]>) -> Void)

    /**
     * Deletes a user API key associated with the current user.
     *
     * - parameters:
     *     - withID: The id of the API key to delete.
     *     - completionHandler: The handler to be executed when the request is complete.
     */
    func deleteAPIKey(withID id: ObjectId, _ completionHandler: @escaping (StitchResult<Void>) -> Void)

    /**
     * Enables a user API key associated with the current user.
     *
     * - parameters:
     *     - withID: The id of the API key to enable.
     *     - completionHandler: The handler to be executed when the request is complete.
     */
    func enableAPIKey(withID id: ObjectId, _ completionHandler: @escaping (StitchResult<Void>) -> Void)

    /**
     * Disables a user API key associated with the current user.
     *
     * - parameters:
     *     - withID: The id of the API key to disable.
     *     - completionHandler: The handler to be executed when the request is complete.
     */
    func disableAPIKey(withID id: ObjectId, _ completionHandler: @escaping (StitchResult<Void>) -> Void)
}

private class UserAPIKeyAuthProviderClientImpl:
CoreUserAPIKeyAuthProviderClient, UserAPIKeyAuthProviderClient {
    private let dispatcher: OperationDispatcher

    init(withAuthRequestClient authRequestClient: StitchAuthRequestClient,
         withAuthRoutes authRoutes: StitchAuthRoutes,
         withDispatcher dispatcher: OperationDispatcher) {
        self.dispatcher = dispatcher
        super.init(withAuthRequestClient: authRequestClient,
                   withAuthRoutes: authRoutes)
    }

    func createAPIKey(withName name: String, _ completionHandler: @escaping (StitchResult<UserAPIKey>) -> Void) {
        dispatcher.run(withCompletionHandler: completionHandler) {
            return try super.createAPIKey(withName: name)
        }
    }

    func fetchAPIKey(withID id: ObjectId, _ completionHandler: @escaping (StitchResult<UserAPIKey>) -> Void) {
        dispatcher.run(withCompletionHandler: completionHandler) {
            return try super.fetchAPIKey(withID: id)
        }
    }

    func fetchAPIKeys(_ completionHandler: @escaping (StitchResult<[UserAPIKey]>) -> Void) {
        dispatcher.run(withCompletionHandler: completionHandler) {
            return try super.fetchAPIKeys()
        }
    }

    func deleteAPIKey(withID id: ObjectId, _ completionHandler: @escaping (StitchResult<Void>) -> Void) {
        dispatcher.run(withCompletionHandler: completionHandler) {
            try super.deleteAPIKey(withID: id)
        }
    }

    func enableAPIKey(withID id: ObjectId, _ completionHandler: @escaping (StitchResult<Void>) -> Void) {
        dispatcher.run(withCompletionHandler: completionHandler) {
            try super.enableAPIKey(withID: id)
        }
    }

    func disableAPIKey(withID id: ObjectId, _ completionHandler: @escaping (StitchResult<Void>) -> Void) {
        dispatcher.run(withCompletionHandler: completionHandler) {
            try super.disableAPIKey(withID: id)
        }
    }
}
