//
//  ViewController.m
//  Method Swizzling
//
//  Created by nercita on 16/8/25.
//  Copyright © 2016年 nercita. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

+(void)load{
    
    SEL originalSelector = @selector(viewWillAppear:);
    SEL swizzledSelector = @selector(lxs_viewWillAppear:);
    
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    
    IMP originalIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    //给老方法添加新实现
    if (class_addMethod([self class], originalSelector, swizzledIMP, method_getTypeEncoding(swizzledMethod))) {
        //把新方法改为老实现
        //如果在本类中没有实现原方法,则返回YES,originalSelector 指向的是父类的方法,
        class_replaceMethod([self class], swizzledSelector, originalIMP, method_getTypeEncoding(swizzledMethod));
    }else{
        //本类中实现了原方法,返回NO,交换方法
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    
}

//这个方法实现与否影响是否添加成功
-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"old");
    [super viewWillAppear:animated];
}


-(void)lxs_viewWillAppear:(BOOL)animated{
    
    NSLog(@"Method Swizzling Success!");
    [self lxs_viewWillAppear:animated];
}

@end
