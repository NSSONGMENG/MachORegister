

## MarchORegister
#### 简介：通过编译期将数据注册至`mach-o`的形式，提供去中心化的注册机制，为组件间解耦提供解决方案

#### 能力：
    1. 支持注册/获取key-value
    2. 支持注册/获取key-value集合
    
    
key-value场景：
如需全局访问的变量：如AppBusinessVersion、全局开关等，注册后可根据key获取对应的value值
 ```
 /// 注册
 MachORegisterK_V(AppBusinessVersion, 1.0.0.1)

 /// 获取
 NSString *innerVersion = MachORegisterGetVWithKey(@"AppBusinessVersion") // 宏定义方式
 NSString *businessVersion = [[MachORegister shareRegister] shareStringWithKey:@"AppBusinessVersion"]; // 方法调用方式
```
    
key-value_set场景：
如router注册，注册后可根据@"router"获取对应的类名集合
 ```
 /// 注册
 MachORegisterK_VSet(router, AViewController)
 MachORegisterK_VSet(router, BViewController)
 MachORegisterK_VSet(router, CViewController)
 MachORegisterK_VSet(router, DViewController)
 MachORegisterK_VSet(router, EViewController)

 /// 获取
 NSSet *set = MachORegisterGetVSetWithKey(@"router")    // 宏定义方式
 NSSet *set = [[MachORegister shareRegister] shareStringSetWithKey:@"router"]; // 方法调用方式
```


【注】：所有通过宏定义注册的key-value均需强打，用`"xx"`的形式会报错

