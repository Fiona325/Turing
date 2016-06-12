//
//  ViewController.m
//  Day08_1_Message
//
//  Created by tarena on 15/10/8.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRMainViewController.h"
#import "TRMessage.h"
#import "TRMessageCell.h"
#import "TRRTuringRequestManager.h"
#import "KeyString.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+WebCache.h"
#import "TRPictureCell.h"
#import "MBProgressHUD.h"
#import "TRRVoiceRecognitionManager.h"
#import "TRRTuringAPIConfig.h"
#import "TRRSpeechSythesizer.h"



@interface TRMainViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate,TRRVoiceRecognitionManagerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) TRRVoiceRecognitionManager *sharedInstance;
@property (strong, nonatomic) UIButton *voiceRecordButton;

@property(nonatomic,strong) NSMutableArray *messages;
//list
@property(nonatomic,strong)NSArray*lists;
//定位相关
@property(nonatomic,strong)CLLocationManager*mgr;
@property(nonatomic,assign)CLLocationDegrees latitude;
@property(nonatomic,assign)CLLocationDegrees longitude;
@property(nonatomic,strong)NSString*cityName;
//语音识别
@property (nonatomic, strong) TRRSpeechSythesizer *sythesizer;

@end
@implementation TRMainViewController
TRRTuringAPIConfig *apiConfig;
TRRTuringRequestManager *apiRequest;


//======Lazy Loading======//
- (NSMutableArray *)messages{
    if (!_messages) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *tempArray = [ NSMutableArray array];
        for(NSDictionary *dict in array)
        {
            TRMessage *message=[TRMessage messageWithDict:dict];
            [tempArray addObject:message];
        }
        _messages = tempArray;
    }
    return _messages;
}
- (CLLocationManager*)mgr{
    if (_mgr == nil) {
        _mgr = [[CLLocationManager alloc]init];
    }
    return _mgr;
}
- (NSArray*)lists {
    if (!_lists) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}
- (TRRSpeechSythesizer*)sythesizer{
    if (!_sythesizer) {
        _sythesizer = [[TRRSpeechSythesizer alloc] initWithAPIKey:BaiduAPIKey secretKey:BaiduSecretKey];
    }
    return _sythesizer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    apiConfig = [[TRRTuringAPIConfig alloc] initWithAPIKey:TuringAPIKey];
    apiRequest = [[TRRTuringRequestManager alloc] initWithConfig:apiConfig];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //注册Cell
    [_tableView registerClass:[TRMessageCell class] forCellReuseIdentifier:@"message"];
    [_tableView registerClass:[TRPictureCell class] forCellReuseIdentifier:@"picture"];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pattern"]];
    [self getUserLoaction];
    //创建手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
}
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRMessage *message = self.messages[indexPath.row];
    NSLog(@"messageCode:%d",message.code);
    if ((message.code == 302000) || (message.code == 308000)){
        TRPictureCell*pCell = [tableView dequeueReusableCellWithIdentifier:@"picture"];
        pCell.message = message;
        [pCell loadPictureCell:message];
       
        return pCell;
    }else{
        TRMessageCell*mCell = [tableView dequeueReusableCellWithIdentifier:@"message"];
        mCell.message = message; //这一步调用的set方法
        
        return mCell;
    }
}
//通过协议方法设置不同的cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ((TRMessageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath]).cellHeight;
}
#pragma mark - 监听事件
//将要显示时，添加对键盘的监听事件
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    /*
     关于键盘的监听为什么要根据视图的显示和消失来进行增加删除？
     答:假设有两个界面A和B视图控制器，A和B中都有输入框，都可以监听输入框的弹出进行相应的界面变化。 那么当A推出B时，A已经不显示给用户了，但是当B中输入框被点击，弹出键盘。系统会发送全局的键盘弹出通知， 那么A界面也会收到这个通知，并执行界面变化操作，这个操作是多余的且不准确的，因为它响应的是B界面的键盘显示事件。
     所以 我们要在A界面消失时，删除它的键盘监听。 只有当A界面展现给用户时 才注册键盘监听。
     */
}
//弹出键盘时触发
-(void)openKeyboard:(NSNotification *)notification{
    //键盘弹出动画时长 NSTimeInterval == long
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘弹出的动画效果
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    //键盘弹出后的位置
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //当键盘弹出后，表格需要移动到最后一行
    //取得最后一行内容的index值
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    //动画移动 输入框容器
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        _vConstraint.constant = endFrame.size.height;
    } completion:^(BOOL finished) {
        //表格滚动到最后一行
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
    [self.view layoutIfNeeded];
}
//键盘消失时触发
-(void)closeKeyboard:(NSNotification *)notification{
    //键盘弹出动画时长 NSTimeInterval == long
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘弹出的动画效果
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    //键盘消失，表格内容滚动到最后一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        _vConstraint.constant = 0;
    } completion:^(BOOL finished) {
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
    [self.view layoutIfNeeded];
}
- (IBAction)sendAction:(id)sender {
    //点击发送按钮触发此方法，清空输入框并发送消息
    [self sendMessage];
}
- (IBAction)hideKeyBoard:(id)sender {
    //点击return按钮触发此方法，清空输入框并发送消息
    [self sendMessage];
    
}
-(void)sendMessage{
    if (_textField.text.length >0) {
        //创建数据类型
        TRMessage *message = [TRMessage new];
        message.type = TRMessageTypeMe;
        message.text = _textField.text;
        [self.messages addObject:message];
        [self sendMessages:_textField.text];
        //清空文本框
        _textField.text = @"";
        //刷新列表
        NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_textField resignFirstResponder];
}
- (void)sendMessages:(NSString*)textField{
    
    //    NSString*string = nil;
    //    if (self.latitude!= 0.0 & self.longitude != 0.0) {
    //        NSString*city = [self.cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //        string = [NSString stringWithFormat: @"http://www.tuling123.com/openapi/api?key=c7492b8f210dc5cdbf76b3bde66a7c32&&info=%@&&lat=%d&&lon=%d&&%@",textField.text,(int)(self.latitude*1e+006), (int)(self.longitude*1e+006),city];
    //         string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    }else{
    //         string = [NSString stringWithFormat:@"http://www.tuling123.com/openapi/api?key=c7492b8f210dc5cdbf76b3bde66a7c32&&info=%@", textField.text];
    //        string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    }
    //       NSURL* url = [NSURL URLWithString:string];
    //
    //    // 2
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    [manager GET:url.absoluteString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //
    //        NSLog(@"%@",responseObject);
    ////        NSString*text = responseObject[@"text"];
    ////        NSString*urlStr = responseObject[@"url"];
    ////        NSString*code = responseObject[@"code"];
    //        TRMessage*message = [TRMessage messageWithResponseObject:responseObject];
    //            message.type = TRMessageTypeRobot;
    //       NSMutableArray*listsArray = [TRList lists:responseObject];
    //       self.lists = listsArray;
    //        TRList*list1 = listsArray[0];
    //        NSLog(@"LISTARRAY :%@",self.cell.listArray);
    ////        TRList*list2 = listsArray[1];
    //        NSLog(@"name%@",list1.name);
    //        NSLog(@"info%@",list1.info);
    //
    //
    //        [self.messages addObject:message];
    //        [self.tableView reloadData];
    //        //message.text = text;
    //      //  NSLog(@"%@",text);
    //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    //            //表格滚动到最后一行
    //            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    //
    //        [self.view layoutIfNeeded];
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"error : %@",error);
    //    }];
    [apiConfig request_UserIDwithSuccessBlock:^(NSString *str) {
       // NSLog(@"result = %@", str);
        [apiRequest request_OpenAPIWithInfo:textField successBlock:^(NSDictionary *dict) {
           //NSLog(@"apiResult =%@",dict);
            TRMessage*message = [TRMessage messageWithResponseObject:dict];
            message.type = TRMessageTypeRobot;
            message.listArray = [TRMessage listsWithDictionary:dict];
            //每次语音处理之前先把合成器停止
            [self.sythesizer stop];
            //开始合成语音
            [self.sythesizer start:dict[@"text"]];
            
            [self.messages addObject:message];
            [self.tableView reloadData];
            //message.text = text;
            //  NSLog(@"%@",text);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
            //表格滚动到最后一行
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
            [self.view layoutIfNeeded];
            
        } failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
            
            NSLog(@"errorinfo = %@", infoStr);
        }];
    }
                                    failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
                                        
                                        NSLog(@"erroresult = %@", infoStr);
                                    }];
    
}


- (IBAction)voiceBtnAction:(UIButton *)sender {
    //[self.voiceButton setSelected:!self.voiceButton.selected]
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        [self.textField resignFirstResponder];
        self.textField.hidden = YES;
        self.recordBtn.hidden = NO;
        
        [self recordBtnAction];
    }else{
        [self.textField becomeFirstResponder];
        self.textField.hidden = NO;
        self.recordBtn.hidden = YES;
    }
    
}
- (void)recordBtnAction{
    [self.recordBtn addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    [self.recordBtn addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
    [self.recordBtn addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
}

- (void)onStartRecognize {
    NSLog(@"正在语音识别，请讲话");
}

- (void)onSpeechStart {
    NSLog(@"检测到已说话");
}

- (void)onSpeechEnd {
    NSLog(@"检测到已停止说话");
    
}
/**
 *  开始录音
 */
- (void)startRecordVoice{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    
    _hud.label.text = @"录音中...";
    
    _sharedInstance=[TRRVoiceRecognitionManager sharedInstance];
    [_sharedInstance setApiKey:BaiduAPIKey secretKey:BaiduSecretKey];
    _sharedInstance.delegate = self;
    NSArray *array = @[@(20000)];
    _sharedInstance.recognitionPropertyList = array;
    [_sharedInstance startVoiceRecognition];
    
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice{
    [_sharedInstance cancleRecognize];
    //    _hud.mode = MBProgressHUDModeText;
    _hud.label.text = @"录音取消！";
    //    _hud.removeFromSuperViewOnHide = YES;
    [_hud hideAnimated:YES];
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice{
    
    [_sharedInstance stopRecognize];
    [_hud hideAnimated:YES];
    
}
/**
 *  更新录音显示状态,手指向上滑动后提示松开取消录音
 */

- (void)updateCancelRecordVoice{
    //    _hud.label.text = @"向下移继续录音...";
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice{
    //    _hud.label.text = @"向上移取消录音...";
}


- (void)onRecognitionResult:(NSString *)result {
    if(result.length > 0){
        TRMessage *message = [TRMessage new];
        message.type = TRMessageTypeMe;
        message.text = result;
        [self.messages addObject:message];
        [self sendMessages:result];
        //刷新列表
        NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
        NSLog(@"...%@", result);
    }else{
        //        _hud.mode = MBProgressHUDModeText;
        _hud.label.text = @"声音不能识别！";
        [_hud hideAnimated:YES afterDelay:0.5];
        NSLog(@"result = %@", result);
    }
    
}

- (void)onRecognitionError:(NSString *)errStr {
    
    if (errStr) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.label.text = @"声音不能识别！";
        [_hud hideAnimated:YES afterDelay:0.5];
    }
    
    NSLog(@"Error = %@", errStr);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//================================
#pragma mark - CLLocation
- (void)getUserLoaction{
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [self.mgr requestWhenInUseAuthorization];
    }else{
        NSLog(@"iOS8以下不支持该功能");
    }
    self.mgr.delegate = self;
    self.latitude = 0.0;
    self.longitude = 0.0;
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation*location = [locations lastObject];
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    NSLog(@"纬度%d 经度%d",(int)(self.latitude*1e+006),(int)(self.longitude*1e+006));
    CLGeocoder*coder = [CLGeocoder new];
    CLLocation*lct = [[CLLocation alloc]initWithLatitude:self.latitude longitude:self.longitude];
    [coder reverseGeocodeLocation:lct completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark*placemark in placemarks) {
            //NSLog(@"info:%@",placemark.addressDictionary);
            NSString*cityname = placemark.addressDictionary[@"Name"];
            if (cityname != nil) {
                self.cityName = cityname;
            }
            NSLog(@"cityName:%@",self.cityName);
        }
    }];
    
    //    NSLog(@"%@",location.);
    [self.mgr stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"用户允许定位");
        self.mgr.desiredAccuracy = kCLLocationAccuracyBest;
        [self.mgr startUpdatingLocation];
        
    }else if (status == kCLAuthorizationStatusDenied){
        NSLog(@"用户拒绝定位");
    }
}

@end
