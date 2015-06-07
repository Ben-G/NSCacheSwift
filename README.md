#NSCacheSwift

A Swift friendly drop-in replacement for `NSCache`, built on top of `NSCache` that provides:

- Type-safety
- Using vaue types as keys and values
- Subscripts

##Basic Usage

The API is a superset of the `NSCache` API.

**Creating a cache and adding a value:**

	var cache = NSCacheSwift <String, A> ()
	cache["key"] = A()
	
##Using Value Types

Unlike `NSCache`, `NSCacheSwift` allows you to use value types as keys and values. All value types that you want to use as a key in a `NSCacheSwift` need to conform to the `Hashable` protocol. Here's a type with an example implementation:

	struct B : Hashable {
	  var id: Int
	  
	  var hashValue: Int {
	    get {
	      return id
	    }
	  }
	}
	
When your type conforms to `Hashable` you can use it as a key as following:

    var cache = NSCacheSwift <B, String> ()
    cache[B(id:1)] = "OK"
