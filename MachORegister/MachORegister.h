//
//  MachORegister.h
//  Pods
//
//  Created by song.meng on 2021/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MachORegister : NSObject
// 是否允许打印注册日志
@property (nonatomic, assign) BOOL enableLog;

+ (instancetype)shareRegister;


/// 获取key对应的value集合
/// @param key key
- (NSSet * __nullable)shareStringSetWithKey:(NSString *)key;

/// 移除key对应的集合
- (void)removeValueSetWithKey:(NSString *)key;


/// 获取key对应的value
/// @param key key
- (NSString * __nullable)shareStringWithKey:(NSString *)key;

/// 移除key对应的value
- (void)removeValueWithKey:(NSString *)key;


@end


#pragma mark - define -

struct MachORegisterKV {
    char *key;
    char *value;
};



//
// key对应value的集合，使用场景：一个业务key对应很多子业务的value，如：router对应众多class
// 【注】： key允许重复，key和value不允许同时重复
// 【使用】:
//  MachORegisterK_VSet(router, AViewController)
//  MachORegisterK_VSet(router, BViewController)
#define MachORegisterK_VSet(key, value) \
__attribute((used, section("__DATA, mach_o_kvset"))) \
static const struct MachORegisterKV ___MachORegisterK_VSet_##key##value = (struct MachORegisterKV){(char *)(&#key), (char *)(&#value)};

// get方法
#define MachORegisterGetVSetWithKey(key)    [[MachORegister shareRegister] shareStringSetWithKey:key];



//
// key对应value，一一对应
// 【注】：key不允许重复
// 【使用】:
// MachORegisterK_V(InnerVersion, 2492)
#define MachORegisterK_V(key, value) \
__attribute((used, section("__DATA, mach_o_kv"))) \
static const struct MachORegisterKV ___MachORegisterKV_##key = (struct MachORegisterKV){(char *)(&#key), (char *)(&#value)};

// get方法
#define MachORegisterGetVWithKey(key)   [[MachORegister shareRegister] shareStringWithKey:key];




NS_ASSUME_NONNULL_END
