//
//  DBClient.swift
//  Colombia
//
//  Created by 伊藤凌也 on 2021/03/13.
//

import RealmSwift

struct DBClient {

    static let shared = DBClient()

    private let realm = try! Realm()

    /// DB にオブジェクトを作成。
    /// - Parameter object: 作成するオブジェクト
    /// - Returns: Result
    func create<T: Object>(object: T) -> Result<T, DBError> {
        do {
            try realm.write {
                // Workaround: .error を指定したかったが、すでに primary_key が存在する場合
                // `logic_error` がスローされてしまっており、ランタイムのエラーじゃないので捕捉できない
                realm.add(object, update: .modified)
            }
            return .success(object)
        } catch let e {
            return .failure(.unknown(e))
        }
    }

    /// DB からオブジェクトを削除。
    /// - Parameter object: 削除するオブジェクト
    /// - Returns: Result
    func delete<T: Object>(object: T) -> Result<T, DBError> {
        do {
            try realm.write {
                realm.delete(object)
            }
            return .success(object)
        } catch let e {
            return .failure(.unknown(e))
        }
    }

    /// DB からオブジェクトを取得
    /// - Returns:
    func select<T: Object>(condition: String = "") -> [T] {
        let objects = realm.objects(T.self)
        if condition.isEmpty {
            return Array(objects)
        }
        return Array(objects.filter(condition))
    }

    /// DB からオブジェクトを　ID で取得
    /// - Parameter id: ID
    /// - Returns: Result
    func item<T: Object>(id: Int) -> Result<T, DBError> {
        guard let object = realm.object(ofType: T.self, forPrimaryKey: id) else {
            return .failure(DBError.itemNotFound)
        }
        return .success(object)
    }
}
