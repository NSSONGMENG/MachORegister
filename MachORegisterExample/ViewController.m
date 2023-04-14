//
//  ViewController.m
//  MachORegisterExample
//
//  Created by song.meng on 2021/5/25.
//

#import "ViewController.h"
#import <MachORegister/MachORegister.h>


MachORegisterK_VSet(router, AViewController)
MachORegisterK_VSet(router, BViewController)
MachORegisterK_VSet(router, CViewController)
MachORegisterK_VSet(router, DViewController)
MachORegisterK_VSet(router, EViewController)

MachORegisterK_V(name, song.meng)
MachORegisterK_V(address, 北京市朝阳区)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MachORegister shareRegister].enableLog = YES;
    
    NSSet * set = MachORegisterGetVSetWithKey(@"router");
    
    NSLog(@"%@", set);
    
    NSString *name = MachORegisterGetVWithKey(@"name");
    NSString *addr = MachORegisterGetVWithKey(@"address");
    NSString *phone = MachORegisterGetVWithKey(@"phone");   // 未注册

    NSLog(@"name : %@", name);
    NSLog(@"addr : %@", addr);
    NSLog(@"phone : %@", phone);
}


@end
