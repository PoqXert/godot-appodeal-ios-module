//
//  helper.h
//  
//
//  Created by Poq Xert on 13.07.2020.
//

#ifndef helper_h
#define helper_h

#include "core/object.h"
#import <Foundation/Foundation.h>

Variant nsobjectToVariant(NSObject *object) {
    if([object isKindOfClass:[NSString class]]) {
        const char *str = [(NSString *)object UTF8String];
        return String::utf8(str != NULL ? str : "");
    } else if([object isKindOfClass:[NSData class]]) {
        PoolByteArray arr;
        NSData *data = (NSData *)object;
        if([data length] > 0) {
            arr.resize([data length]);
            {
                PoolByteArray::Write w = arr.write();
                copymem(w.ptr(), [data bytes], [data length]);
            }
        }
        return arr;
    } else if([object isKindOfClass:[NSArray class]]) {
        Array arr;
        NSArray *array = (NSArray *)object;
        unsigned int count = [array count];
        for(unsigned int i = 0; i < count; ++i) {
            NSObject *value = [array objectAtIndex:i];
            arr.push_back(nsobjectToVariant(value));
        }
        return arr;
    } else if([object isKindOfClass:[NSDictionary class]]) {
        Dictionary res;
        NSDictionary *dic = (NSDictionary *)object;
        NSArray *keys = [dic allKeys];
        unsigned int count = [keys count];
        for(unsigned int i = 0; i < count; ++i) {
            NSObject *key = [keys objectAtIndex:i];
            NSObject *val = [dic objectForKey:key];
            res[nsobjectToVariant(key)] = nsobjectToVariant(val);
        }
        return res;
    } else if([object isKindOfClass:[NSNumber class]]) {
        NSNumber *num = (NSNumber *)object;
        if(strcmp([num objCType], @encode(BOOL)) == 0) {
            return Variant((int)[num boolValue]);
        } else if(strcmp([num objCType], @encode(char)) == 0) {
            return Variant((int)[num charValue]);
        } else if(strcmp([num objCType], @encode(int)) == 0) {
            return Variant((int)[num intValue]);
        } else if(strcmp([num objCType], @encode(unsigned int)) == 0) {
            return Variant((int)[num unsignedIntValue]);
        } else if(strcmp([num objCType], @encode(long long)) == 0) {
            return Variant((int)[num longValue]);
        } else if(strcmp([num objCType], @encode(float)) == 0) {
            return Variant([num floatValue]);
        } else if(strcmp([num objCType], @encode(double)) == 0) {
            return Variant((float)[num doubleValue]);
        } else {
            return Variant();
        }
    } else {
        return Variant();
    }
}

NSObject *variantToNSObject(Variant v) {
    if(v.get_type() == Variant::STRING) {
        NSString *str = [[[NSString alloc] initWithUTF8String:((String)v).utf8().get_data()] autorelease];
        return str;
    } else if(v.get_type() == Variant::REAL) {
        return [NSNumber numberWithDouble:(double)v];
    } else if(v.get_type() == Variant::INT) {
        return [NSNumber numberWithLongLong:(long)(int)v];
    } else if(v.get_type() == Variant::BOOL) {
        return [NSNumber numberWithBool:BOOL((bool)v)];
    } else if(v.get_type() == Variant::DICTIONARY) {
        NSMutableDictionary *res = [[[NSMutableDictionary alloc] init] autorelease];
        Dictionary dict = v;
        Array keys = dict.keys();
        unsigned int count = keys.size();
        for(unsigned int i = 0; i < count; ++i) {
            NSString *key = [[[NSString alloc] initWithUTF8String:((String)(keys[i])).utf8().get_data()] autorelease];
            NSObject *val = variantToNSObject(dict[keys[i]]);
            if(key == NULL || val == NULL) {
                return NULL;
            }
            [res setObject:val forKey:key];
        }
        return res;
    } else if(v.get_type() == Variant::ARRAY) {
        NSMutableArray *res = [[[NSMutableArray alloc] init] autorelease];
        Array arr = v;
        unsigned int count = arr.size();
        for(unsigned int i = 0; i < count; ++i) {
            NSObject *val = variantToNSObject(arr[i]);
            if(val == NULL) {
                return NULL;
            }
            [res addObject:val];
        }
        return res;
    } else if (v.get_type() == Variant::POOL_BYTE_ARRAY) {
        PoolByteArray arr = v;
        PoolByteArray::Read r = arr.read();
        NSData *res = [NSData dataWithBytes:r.ptr() length:arr.size()];
        return res;
    } else {
        return NULL;
    }
}

Dictionary nsdictionaryToDictionary(NSDictionary *dict) {
    return nsobjectToVariant(dict);
}

NSDictionary *dictionaryToNSDictionary(Dictionary dict) {
    return (NSDictionary *)variantToNSObject(dict);
}

Array nsarrayToArray(NSArray *arr) {
    return nsobjectToVariant(arr);
}

NSArray *arrayToNSArray(Array arr) {
    return (NSArray *)variantToNSObject(arr);
}

#endif /* helper_h */
