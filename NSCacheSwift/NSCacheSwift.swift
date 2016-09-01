//
//  NSCacheSwift.swift
//  ConvenienceKit
//
//  Created by Benjamin Encz on 6/4/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import Foundation

public class NSCacheSwift<T: Hashable, U> {
  
  private let cache: NSCache
  
  public var delegate: NSCacheDelegate? {
    get {
      return cache.delegate
    }
    set {
      cache.delegate = delegate
    }
  }
  
  public var name: String {
    get {
      return cache.name
    }
    set {
      cache.name = name
    }
  }
  
  public var totalCostLimit: Int {
    get {
      return cache.totalCostLimit
    }
    set {
      cache.totalCostLimit = totalCostLimit
    }
  }
  
  public var countLimit: Int {
    get {
      return cache.countLimit
    }
    set {
      cache.countLimit = countLimit
    }
  }
  
  public var evictsObjectsWithDiscardedContent: Bool {
    get {
      return cache.evictsObjectsWithDiscardedContent
    }
    set {
      cache.evictsObjectsWithDiscardedContent = evictsObjectsWithDiscardedContent
    }
  }
  
  public init() {
    cache = NSCache()
  }
  
  public func objectForKey(key: T) -> U? {
    let key: AnyObject = replaceKeyIfNeccessary(key)

    let value = cache.objectForKey(key) as? U
      ?? (cache.objectForKey(key) as? Container<U>)?.content
    
    return value
  }

  public func setObject(obj: U, forKey key: T) {
    let object: AnyObject = obj as? AnyObject ?? Container(content: obj)
    let key: AnyObject = replaceKeyIfNeccessary(key)
    
    cache.setObject(object, forKey: key)
  }
  
  public func setObject(obj: U, forKey key: T, cost g: Int) {
    cache.setObject(obj as! AnyObject, forKey: key as! AnyObject, cost: g)
  }
  
  public func removeObjectForKey(key: T) {
    let key: AnyObject = replaceKeyIfNeccessary(key)
    cache.removeObjectForKey(key)
  }
  
  public func removeAllObjects() {
    cache.removeAllObjects()
  }
  
  public subscript(key: T) -> U? {
    get {
      return objectForKey(key)
    }
    set(newValue) {
      if let newValue = newValue {
        setObject(newValue, forKey: key)
      }
    }
  }
  
  // MARK: Wrapping Value Types into Reference Type Containers
  
  /*
    NSCache can only store types that conform to AnyObject. It compares keys by object identity.    To allow value types as keys, NSCacheSwift requires keys to conform to Hashable.    NSCacheSwift then creates an NSObject for each unique value (as determined by equality) that acts as the key in NSCache.
  */
  private var keyReplacers = [T : NSObject]()
  
  private func replaceKeyIfNeccessary(originalKey :T) -> AnyObject {
    let key: AnyObject? = originalKey as? AnyObject ?? keyReplacers[originalKey]
    
    if let key: AnyObject = key {
      return key
    } else {
      let container = NSObject()
      keyReplacers[originalKey] = container
      
      return container
    }
  }
  
}

private class Container<T> {
  private (set) var content: T
  
  init(content: T) {
    self.content = content
  }
}
