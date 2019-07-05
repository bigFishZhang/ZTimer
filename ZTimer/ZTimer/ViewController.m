//
//  ViewController.m
//  ZTimer
//
//  Created by zhang zhengbin on 2019/7/5.
//  Copyright © 2019 zhang zhengbin. All rights reserved.
//

#import "ViewController.h"
#import "ZTimer.h"
@interface ViewController ()
/**<#desc#>*/
@property (nonatomic,copy)NSString * task;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.task = [ZTimer execTask:^{
//        NSLog(@"hello %@",[NSThread currentThread]);
//    } start:2 interval:1 repeats:YES async:YES];
//    
    self.task = [ZTimer execTask:self selector:@selector(test) start:2 interval:1 repeats:YES async:YES];
    
   
}

- (void)test {
    NSLog(@"%s",__func__);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [ZTimer cancelTask:self.task];
}

@end
