//
//  ViewController.m
//  智能花盆
//
//  Created by Phoenix on 2017/4/14.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property(nonatomic)NSURLConnection *connect;
@property(nonatomic)NSURLSession *session;
@property(nonatomic)NSMutableData *data;
@property(nonatomic)NSMutableURLRequest *req;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"我的花盆";
    NSString *urlString=@"http://api.yeelink.net/v1.0/device/357266/sensor/405317/datapoint/2017-05-19T22:13:14";
    NSURL *url=[[NSURL alloc]initWithString:urlString];
    _req=[NSMutableURLRequest requestWithURL:url];
    //[_req setHTTPMethod:@"DELETE"];
    [_req addValue:@"3e6556233e31d2f606704b2cd1dd25e6" forHTTPHeaderField:@"U-ApiKey"];
    _data=[[NSMutableData alloc]init];
    [self fetch];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"错误：%@",error);
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
    NSLog(@"返回信息\n%ld\n%@",(long)httpResponse.statusCode,httpResponse.allHeaderFields);
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data{
    [_data appendData:data];
    NSLog(@"收到数据");
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *str=[[NSString alloc]initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"输出%@",str);
    NSDictionary *jsonObject=[NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    self.temperatureLabel.text=[NSString stringWithFormat:@"温度：%@°C",jsonObject[@"value"]];
}
-(void)fetch{
    _connect=[NSURLConnection connectionWithRequest:_req delegate:self];
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
