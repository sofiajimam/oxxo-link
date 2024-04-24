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
        db.collection("users").document(userId).updateData([
            "medals": FieldValue.arrayUnion([medal])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func addQuestToUser(userId: String, quest: Activity, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userId).updateData([
            "quests": FieldValue.arrayUnion([quest])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func addEventToUser(userId: String, event: Activity, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userId).updateData([
            "eventos": FieldValue.arrayUnion([event])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func addVisitedFeedToUser(userId: String, feed: Feed, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userId).updateData([
            "feeds.feeds_visites": FieldValue.arrayUnion([feed])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

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
    func createFeed(feed: Feed, completion: @escaping (Error?) -> Void) {
        db.collection("feeds").document(feed.id).setData([
            "elements": feed.elements.map { element in
                [
                    "id": element.id,
                    "description": element.description,
                    "type": element.type,
                    "position": [
                        "x": element.position.x,
                        "y": element.position.y,
                        "z": element.position.z
                    ]
                ]
            },
            "lat": feed.lat,
            "lng": feed.lng,
            "name": feed.name,
            "reactions": feed.reactions
        ]) { error in
            completion(error)
        }
    }

    func getFeed(feedID: String, completion: @escaping (Feed?) -> Void) {
        db.collection("feeds").document(feedID).getDocument { (document, error) in
            if let document = document, document.exists {
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
                completion(feed)
            } else {
                completion(nil)
                print("Document does not exist")
            }
        }
    }
    
    // CRUD Element
    func createElement(element: Element, completion: @escaping (Error?) -> Void) {
        db.collection("elements").document(element.id).setData([
            "description": element.description,
            "type": element.type,
            "position": [
                "x": element.position.x,
                "y": element.position.y,
                "z": element.position.z
            ]
        ]) { error in
            completion(error)
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

    // get all elements of a feed
    func getElementsOfFeed(feedID: String, completion: @escaping ([Element]) -> Void) {
        db.collection("feeds").document(feedID).collection("elements").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
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
                completion(elements)
            } else {
                completion([])
                print("Error getting elements of feed: \(error)")
            }
        }
    }
    
    
    // CRUD Activity
    func createActivity(activity: Activity, completion: @escaping (Error?) -> Void) {
        db.collection("activities").document(activity.id).setData([
            "name": activity.name,
            "description": activity.description,
            "type": activity.type,
            "date": activity.date
        ]) { error in
            completion(error)
        }
    }
    
    func getActivity(activityID: String, completion: @escaping (Activity?) -> Void) {
        db.collection("activities").document(activityID).getDocument { (document, error) in
            if let document = document, document.exists {
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
                completion(activity)
            } else {
                completion(nil)
                print("Document does not exist")
            }
        }
    }

    // get all activities of a user
    func getActivitiesOfUser(userID: String, completion: @escaping ([Activity]) -> Void) {
        db.collection("users").document(userID).collection("activities").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
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
                completion(activities)
            } else {
                completion([])
                print("Error getting activities of user: \(error)")
            }
        }
    }
}
