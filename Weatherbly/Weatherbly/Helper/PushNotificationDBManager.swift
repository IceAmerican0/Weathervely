//
//  PushNotificationDBManager.swift
//  Weatherbly
//
//  Created by Khai on 5/24/24.
//

import Foundation
import SQLite3

public final class PushNotificationDBManager {
    static let shared = PushNotificationDBManager()
    private var db: OpaquePointer?
    private let path = "notifications.sqlite"
    
    private init() {
        openDB()
        createTable()
    }
    
    /// DB 불러오기
    private func openDB() {
        var log = ""
        
        do {
            let path = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ).appendingPathComponent(path)
            
            if sqlite3_open(path.path, &db) == SQLITE_OK {
                log = "DB Opened"
            } else {
                log = "Error Opening DB"
            }
        } catch {
            log = "DB Not Prepared"
        }
        
        debugPrint(log)
    }
    
    /// 알림 테이블 생성
    private func createTable() {
        let createQuery = """
                          CREATE TABLE IF NOT EXISTS
                          notifications(
                          id INTEGER PRIMARY KEY AUTOINCREMENT,
                          category TEXT,
                          title TEXT,
                          message TEXT,
                          date TEXT);
                          """
        
        var createTableStatement: OpaquePointer?
        var log = ""
        
        if sqlite3_prepare_v2(db, createQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                log = "Table Created"
            } else {
                log = "Table Not Created"
            }
        } else {
            log = "CREATE TABLE Statement Not Prepared"
        }
        
        debugPrint(log)
        sqlite3_finalize(createTableStatement)
    }
    
    /// 리스트 불러오기
    public func readAllNotifications() -> [PushNotification] {
        let query = "SELECT * FROM notifications ORDER BY id DESC;"
        var statement: OpaquePointer?
        var notifications: [PushNotification] = []
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id       = sqlite3_column_int(statement, 0)
                let category = columnTextToString(statement: statement, row: 1)
                let title    = columnTextToString(statement: statement, row: 2)
                let message  = columnTextToString(statement: statement, row: 3)
                let date     = columnTextToString(statement: statement, row: 4)
                
                notifications.append(
                    .init(
                        id:       Int(id),
                        category: category,
                        title:    title,
                        message:  message,
                        date:     date
                    )
                )
            }
            debugPrint("SELECT SUCCESS\n\(notifications)")
        } else {
            debugPrint("SELECT Statement Not Prepared")
        }
        
        sqlite3_finalize(statement)
        return notifications
    }
    
    /// 알림 추가
    public func addNotification(category: String, title: String, message: String, date: String) {
        let query = "INSERT INTO notifications (category, title, message, date) VALUES (?, ?, ?, ?);"
        var statement: OpaquePointer?
        var log = ""
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (category as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (message as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (date as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                log = """
                      INSERT SUCCESS
                      category: \(category)
                      title: \(title)
                      message: \(message)
                      date: \(date)
                      """
            } else {
                log = "INSERT FAILED"
            }
        } else {
            log = "INSERT Statement Not Prepared"
        }
        
        debugPrint(log)
        sqlite3_finalize(statement)
    }
    
    /// 알림 삭제
    public func deleteNotification(id: Int) -> Bool {
        let query = "DELETE FROM notifications WHERE id = ?;"
        var statement: OpaquePointer?
        var log = ""
        var result = false
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                log = "DELETE SUCCESS\nid: \(id)"
                result = true
            } else {
                log = "INSERT FAILED"
            }
        } else {
            log = "DELETE Statement Not Prepared"
        }
        
        debugPrint(log)
        sqlite3_finalize(statement)
        return result
    }
    
    /// 알림 30일 자동 삭제
    public func deleteOldNotification() {
        let query = "DELETE FROM notifications WHERE date < datetime('now', '-30 days');"
        var statement: OpaquePointer?
        var log = ""
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                log = "DELETE SUCCESS"
            } else {
                log = "INSERT FAILED"
            }
        } else {
            log = "DELETE Statement Not Prepared"
        }
        
        debugPrint(log)
        sqlite3_finalize(statement)
    }
    
    private func columnTextToString(statement: OpaquePointer?, row: Int32) -> String {
        String(describing: String(cString: sqlite3_column_text(statement, row)))
    }
}
