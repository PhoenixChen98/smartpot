//
//  ViewController.m
//  智能花盆
//
//  Created by Phoenix on 2017/4/14.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "ViewController.h"
#import "STLoopProgressView.h"
#import "MAThermometer.h"


@interface ViewController ()<NSURLSessionDataDelegate>
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property(nonatomic)NSURLSession *session;
@property (weak, nonatomic) IBOutlet STLoopProgressView *loopProgress;
@property (weak, nonatomic) IBOutlet MAThermometer *thermometerSoil;
@property (weak, nonatomic) IBOutlet MAThermometer *thermometerOut;
@property(nonatomic)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"start");
    _session=[NSURLSession sharedSession];
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fetch) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}
- (IBAction)test:(id)sender {
    static int i=5;
    i+=5;
    NSLog(@"i的值%d",i);
    NSString *urlString=[NSString stringWithFormat:@"http://blynk-cloud.com/897d2e7dd84041fb9d209e5825592d83/update/V1?value=%d",i];
    NSURL *url=[[NSURL alloc]initWithString:urlString];
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:req completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {}];
    [task resume];
}
-(void)viewDidAppear:(BOOL)animated{
    [self fetch];
    [_timer setFireDate:[NSDate distantPast]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [_timer setFireDate:[NSDate distantFuture]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetch{
    //获取土壤湿度
    NSURL *url=[[NSURL alloc]initWithString:@"http://blynk-cloud.com/897d2e7dd84041fb9d209e5825592d83/get/V1"];
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *task1 = [_session dataTaskWithRequest:req completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
          NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          float value=[(NSString *)array[0] floatValue];
          
          //插入到主线程中更新UI
          dispatch_async(dispatch_get_main_queue(), ^{
              _loopProgress.persentage=value/100;
              _thermometerSoil.curValue=value;
          });
      }];
    [task1 resume];
    
    //获取外界温度
    url=[[NSURL alloc]initWithString:@"http://blynk-cloud.com/897d2e7dd84041fb9d209e5825592d83/get/V0"];
    req=[NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *task2 = [_session dataTaskWithRequest:req completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
          NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          float value=[(NSString *)array[0] floatValue];
          
          //插入到主线程中更新UI
          dispatch_async(dispatch_get_main_queue(), ^{
//              _loopProgress.persentage=value/100;
//              _thermometerSoil.curValue=value;
          });
      }];
    [task2 resume];
    
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
