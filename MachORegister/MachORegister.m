//
//  MachORegister.m
//  Pods
//
//  Created by song.meng on 2021/5/25.
//

#import "MachORegister.h"
#import <dlfcn.h>
#import <mach-o/getsect.h>

@interface MachORegister()

@property (nonatomic, strong)NSMutableDictionary <NSString *, NSMutableSet *>* multiInfo;
@property (nonatomic, strong)NSMutableDictionary <NSString *, NSString *>* singlInfo;

@property (nonatomic, strong)dispatch_semaphore_t   multiLcok;
@property (nonatomic, strong)dispatch_semaphore_t   singlLcok;

@end

@implementation MachORegister

+ (instancetype)shareRegister {
    static MachORegister *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MachORegister new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _multiLcok = dispatch_semaphore_create(1);
        _singlLcok = dispatch_semaphore_create(1);
        _multiInfo = [NSMutableDictionary dictionary];
        _singlInfo = [NSMutableDictionary dictionary];
    }
    return self;
}


- (NSSet * __nullable)shareStringSetWithKey:(NSString *)key {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self prepareMultiData];
    });
    
    if (!key) {
        return nil;
    }
    
    dispatch_semaphore_wait(_multiLcok, DISPATCH_TIME_FOREVER);
    NSMutableSet *set = [_multiInfo objectForKey:key];
    dispatch_semaphore_signal(_multiLcok);
    
    if (set) {
        return [set copy];
    }
    return nil;
}

- (void)removeValueSetWithKey:(NSString *)key {
    if (!key) {
        return;
    }
    
    dispatch_semaphore_wait(_multiLcok, DISPATCH_TIME_FOREVER);
    [_multiInfo removeObjectForKey:key];
    dispatch_semaphore_signal(_multiLcok);
}

- (NSString * __nullable)shareStringWithKey:(NSString *)key {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self prepareSinglData];
    });
    
    if (!key) {
        return nil;
    }
    
    dispatch_semaphore_wait(_singlLcok, DISPATCH_TIME_FOREVER);
    NSString *value = [_singlInfo objectForKey:key];
    dispatch_semaphore_signal(_singlLcok);
    
    return value;
}

- (void)removeValueWithKey:(NSString *)key {
    if (!key) {
        return;
    }
    
    dispatch_semaphore_wait(_singlLcok, DISPATCH_TIME_FOREVER);
    [_singlInfo removeObjectForKey:key];
    dispatch_semaphore_signal(_singlLcok);
}


#pragma mark - marh o

#ifdef __LP64__
typedef uint64_t MarchORegisterValue;
typedef struct section_64 MarchORegisterSection;
#define MachOGetSectByNameFromHeader getsectbynamefromheader_64
#else
typedef uint32_t MarchORegisterValue;
typedef struct section MarchORegisterSection;
#define MachOGetSectByNameFromHeader getsectbynamefromheader
#endif

void __marhORegisterEmptyFouncation(void){
    // 空实现，为拿到当前image的Dl_info
}

- (void)prepareMultiData {
    _multiInfo = [NSMutableDictionary dictionaryWithCapacity:512];
    
    Dl_info info;
    dladdr((const void*)&__marhORegisterEmptyFouncation, &info);

    const MarchORegisterValue   mach_header = (MarchORegisterValue)info.dli_fbase;
    const MarchORegisterSection *section = MachOGetSectByNameFromHeader((void *)mach_header, "__DATA", "mach_o_kvset");
    
    if (section != NULL) {
        int addrOffset = sizeof(struct MachORegisterKV);
        MarchORegisterValue maxAddr = section->offset + section->size;
        
        for (MarchORegisterValue addr = section->offset; addr < maxAddr; addr += addrOffset) {
            struct MachORegisterKV entry = *(struct MachORegisterKV *)(mach_header + addr);
            
            if (entry.key && entry.value) {
                NSString *key = [NSString stringWithCString:entry.key encoding:NSUTF8StringEncoding];
                NSString *value = [NSString stringWithCString:entry.value encoding:NSUTF8StringEncoding];
                if (!key || !value) {
                    continue;
                }
                
                NSMutableSet *set = [_multiInfo objectForKey:key];
                if (!set) {
                    set = [NSMutableSet setWithCapacity:126];
                    [_multiInfo setObject:set forKey:key];
                }
                [set addObject:value];
    
#ifdef DEBUG
                if (_enableLog) {
                    NSLog(@"【MachORegister K-VSet】key: %@ - value:%@", key, value);
                }
#endif
            }
        }
    }
}

- (void)prepareSinglData {
    _singlInfo = [NSMutableDictionary dictionaryWithCapacity:512];
    
    Dl_info info;
    dladdr((const void*)&__marhORegisterEmptyFouncation, &info);

    const MarchORegisterValue   mach_header = (MarchORegisterValue)info.dli_fbase;
    const MarchORegisterSection *section = MachOGetSectByNameFromHeader((void *)mach_header, "__DATA", "mach_o_kv");
    
    if (section != NULL) {
        int addrOffset = sizeof(struct MachORegisterKV);
        MarchORegisterValue maxAddr = section->offset + section->size;
        
        for (MarchORegisterValue addr = section->offset; addr < maxAddr; addr += addrOffset) {
            struct MachORegisterKV entry = *(struct MachORegisterKV *)(mach_header + addr);
            
            if (entry.key && entry.value) {
                NSString *key = [NSString stringWithCString:entry.key encoding:NSUTF8StringEncoding];
                NSString *value = [NSString stringWithCString:entry.value encoding:NSUTF8StringEncoding];
                if (value && key) {
                    [_singlInfo setObject:value forKey:key];
                }
                
#ifdef DEBUG
                if (_enableLog) {
                    NSLog(@"【MachORegister K-V】key: %@ - value:%@", key, value);
                }
#endif
            }
        }
    }
}

@end
