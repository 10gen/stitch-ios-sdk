@testable import MongoSwift
import Foundation
import Nimble
import XCTest

final class SDAMTests: XCTestCase {
    static var allTests: [(String, (SDAMTests) -> () throws -> Void)] {
        return [
            ("testMonitoring", testMonitoring)
        ]
    }

    override func setUp() {
        self.continueAfterFailure = false
    }

    func checkEmptyLists(_ desc: ServerDescription) {
        expect(desc.arbiters).to(haveCount(0))
        expect(desc.hosts).to(haveCount(0))
        expect(desc.passives).to(haveCount(0))
    }

    func checkUnknownServerType(_ desc: ServerDescription) {
        expect(desc.type).to(equal(ServerType.unknown))
    }

    func checkDefaultHostPort(_ desc: ServerDescription) {
        expect(desc.connectionId).to(equal(ConnectionId("localhost:27017")))
    }

    // Basic test based on the "standalone" spec test for SDAM monitoring:
    // https://github.com/mongodb/specifications/blob/master/source/server-discovery-and-monitoring/tests/monitoring/standalone.json
    func testMonitoring() throws {
        let client = try MongoClient(options: ClientOptions(eventMonitoring: true))
        client.enableMonitoring(forEvents: .serverMonitoring)

        let center = NotificationCenter.default
        var receivedEvents = [MongoEvent]()

        let observer = center.addObserver(forName: nil, object: nil, queue: nil) { (notif) in

            if !["serverDescriptionChanged", "serverOpening", "serverClosed", "topologyDescriptionChanged",
                "topologyOpening", "topologyClosed"].contains(notif.name.rawValue) { return }

            guard let event = notif.userInfo?["event"] as? MongoEvent else {
                XCTFail("Notification \(notif) did not contain an event")
                return
            }

            receivedEvents.append(event)
        }
        // do some basic operations
        let db = try client.db("testing")
        _ = try db.createCollection("testColl")
        try db.drop()

        center.removeObserver(observer)

        // check event count and that events are of the expected types
        expect(receivedEvents.count).to(equal(5))
        expect(receivedEvents[0]).to(beAnInstanceOf(TopologyOpeningEvent.self))
        expect(receivedEvents[1]).to(beAnInstanceOf(TopologyDescriptionChangedEvent.self))
        expect(receivedEvents[2]).to(beAnInstanceOf(ServerOpeningEvent.self))
        expect(receivedEvents[3]).to(beAnInstanceOf(ServerDescriptionChangedEvent.self))
        expect(receivedEvents[4]).to(beAnInstanceOf(TopologyDescriptionChangedEvent.self))

        // verify that data in ServerDescription and TopologyDescription looks reasonable
        let event0 = receivedEvents[0] as! TopologyOpeningEvent
        expect(event0.topologyId).toNot(beNil())

        let event1 = receivedEvents[1] as! TopologyDescriptionChangedEvent
        expect(event1.topologyId).to(equal(event0.topologyId))
        expect(event1.previousDescription.type).to(equal(TopologyType.unknown))
        expect(event1.newDescription.type).to(equal(TopologyType.single))
        let server0 = event1.newDescription.servers[0]

        checkDefaultHostPort(server0)
        expect(server0.type).to(equal(ServerType.unknown))
        checkEmptyLists(server0)

        let event2 = receivedEvents[2] as! ServerOpeningEvent
        expect(event2.topologyId).to(equal(event1.topologyId))
        expect(event2.connectionId).to(equal(ConnectionId("localhost:27017")))

        let event3 = receivedEvents[3] as! ServerDescriptionChangedEvent
        expect(event3.topologyId).to(equal(event2.topologyId))
        let prevServer = event3.previousDescription
        checkDefaultHostPort(prevServer)
        checkEmptyLists(prevServer)
        checkUnknownServerType(prevServer)

        let newServer = event3.newDescription
        checkDefaultHostPort(newServer)
        checkEmptyLists(newServer)
        expect(newServer.type).to(equal(ServerType.standalone))

        let event4 = receivedEvents[4] as! TopologyDescriptionChangedEvent
        expect(event4.topologyId).to(equal(event3.topologyId))
        let prevTopology = event4.previousDescription
        expect(prevTopology.type).to(equal(TopologyType.single))
        expect(prevTopology.servers).to(haveCount(1))
        checkDefaultHostPort(prevTopology.servers[0])
        checkUnknownServerType(prevTopology.servers[0])
        checkEmptyLists(prevTopology.servers[0])

        let newTopology = event4.newDescription
        expect(newTopology.type).to(equal(TopologyType.single))
        checkDefaultHostPort(newTopology.servers[0])
        expect(newTopology.servers[0].type).to(equal(ServerType.standalone))
        checkEmptyLists(newTopology.servers[0])
    }
}
