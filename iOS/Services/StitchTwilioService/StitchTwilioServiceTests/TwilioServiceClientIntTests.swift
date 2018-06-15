import XCTest
import StitchCoreAdminClient
import StitchCore
import StitchCoreSDK
import StitchIOSCoreTestUtils
import StitchCoreTwilioService
import StitchTwilioService

class TwilioServiceClientIntTests: BaseStitchIntTestCocoaTouch {
    private let twilioSidProp = "test.stitch.twilioSid"
    private let twilioAuthTokenProp = "test.stitch.twilioAuthToken"
    
    private lazy var pList: [String: Any]? = fetchPlist(type(of: self))
    
    private lazy var twilioSID: String? = pList?[twilioSidProp] as? String
    private lazy var twilioAuthToken: String? = pList?[twilioAuthTokenProp] as? String
    
    override func setUp() {
        super.setUp()
        
        guard twilioSID != nil && twilioSID != "<your-sid>",
            twilioAuthToken != nil && twilioAuthToken != "<your-auth-token>" else {
            XCTFail("No Twilio Sid or Auth Token in properties; failing test. See README for more details.")
            return
        }
    }
    
    func testSendMessage() throws {
        let app = try self.createApp()
        let _ = try self.addProvider(toApp: app.1, withConfig: ProviderConfigs.anon())
        let svc = try self.addService(
            toApp: app.1,
            withType: "twilio",
            withName: "twilio1",
            withConfig: ServiceConfigs.twilio(name: "twilio1", accountSid: twilioSID!, authToken: twilioAuthToken!)
        )
        _ = try self.addRule(toService: svc.1,
                         withConfig: RuleCreator.actions(name: "rule",
                                                         actions: RuleActionsCreator.twilio(send: true)))
        
        let client = try self.appClient(forApp: app.0)
        
        let exp0 = expectation(description: "should login")
        client.auth.login(withCredential: AnonymousCredential()) { _ in
            exp0.fulfill()
        }
        wait(for: [exp0], timeout: 5.0)
        
        let twilio = client.serviceClient(forFactory: twilioServiceClientFactory, withName: "twilio1")
        
        // Sending a random message to an invalid number should fail
        let to = "+15005550010"
        let from = "+15005550001"
        let body = "I've got it!"
        let mediaURL = "https://jpegs.com/myjpeg.gif.png"
        
        let exp1 = expectation(description: "should not send message")
        twilio.sendMessage(to: to, from: from, body: body, mediaURL: nil) { result in
            switch result {
            case .success:
                XCTFail("expected an error")
            case .failure(let error):
                switch error {
                case .serviceError(_, let withServiceErrorCode):
                    XCTAssertEqual(StitchServiceErrorCode.twilioError, withServiceErrorCode)
                default:
                    XCTFail("unexpected error code")
                }
            }
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 5.0)
        
        let exp2 = expectation(description: "should not send message")
        twilio.sendMessage(to: to, from: from, body: body, mediaURL: mediaURL) { result in
            switch result {
            case .success:
                XCTFail("expected an error")
            case .failure(let error):
                switch error {
                case .serviceError(_, let withServiceErrorCode):
                    XCTAssertEqual(StitchServiceErrorCode.twilioError, withServiceErrorCode)
                default:
                    XCTFail("unexpected error code")
                }
            }
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 5.0)
        
        // Sending with all good params for Twilio should work
        let fromGood = "+15005550006"
        
        let exp3 = expectation(description: "should send message")
        let exp4 = expectation(description: "should send message")
        twilio.sendMessage(to: to, from: fromGood, body: body, mediaURL: nil) { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail("unexpected error")
            }
            exp3.fulfill()
        }
        twilio.sendMessage(to: to, from: fromGood, body: mediaURL, mediaURL: nil) { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail("unexpected error")
            }
            exp4.fulfill()
        }
        wait(for: [exp3, exp4], timeout: 5.0)
        
        // Excluding any required parameters should fail
        let exp5 = expectation(description: "should have invalid params")
        
        twilio.sendMessage(to: to, from: "", body: body, mediaURL: mediaURL) { result in
            switch result {
            case .success:
                XCTFail("expected an error")
            case .failure(let error):
                switch error {
                case .serviceError(_, let withServiceErrorCode):
                    XCTAssertEqual(StitchServiceErrorCode.invalidParameter, withServiceErrorCode)
                default:
                    XCTFail("unexpected error code")
                }
            }
            exp5.fulfill()
        }
        wait(for: [exp5], timeout: 5.0)
    }
}
