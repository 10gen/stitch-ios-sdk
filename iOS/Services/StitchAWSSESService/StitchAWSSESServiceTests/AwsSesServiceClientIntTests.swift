import XCTest

import StitchCoreSDK
import StitchCoreAdminClient
import StitchIOSCoreTestUtils
import StitchCoreAWSSESService
@testable import StitchAWSSESService

class AWSSESServiceClientIntTests: BaseStitchIntTestCocoaTouch {
    private let awsAccessKeyIDProp = "test.stitch.accessKeyID"
    private let awsSecretAccessKeyProp = "test.stitch.secretAccessKey"
    
    private lazy var pList: [String: Any]? = fetchPlist(type(of: self))
    
    private lazy var awsAccessKeyID: String? = pList?[awsAccessKeyIDProp] as? String
    private lazy var awsSecretAccessKey: String? = pList?[awsSecretAccessKeyProp] as? String
    
    override func setUp() {
        super.setUp()
        
        guard awsAccessKeyID != nil && awsAccessKeyID != "<your-access-key-id>",
              awsSecretAccessKey != nil && awsSecretAccessKey != "<your-secret-access-key>" else {
                XCTFail("No AWS Access Key ID, or Secret Access Key in properties; failing test. See README for more details.")
                return
        }
    }
    
    func testSendEmail() throws {
        let app = try self.createApp()
        let _ = try self.addProvider(toApp: app.1, withConfig: ProviderConfigs.anon())
        let svc = try self.addService(
            toApp: app.1,
            withType: "aws-ses",
            withName: "aws-ses1",
            withConfig: ServiceConfigs.awsSes(
                name: "aws-ses1",
                region: "us-east-1", accessKeyID: awsAccessKeyID!, secretAccessKey: awsSecretAccessKey!
            )
        )
        _ = try self.addRule(toService: svc.1,
                             withConfig: RuleCreator.actions(name: "rule",
                                                             actions: RuleActionsCreator.awsSes(send: true)))

        let client = try self.appClient(forApp: app.0)

        let exp0 = expectation(description: "should login")
        client.auth.login(withCredential: AnonymousCredential()) { _  in
            exp0.fulfill()
        }
        wait(for: [exp0], timeout: 5.0)

        let awsSES = client.serviceClient(forFactory: awsSESServiceClientFactory, withName: "aws-ses1")

        // Sending a random email to an invalid email should fail
        let to = "eliot@stitch-dev.10gen.cc"
        let from = "dwight@10gen"
        let subject = "Hello"
        let body = "again friend"

        let exp1 = expectation(description: "should not send email")
        awsSES.sendEmail(to: to, from: from, subject: subject, body: body) { result in
            switch result {
            case .success:
                XCTFail("expected an error")
            case .failure(let error):
                switch error {
                case .serviceError(_, let withServiceErrorCode):
                    XCTAssertEqual(StitchServiceErrorCode.awsError, withServiceErrorCode)
                default:
                    XCTFail()
                }
            }
            
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 5.0)

        // Sending with all good params for SES should work
        let fromGood = "dwight@baas-dev.10gen.cc"

        let exp2 = expectation(description: "should send email")
        awsSES.sendEmail(to: to, from: fromGood, subject: subject, body: body) { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail("unexpected error")
            }
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 5.0)

        // Excluding any required parameters should fail
        let exp3 = expectation(description: "should have invalid params")
        awsSES.sendEmail(to: to, from: "", subject: subject, body: body) { result in
            switch result {
            case .success:
                XCTFail("expected an error")
            case .failure(let error):
                switch error {
                case .serviceError(_, let withServiceErrorCode):
                    XCTAssertEqual(StitchServiceErrorCode.invalidParameter, withServiceErrorCode)
                default:
                    XCTFail()
                }
            }
            exp3.fulfill()
        }
        wait(for: [exp3], timeout: 5.0)
    }
}
