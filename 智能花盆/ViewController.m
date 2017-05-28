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


@interface ViewController ()<NSURLSessionDataDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *waterBtn;
@property (weak, nonatomic) IBOutlet UILabel *humidOut;
@property (weak, nonatomic) IBOutlet UILabel *temperatureOut;
@property (weak, nonatomic) IBOutlet UILabel *humidSoil;

@property (weak, nonatomic) IBOutlet UILabel *suitableTemp;
@property (weak, nonatomic) IBOutlet UILabel *suitableHumid;
@property (weak, nonatomic) IBOutlet STLoopProgressView *loopProgressSoil;
@property (weak, nonatomic) IBOutlet STLoopProgressView *loopProgressOut;

@property (weak, nonatomic) IBOutlet MAThermometer *thermometerOut;

@property(nonatomic)NSTimer *timer;
@property(nonatomic)NSURLSession *session;
@end

@implementation ViewController
bool flag = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    _session=[NSURLSession sharedSession];
    _timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(fetch) userInfo:nil repeats:YES];
    [_thermometerOut setMaxValue:50.0];
    [self performSelector:@selector(start) withObject:nil afterDelay:2.0];
}
- (IBAction)water:(id)sender {
    NSLog(@"%d",flag);
    if (flag==0) {
        flag=1;
        NSString *urlString=@"http://blynk-cloud.com/897d2e7dd84041fb9d209e5825592d83/update/V3?value=1000";
        NSURL *url=[[NSURL alloc]initWithString:urlString];
        NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:url];
        NSURLSessionDataTask *task = [_session dataTaskWithRequest:req completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {}];
        [task resume];
        //[self performSelector:@selector(waterStop) withObject:nil afterDelay:4.0];
    }else{
        [self waterStop];
    }
    
    
}
- (void)start {
    _suitableTemp.text=@"适宜温度：15~26°C";
    _suitableHumid.text=@"适宜湿度：50~60%";
}
-(void)waterStop{
    NSString *urlString=@"http://blynk-cloud.com/897d2e7dd84041fb9d209e5825592d83/update/V3?value=500";
    NSURL *url=[[NSURL alloc]initWithString:urlString];
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:req completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {flag=0;}];
    [task resume];
}
-(void)viewDidAppear:(BOOL)animated{
//    [self fetch];
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
                      _loopProgressSoil.persentage=value/1000;
                      _humidSoil.text=[NSString stringWithFormat:@"%d%%",(int)value/10];
                  });
              }];
    [task1 resume];
    
    //获取外界湿度
    url=[[NSURL alloc]initWithString:@"http://blynk-cloud.com/897d2e7dd84041fb9d209e5825592d83/get/V2"];
    req=[NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *task2 = [_session dataTaskWithRequest:req completionHandler:
              ^(NSData *data, NSURLResponse *response, NSError *error) {
                  NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                  float value=[(NSString *)array[0] floatValue];
                  
                  //插入到主线程中更新UI
                  dispatch_async(dispatch_get_main_queue(), ^{
                      _loopProgressOut.persentage=value/100;
                      _humidOut.text=[NSString stringWithFormat:@"%d%%",(int)value];
                  });
              }];
    [task2 resume];
    
    //获取外界温度
    url=[[NSURL alloc]initWithString:@"http://blynk-cloud.com/897d2e7dd84041fb9d209e5825592d83/get/V0"];
    req=[NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *task3 = [_session dataTaskWithRequest:req completionHandler:
              ^(NSData *data, NSURLResponse *response, NSError *error) {
                  NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                  float value=[(NSString *)array[0] floatValue];
                  
                  //插入到主线程中更新UI
                  dispatch_async(dispatch_get_main_queue(), ^{
                      _thermometerOut.curValue=value;
                      _temperatureOut.text=[NSString stringWithFormat:@"%d°C",(int)value];
                  });
              }];
    [task3 resume];
    
    
    
    

}
- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    //如果支持相机就打开相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.allowsEditing=YES;
    imagePicker.delegate=self;
    
    //以模态显示UIImagePickerController对象
    [self presentViewController:imagePicker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //通过info字典获取选择的照片
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    
    [_pictureButton setImage:image forState:UIControlStateNormal];
    //关闭UIImagPickerController
    [self dismissViewControllerAnimated:YES completion:nil];
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
