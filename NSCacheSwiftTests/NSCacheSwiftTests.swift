//
//  NSCacheSwiftTests.swift
//  NSCacheSwiftTests
//
//  Created by Benjamin Encz on 6/5/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import UIKit
import XCTest
import NSCacheSwift

struct A {}

struct B : Hashable {
  var id: Int
  
  var hashValue: Int {
    get {
      return id
    }
  }
}

class CacheDelegate: NSObject, NSCacheDelegate {
  
  var receivedDelegateCall = false
  
  func cache(cache: NSCache, willEvictObject obj: AnyObject) {
    receivedDelegateCall = true
  }
}

func ==(lhs: B, rhs: B) -> Bool {
  return lhs.id == rhs.id
}

class NSCacheSwiftTests: XCTestCase {
  
  // MARK: Additional NSCacheSwift Functionality
  
  func testCanAddValueTypesAsValues() {
    let cache = NSCacheSwift <String, A> ()
    cache["key"] = A()

    let value = cache["key"]
    XCTAssertTrue(value != nil)
  }
  
  func testCanUseValueTypeAsKey() {
    let cache = NSCacheSwift <B, String> ()
    cache[B(id:1)] = "OK"
    
    let value = cache[B(id: 1)]
    XCTAssertTrue(value == "OK")
  }
  
  func testComparesEqualityOfValueTypeKeys() {
    let cache = NSCacheSwift <B, String> ()
    cache[B(id:1)] = "OK"
    
    let value = cache[B(id: 2)]
    XCTAssertTrue(value == nil)
  }
  
  func testCanRemoveWithValueTypeKeys() {
    let cache = NSCacheSwift <B, String> ()
    cache[B(id:1)] = "OK"
    
    cache.removeObjectForKey(B(id:1))
    let value = cache[B(id: 1)]
    XCTAssertTrue(value == nil)
  }
  
  // MARK: Existing NSCache Functionality
  
  func testRemoveAll() {
    let cache = NSCacheSwift <NSObject, NSObject> ()
    let key = NSObject()
    cache.setObject(NSObject(), forKey: key)
    cache.removeAllObjects()
    
    XCTAssertTrue(cache[key] == nil)
  }
  
}
