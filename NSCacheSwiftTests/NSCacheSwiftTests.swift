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
    var cache = NSCacheSwift <String, A> ()
    cache["key"] = A()

    var value = cache["key"]
    XCTAssertTrue(value != nil)
  }
  
  func testCanUseValueTypeAsKey() {
    var cache = NSCacheSwift <B, String> ()
    cache[B(id:1)] = "OK"
    
    var value = cache[B(id: 1)]
    XCTAssertTrue(value == "OK")
  }
  
  func testComparesEqualityOfValueTypeKeys() {
    var cache = NSCacheSwift <B, String> ()
    cache[B(id:1)] = "OK"
    
    var value = cache[B(id: 2)]
    XCTAssertTrue(value == nil)
  }
  
  func testCanRemoveWithValueTypeKeys() {
    var cache = NSCacheSwift <B, String> ()
    cache[B(id:1)] = "OK"
    
    cache.removeObjectForKey(B(id:1))
    var value = cache[B(id: 1)]
    XCTAssertTrue(value == nil)
  }
  
  // MARK: Existing NSCache Functionality
  
  func testRemoveAll() {
    var cache = NSCacheSwift <NSObject, NSObject> ()
    var key = NSObject()
    cache.setObject(NSObject(), forKey: key)
    cache.removeAllObjects()
    
    XCTAssertTrue(cache[key] == nil)
  }
  
}
