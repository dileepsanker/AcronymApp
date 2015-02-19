//
//  ViewController.m
//  ACAcronym
//
//  Created by Dileep on 17/02/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "ACCommon.h"

@interface ViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *progressHUD;
}
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) NSMutableDictionary *representativeDict;
@property (weak, nonatomic) IBOutlet UITextView *meaningTextView;
@property (weak, nonatomic) IBOutlet UITextField *enterAcroTxtField;
- (IBAction)onClickSearchButton:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickSearchButton:(id)sender {
    
    if([[ACCommon trimWhiteSpaces:_enterAcroTxtField.text] isEqualToString:@""])
    {
        UIAlertController *alert = [ACCommon applicationAlertWithMessage:ACString(@"STR_ENTR_ACR") delegate:self];
         [self presentViewController:alert animated:YES completion:nil];
        return;
    }
 
    [self showProgressView];
    [self callWebService];
}

- (void)showProgressView
{
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.color = [UIColor lightGrayColor];
    [self.view addSubview:progressHUD];
    progressHUD.delegate = self;
    [progressHUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
    
}

- (void)callWebService
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setObject:_enterAcroTxtField.text forKey:@"sf"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:SERVICE_URL
      parameters:parameterDic
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if([responseObject count]>0)
             {
                 NSMutableDictionary *longFormObjects = [[responseObject objectAtIndex:0] objectForKey:@"lfs"];
                 _representativeDict = [[NSMutableDictionary alloc] init];
                 
                 for (NSMutableDictionary *longFormObj in longFormObjects) {
                     NSMutableArray *varsArray = [[NSMutableArray alloc] init];
                     for (NSMutableDictionary *varsObj in [longFormObj objectForKey:@"vars"] ) {
                         [varsArray addObject:[varsObj objectForKey:@"lf"]];
                     }
                     [_representativeDict setObject:varsArray forKey:[longFormObj objectForKey:@"lf"]];
                     varsArray = nil;
                 }
                 [self getUpdateDict:_representativeDict];
             }
             else{
                 UIAlertController *alert = [ACCommon applicationAlertWithMessage:ACString(@"STR_NO_RESULTS") delegate:self];
                 [self presentViewController:alert animated:YES completion:nil];
                 _meaningTextView.text = @"";
                
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [progressHUD hide:YES];
         }];

}

- (void)getUpdateDict:(NSMutableDictionary*)meaningDict
{
    NSString *stringFormat= @"";
   for( NSString *aKey in [meaningDict allKeys] )
    {
        stringFormat = [stringFormat stringByAppendingString:[NSString stringWithFormat:@"%@ \n",aKey]];
        for( NSString *kValue in [meaningDict objectForKey:aKey] )
        {
            stringFormat = [stringFormat stringByAppendingString:[NSString stringWithFormat:@"-%@ \n",kValue]];
        }
        stringFormat = [stringFormat stringByAppendingString:@"\n\n"];
    }
    _meaningTextView.text = stringFormat;
    [progressHUD hide:YES afterDelay:2];
}

- (void)myProgressTask {
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        progressHUD.progress = progress;
        usleep(50000);
    }
}
#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [progressHUD removeFromSuperview];
    progressHUD = nil;
}
#pragma mark - text field delegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.text = [ACCommon trimWhiteSpaces:textField.text];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL valid = YES;
    valid = ![ACCommon validateForNumbers:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    return valid;
}


@end
