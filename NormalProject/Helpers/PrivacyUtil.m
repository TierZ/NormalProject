//
//  PrivacyUtil.m
//  NormalProject
//
//  Created by lf on 16/10/18.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "PrivacyUtil.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>

@implementation PrivacyUtil
#pragma mark - part-1

+ (void)requestCamera:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
    } else {
        [self showAlertView:@"提示" message:@"当前设备不支持拍照"];
        return;
    }
    float iOSVer = [[UIDevice currentDevice].systemVersion floatValue];

    if (iOSVer >= 7.0) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        NSLog(@"camera status [ %zd ] [ iOS7 later ] ", status);
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                // 第一次向申请权限，系统弹出授权提示框，发起授权许可
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) { // 物理设备类(AVMediaTypeVideo,AVMediaTypeAudio)
                    if (granted) {
                        // 点击了【好】
                        if (enable) {
                            enable();
                        }
                    }else{
                        // 点击了【不允许】
                    }
                }];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                // 相机设备无法访问
            }
            case AVAuthorizationStatusDenied: {
                // 用户明确过拒绝
                if (disable) {
                    disable();
                } else {
                    [self showAlertView:@"无法使用相机设备" message:@"请在手机的“设置->隐私->相机”中允许访问相机"];
                }
                /*
                 UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n尚未开启相机授权，请到---设置---" preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 // UIAlertActionStyleDefault 蓝色
                 }];
                 UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 // UIAlertActionStyleCancel 蓝色粗体
                 }];
                 UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"other" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                 // UIAlertActionStyleDestructive 红色
                 }];
                 [avc addAction:okAction];
                 [avc addAction:otherAction];
                 [avc addAction:cancelAction];
                 [self presentViewController:avc animated:NO completion:nil];
                 */
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                // 已经开启授权，可以使用
                if (enable) {
                    enable();
                }
                /* 打开相机的示例代码，非详细使用
                 UIImagePickerController* cameraPicker = [[UIImagePickerController alloc] init];
                 cameraPicker.delegate = self;
                 cameraPicker.allowsEditing = YES;
                 cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                 [self presentViewController:imagePicker animated:YES completion:nil];
                 */
                break;
            }
            default:
                break;
        }
        
    } else {
        // iOS7 before
    }
}
+ (void)requestMicrophone:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable {
    // http://www.jianshu.com/p/5429f00d717e
    // http://www.jianshu.com/p/d407d2d477f1
    float iOSVer = [[UIDevice currentDevice].systemVersion floatValue];

    if (iOSVer >= 7.0) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        NSLog(@"microphone status [ %zd ] [ iOS7 later ]", status);
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    if (granted) {
                        // 点击了【好】
                        if (enable) {
                            enable();
                        }
                    }else{
                        // 点击了【不允许】
                    }
                }];
                break;
            }
            case AVAuthorizationStatusRestricted: {

            }
            case AVAuthorizationStatusDenied: {

                if (disable) {
                    disable();
                } else {
                    [self showAlertView:@"无法使用麦克风设备" message:@"请在手机的“设置->隐私->麦克风”中允许访问麦克风"];
                }
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                // 已经开启授权，可以使用
                if (enable) {
                    enable();
                }
                break;
            }
            default:
                break;
        }
        
    } else {
        // iOS7 before
    }
}
+ (void)requestPhotoLibrary:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable {
    // 首先查看当前设备是否支持相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 支持
    } else {
        [self showAlertView:@"提示" message:@"当前设备不支持相册"];
        return;
    }
    float iOSVer = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVer < 8.0) {
        // 没真机，不好测
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        NSLog(@"photo library status [ %zd ] [ iOS 8 before ]", status);
        switch (status) {
            case ALAuthorizationStatusNotDetermined: {
                // 第一次向申请权限，系统弹出授权提示框，发起授权许可
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                }];
                break;
            }
            case ALAuthorizationStatusRestricted: {
                // 相册无法访问
            }
            case ALAuthorizationStatusDenied: {
                // 用户明确拒绝
                if (disable) {
                    disable();
                } else {
                    [self showAlertView:@"无法使用相册" message:@"请在手机的“设置->隐私->相册”中允许访问相册"];
                }
                break;
            }
            case ALAuthorizationStatusAuthorized: {
                // 已经开启授权，可以使用
                if (enable) {
                    enable();
                }
                /* 使用相册示例
                UIImagePickerController*  imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
                 */
            }
            default:
                break;
        }
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        NSLog(@"photo library status [ %zd ] [ iOS 8 and later ]", status);
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            NSLog(@"request status[ %zd ]", status);
            switch (status) {
                case PHAuthorizationStatusNotDetermined: {
                    //
                    break;
                }
                case PHAuthorizationStatusRestricted: {
                    // 不可用
                }
                case PHAuthorizationStatusDenied: {
                    // 拒绝
                    if (disable) {
                        disable();
                    } else {
                        [self showAlertView:@"无法使用相册" message:@"请在手机的“设置->隐私->相册”中允许访问相册"];
                    }
                    break;
                }
                case PHAuthorizationStatusAuthorized: {
                    if (enable) {
                        enable();
                    }
                    break;
                }
                default:
                    break;
            }
        }];
    }
}

+ (void)requestAddressBook:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable {
    // http://www.jianshu.com/p/df0ea100c3da
    float iOSVer = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVer < 9.0) { // 9之前
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        NSLog(@"address book status [ %zd ] [ iOS9 before ]", status);
        switch (status) {
            case kABAuthorizationStatusNotDetermined: {
                // 申请使用通讯录
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    if (granted) {
                        // 点击【好】
                        if (enable) {
                            enable();
                        }
                    }else{
                        // 点击【拒绝】
                    }
                    CFRelease(addressBook);
                });
                break;
            }
            case kABAuthorizationStatusRestricted: {

            }
            case kABAuthorizationStatusDenied: {
                if (disable) {
                    disable();
                } else {
                    [self showAlertView:@"无法使用通讯录" message:@"请在手机的“设置->隐私->通讯录”中允许访问通讯录"];
                }
                break;
            }
            case kABAuthorizationStatusAuthorized: {
                if (enable) {
                    enable();
                }
                /* 通讯录使用
                ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc] init];
                ppnc.peoplePickerDelegate = self;
                [self presentViewController:ppnc animated:YES completion:nil];
                 */
                break;
            }
            default:
                break;
        }
    } else {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        NSLog(@"address book status [ %zd ] [ iOS9 later ]", status);
        switch (status) {
            case CNAuthorizationStatusNotDetermined: {
                CNContactStore *contactStore = [[CNContactStore alloc] init];
                [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        // 点击【好】
                        if (enable) {
                            enable();
                        }
                    }else{
                        // 点击【拒绝】
                    }
                }];
                break;
            }
            case CNAuthorizationStatusRestricted: {
                
            }
            case CNAuthorizationStatusDenied: {
                if (disable) {
                    disable();
                } else {
                    [self showAlertView:@"无法使用通讯录" message:@"请在手机的“设置->隐私->通讯录”中允许访问通讯录"];
                }
                break;
            }
            case CNAuthorizationStatusAuthorized: {
                if (enable) {
                    enable();
                }
                /* 使用方法
                 CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
                 contactVc.delegate = self;
                 [self presentViewController:contactVc animated:YES completion:nil];
                 */
            }
            default:
                break;
        }
    }
}
#pragma mark - part-2
+ (void)checkRemoteNotificationStatus:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable {
    float iOSVer = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVer >= 8.0) { //iOS8及以上
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIRemoteNotificationTypeNone) {
            // 不允许
            if (disable) {
                disable();
            }
        } else {
            // 允许
            if (enable) {
                enable();
            }
        };
    }else{ // iOS7及以下
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
            // 不允许
            if (disable) {
                disable();
            }
        } else {
            // 允许
            if (enable) {
                enable();
            }
        }
    }
}

+ (void)checkLocationStatus:(PrivacyEnabledBlock)enable disable:(PrivacyDisabledBlock)disable {
    if ([CLLocationManager locationServicesEnabled]) {
        //
    } else {
        //
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            
            break;
        }
        case kCLAuthorizationStatusRestricted: {
            
        }
        case kCLAuthorizationStatusDenied: {
            
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways: { // kCLAuthorizationStatusAuthorized
            
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            
            break;
        }
        default:
            break;
    }
}
#pragma mark - part-3
NSString *const PrivacyPrefsSetting      = @"prefs:root=INTERNET_TETHERING";
NSString *const PrivacyPrefsGeneral      = @"prefs:root=General";
NSString *const PrivacyPrefsWIFI         = @"prefs:root=WIFI";
NSString *const PrivacyPrefsBluetooth    = @"prefs:root=Bluetooth";
NSString *const PrivacyPrefsNetwork      = @"prefs:root=MOBILE_DATA_SETTINGS_ID";
NSString *const PrivacyPrefsNotification = @"prefs:root=NOTIFICATIONS_ID";
NSString *const PrivacyPrefsPrivacy      = @"prefs:root=privacy";
NSString *const PrivacyPrefsLocation     = @"prefs:root=LOCATION_SERVICES";
+ (BOOL)openSystemSetting:(PrivacyType)type {
    // 如果需要继续向项目内层进行跳转，可以通过添加path路径的方式，如:@"应用通知":@"prefs:root=NOTIFICATIONS_ID&path=应用的boundleI iOS10+不允许了
    float iOSVer = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVer >= 10.0) {
        NSLog(@"iOS10+ 不允许打开系统设置选项");
        return NO;
    }
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *prefs = UIApplicationOpenSettingsURLString;
    switch (type) {
        case PrivacyTypeSetting: {
            prefs = PrivacyPrefsSetting;
            break;
        }
        case PrivacyTypeGeneral: {
            prefs = PrivacyPrefsGeneral;
            break;
        }
        case PrivacyTypeWiFi: {
            prefs = PrivacyPrefsWIFI;
            break;
        }
        case PrivacyTypeBluetooth: {
            prefs = PrivacyPrefsBluetooth;
            break;
        }
        case PrivacyTypeNetwork: {
            prefs = PrivacyPrefsNetwork;
            break;
        }
        case PrivacyTypeNotification: {
            prefs = PrivacyPrefsNotification;
            break;
        }
        case PrivacyTypePrivacy: {
            prefs = PrivacyPrefsPrivacy;
            break;
        }
        case PrivacyTypeLocation: {
            prefs = PrivacyPrefsLocation;
        }
        default:
            break;
    }
    NSURL *url = [NSURL URLWithString:prefs];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        return [[UIApplication sharedApplication] openURL:url];
    } else {
        return NO;
    }
}
#pragma mark - private
+ (void)showAlertView:(NSString *)title message:(NSString *)message {
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
