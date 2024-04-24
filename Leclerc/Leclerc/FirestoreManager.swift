//
//  FirestoreManager.swift
//  LeclercCore
//
//  Created by Sofía Jimémez Martínez on 24/04/24.
//

import Foundation

import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class FirestoreManager {
    let db: Firestore

    init() {
        FirebaseApp.configure()
        db = Firestore.firestore()
    }

    // CRUD user
    // Simplified createUser function
    func createUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(user.id).setData([
            "name": user.name,
            "phone": user.phone,
            "feeds": [],
            "medals": [],
            "quests": [],
            "eventos": []
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func addMedalToUser(userId: String, medal: Activity, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let medalData = [
            "id": medal.id,
            "name": medal.name,
            "description": medal.description,
            "type": medal.type,
            "date": medal.date
        ] as [String : Any]
        
        
        db.collection("users").document(userId).updateData([
            "medals": FieldValue.arrayUnion([medalData])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }


    func addQuestToUser(userId: String, quest: Activity, completion: @escaping (Result<Void, Error>) -> Void) {

        let questData = [
            "id": quest.id,
            "name": quest.name,
            "description": quest.description,
            "type": quest.type,
            "date": quest.date
        ] as [String : Any]

        db.collection("users").document(userId).updateData([
            "quests": FieldValue.arrayUnion([questData])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // addMyFeedToUser
    func addMyFeedToUser(userId: String, feed: Feed, completion: @escaping (Result<Void, Error>) -> Void) {
        let feed = [
            "id": feed.id,
            "lat": feed.lat,
            "lng": feed.lng,
            "name": feed.name,
            "reactions": feed.reactions
        ] as [String : Any]

        db.collection("users").document(userId).updateData([
            "feeds.my_feed": feed
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func addEventToUser(userId: String, event: Activity, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventData = [
            "id": event.id,
            "name": event.name,
            "description": event.description,
            "type": event.type,
            "date": event.date
        ] as [String : Any]

        db.collection("users").document(userId).updateData([
            "eventos": FieldValue.arrayUnion([eventData])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // if it's already inside the array, then don't add it
    func addVisitedFeedToUser(userId: String, feed: Feed, completion: @escaping (Result<Void, Error>) -> Void) {
        let feedDict = [
            "id": feed.id,
            "lat": feed.lat,
            "lng": feed.lng,
            "name": feed.name,
            "reactions": feed.reactions
        ] as [String : Any]

        let userDocument = db.collection("users").document(userId)

        userDocument.getDocument { (document, error) in
            if let document = document, document.exists {
                if let feedsVisited = document.get("feeds.feeds_visites") as? [[String: Any]] {
                    if feedsVisited.contains(where: { $0["id"] as? String == feed.id }) {
                        // Feed already exists in the array, so don't add it
                        completion(.success(()))
                        return
                    }
                }
            } else if let error = error {
                completion(.failure(error))
                return
            }

            // If we reach here, it means that the feed is not in the array, so we add it
            userDocument.updateData([
                "feeds.feeds_visites": FieldValue.arrayUnion([feedDict])
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    // function to add my_feed to user
    

    // Function to read a user
    func getUser(userID: String, completion: @escaping (User?) -> Void) {
        db.collection("users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? ""
                let phone = data?["phone"] as? String ?? ""
                let feedsData = data?["feeds"] as? [String: Any] ?? [:]
                let feeds_visites = (feedsData["feeds_visites"] as? [[String: Any]]) ?? []
                let my_feed = (feedsData["my_feed"] as? [String: Any]) ?? [:]
                let medals = (data?["medals"] as? [[String: Any]]) ?? []
                let quests = (data?["quests"] as? [[String: Any]]) ?? []
                let eventos = (data?["eventos"] as? [[String: Any]]) ?? []
                
                let userFeeds = UserFeeds(feeds_visites: feeds_visites.map { feedData in
                    Feed(id: feedData["id"] as? String ?? "",
                         elements: (feedData["elements"] as? [[String: Any]] ?? []).map { elementData in
                            Element(id: elementData["id"] as? String ?? "",
                                    description: elementData["description"] as? String ?? "",
                                    type: elementData["type"] as? String ?? "", position: Position(x: 0, y: 0, z: 0))
                         },
                         lat: feedData["lat"] as? Double ?? 0.0,
                         lng: feedData["lng"] as? Double ?? 0.0,
                         name: feedData["name"] as? String ?? "",
                         reactions: feedData["reactions"] as? Int ?? 0)
                },
                my_feed: Feed(id: my_feed["id"] as? String ?? "",
                               elements: (my_feed["elements"] as? [[String: Any]] ?? []).map { elementData in
                                    Element(id: elementData["id"] as? String ?? "",
                                            description: elementData["description"] as? String ?? "",
                                            type: elementData["type"] as? String ?? "", position: Position(x: 0, y: 0, z: 0))
                               },
                               lat: my_feed["lat"] as? Double ?? 0.0,
                               lng: my_feed["lng"] as? Double ?? 0.0,
                               name: my_feed["name"] as? String ?? "",
                               reactions: my_feed["reactions"] as? Int ?? 0)
                )
                
                let user = User(id: userID,
                                name: name,
                                phone: phone,
                                feeds: userFeeds,
                                medals: medals.map { medalData in
                                    Activity(id: medalData["id"] as? String ?? "",
                                             name: medalData["name"] as? String ?? "",
                                             description: medalData["description"] as? String ?? "",
                                             type: medalData["type"] as? String ?? "",
                                             date: Date())
                                },
                                quests: quests.map { questData in
                                    Activity(id: questData["id"] as? String ?? "",
                                             name: questData["name"] as? String ?? "",
                                             description: questData["description"] as? String ?? "",
                                             type: questData["type"] as? String ?? "",
                                             date: Date())
                                },
                                eventos: eventos.map { eventoData in
                                    Activity(id: eventoData["id"] as? String ?? "",
                                             name: eventoData["name"] as? String ?? "",
                                             description: eventoData["description"] as? String ?? "",
                                             type: eventoData["type"] as? String ?? "",
                                             date: Date())
                                })
                                
                completion(user)

            } else {
                completion(nil)
                print("Document does not exist")
            }
        }
    }

    // function get all medals of a user
    func getMedalsOfUser(userID: String, completion: @escaping (Result<[Activity], Error>) -> Void) {
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data()
                let medals = (data?["medals"] as? [[String: Any]]) ?? []
                let userMedals = medals.map { medalData in
                    Activity(id: medalData["id"] as? String ?? "",
                             name: medalData["name"] as? String ?? "",
                             description: medalData["description"] as? String ?? "",
                             type: medalData["type"] as? String ?? "",
                             date: Date())
                }
                completion(.success(userMedals))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Document does not exist"])
                completion(.failure(error))
            }
        }
    }

    // function get all quests of a user
    func getQuestsOfUser(userID: String, completion: @escaping (Result<[Activity], Error>) -> Void) {
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data()
                let quests = (data?["quests"] as? [[String: Any]]) ?? []
                let userQuests = quests.map { questData in
                    Activity(id: questData["id"] as? String ?? "",
                             name: questData["name"] as? String ?? "",
                             description: questData["description"] as? String ?? "",
                             type: questData["type"] as? String ?? "",
                             date: Date())
                }
                completion(.success(userQuests))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Document does not exist"])
                completion(.failure(error))
            }
        }
    }

    // function get all visited feeds of a user
    func getVisitedFeedsOfUser(userID: String, completion: @escaping (Result<[Feed], Error>) -> Void) {
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Something went wrong: \(error)")
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data()
                let feedsData = data?["feeds"] as? [String: Any] ?? [:]
                let feeds_visites = (feedsData["feeds_visites"] as? [[String: Any]]) ?? []
                let userFeeds = feeds_visites.map { feedData in
                    Feed(id: feedData["id"] as? String ?? "",
                         elements: (feedData["elements"] as? [[String: Any]] ?? []).map { elementData in
                            Element(id: elementData["id"] as? String ?? "",
                                    description: elementData["description"] as? String ?? "",
                                    type: elementData["type"] as? String ?? "", position: Position(x: 0, y: 0, z: 0))
                         },
                         lat: feedData["lat"] as? Double ?? 0.0,
                         lng: feedData["lng"] as? Double ?? 0.0,
                         name: feedData["name"] as? String ?? "",
                         reactions: feedData["reactions"] as? Int ?? 0)
                }
                completion(.success(userFeeds))
            } else {
                print("Something went wrong: Document does not exist")
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Document does not exist"])
                completion(.failure(error))
            }
        }
    }
    // Function to delete a user
    func deleteUser(userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // CRUD operations for Feeds
    func createFeed(feed: Feed, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("feeds").document(feed.id).setData([
            "lat": feed.lat,
            "lng": feed.lng,
            "name": feed.name,
            "reactions": feed.reactions
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func getFeed(feedID: String, completion: @escaping (Result<Feed, Error>) -> Void) {
        db.collection("feeds").document(feedID).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data()
                let elements = data?["elements"] as? [[String: Any]] ?? []
                let lat = data?["lat"] as? Double ?? 0.0
                let lng = data?["lng"] as? Double ?? 0.0
                let name = data?["name"] as? String ?? ""
                let reactions = data?["reactions"] as? Int ?? 0
                
                let feed = Feed(id: feedID,
                                elements: elements.map { elementData in
                                    Element(id: elementData["id"] as? String ?? "",
                                            description: elementData["description"] as? String ?? "",
                                            type: elementData["type"] as? String ?? "", position: Position(x: 0, y: 0, z: 0))
                                },
                                lat: lat,
                                lng: lng,
                                name: name,
                                reactions: reactions)
                completion(.success(feed))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Document does not exist"])
                completion(.failure(error))
            }
        }
    }
    
    // CRUD Element
    func createElement(element: Element, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("elements").document(element.id).setData([
            "description": element.description,
            "type": element.type,
            "position": [
                "x": element.position.x,
                "y": element.position.y,
                "z": element.position.z
            ]
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getElement(elementID: String, completion: @escaping (Element?) -> Void) {
        db.collection("elements").document(elementID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let description = data?["description"] as? String ?? ""
                let type = data?["type"] as? String ?? ""
                let positionData = data?["position"] as? [String: Any] ?? [:]
                let position = Position(x: positionData["x"] as? Int ?? 0,
                                        y: positionData["y"] as? Int ?? 0,
                                        z: positionData["z"] as? Int ?? 0)
                
                let element = Element(id: elementID,
                                      description: description,
                                      type: type,
                                      position: position)
                completion(element)
            } else {
                completion(nil)
                print("Document does not exist")
            }
        }
    }

    // add element to feed
    func addElementToFeed(feedID: String, element: Element, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("feeds").document(feedID).collection("elements").document(element.id).setData([
            "description": element.description,
            "type": element.type,
            "position": [
                "x": element.position.x,
                "y": element.position.y,
                "z": element.position.z
            ]
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // get all elements of a feed
    func getElementsOfFeed(feedID: String, completion: @escaping (Result<[Element], Error>) -> Void) {
        db.collection("feeds").document(feedID).collection("elements").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let querySnapshot = querySnapshot {
                let elements = querySnapshot.documents.map { document in
                    let data = document.data()
                    let description = data["description"] as? String ?? ""
                    let type = data["type"] as? String ?? ""
                    let positionData = data["position"] as? [String: Any] ?? [:]
                    let position = Position(x: positionData["x"] as? Int ?? 0,
                                            y: positionData["y"] as? Int ?? 0,
                                            z: positionData["z"] as? Int ?? 0)
                    
                    return Element(id: document.documentID,
                                   description: description,
                                   type: type,
                                   position: position)
                }
                completion(.success(elements))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No documents in snapshot"])
                completion(.failure(error))
            }
        }
    }
    
    
    // CRUD Activity
    func createActivity(activity: Activity, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("activities").document(activity.id).setData([
            "name": activity.name,
            "description": activity.description,
            "type": activity.type,
            "date": activity.date
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getActivity(activityID: String, completion: @escaping (Result<Activity, Error>) -> Void) {
        db.collection("activities").document(activityID).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? ""
                let description = data?["description"] as? String ?? ""
                let type = data?["type"] as? String ?? ""
                let date = data?["date"] as? Date ?? Date()
                
                let activity = Activity(id: activityID,
                                        name: name,
                                        description: description,
                                        type: type,
                                        date: date)
                completion(.success(activity))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Document does not exist"])
                completion(.failure(error))
            }
        }
    }

    // add addActivityToFeed
    func addActivityToFeed(feedID: String, activity: Activity, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("feeds").document(feedID).collection("activities").document(activity.id).setData([
            "name": activity.name,
            "description": activity.description,
            "type": activity.type,
            "date": activity.date
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // add activity to user
    func addActivityToUser(userID: String, activity: Activity, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userID).collection("activities").document(activity.id).setData([
            "name": activity.name,
            "description": activity.description,
            "type": activity.type,
            "date": activity.date
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // get all activities of a user
    func getActivitiesOfUser(userID: String, completion: @escaping (Result<[Activity], Error>) -> Void) {
        db.collection("users").document(userID).collection("activities").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let querySnapshot = querySnapshot {
                let activities = querySnapshot.documents.map { document in
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let type = data["type"] as? String ?? ""
                    let date = data["date"] as? Date ?? Date()
                    
                    return Activity(id: document.documentID,
                                    name: name,
                                    description: description,
                                    type: type,
                                    date: date)
                }
                completion(.success(activities))
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No documents in snapshot"])
                completion(.failure(error))
            }
        }
    }
}
