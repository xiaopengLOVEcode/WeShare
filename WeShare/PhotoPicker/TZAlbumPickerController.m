////
////  TZAlbumPickerController.m
////  WeShare
////
////  Created by XP on 2023/11/11.
////
//
//#import "TZAlbumPickerController.h"
//#import "TZImageManager.h"
//
//@interface TZAlbumPickerController ()<UITableViewDataSource, UITableViewDelegate, PHPhotoLibraryChangeObserver> {
//    UITableView *_tableView;
//}
//@property (nonatomic, strong) NSMutableArray *albumArr;
//@end
//
//@implementation TZAlbumPickerController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    if ([[TZImageManager manager] authorizationStatusAuthorized] || !SYSTEM_VERSION_GREATER_THAN_15) {
//        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
//    }
//    self.isFirstAppear = YES;
//    if (@available(iOS 13.0, *)) {
//        self.view.backgroundColor = UIColor.tertiarySystemBackgroundColor;
//    } else {
//        self.view.backgroundColor = [UIColor whiteColor];
//    }
//    
//    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
//    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:imagePickerVc.cancelBtnTitleStr style:UIBarButtonItemStylePlain target:imagePickerVc action:@selector(cancelButtonClick)];
//    [TZCommonTools configBarButtonItem:cancelItem tzImagePickerVc:imagePickerVc];
//    self.navigationItem.rightBarButtonItem = cancelItem;
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
//    [imagePickerVc hideProgressHUD];
//    if (imagePickerVc.allowPickingImage) {
//        self.navigationItem.title = [NSBundle tz_localizedStringForKey:@"Photos"];
//    } else if (imagePickerVc.allowPickingVideo) {
//        self.navigationItem.title = [NSBundle tz_localizedStringForKey:@"Videos"];
//    }
//    
//    if (self.isFirstAppear && !imagePickerVc.navLeftBarButtonSettingBlock) {
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle tz_localizedStringForKey:@"Back"] style:UIBarButtonItemStylePlain target:nil action:nil];
//    }
//    
//    [self configTableView];
//}
//
//- (void)configTableView {
//    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
//        return;
//    }
//
//    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
//    if (self.isFirstAppear) {
//        [imagePickerVc showProgressHUD];
//    }
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [[TZImageManager manager] getAllAlbumsWithFetchAssets:!self.isFirstAppear completion:^(NSArray<TZAlbumModel *> *models) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self->_albumArr = [NSMutableArray arrayWithArray:models];
//                for (TZAlbumModel *albumModel in self->_albumArr) {
//                    albumModel.selectedModels = imagePickerVc.selectedModels;
//                }
//                [imagePickerVc hideProgressHUD];
//                
//                if (self.isFirstAppear) {
//                    self.isFirstAppear = NO;
//                    [self configTableView];
//                }
//                
//                if (!self->_tableView) {
//                    self->_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//                    self->_tableView.rowHeight = 70;
//                    if (@available(iOS 13.0, *)) {
//                        self->_tableView.backgroundColor = [UIColor tertiarySystemBackgroundColor];
//                    } else {
//                        self->_tableView.backgroundColor = [UIColor whiteColor];
//                    }
//                    self->_tableView.tableFooterView = [[UIView alloc] init];
//                    self->_tableView.dataSource = self;
//                    self->_tableView.delegate = self;
//                    [self->_tableView registerClass:[TZAlbumCell class] forCellReuseIdentifier:@"TZAlbumCell"];
//                    [self.view addSubview:self->_tableView];
//                    if (imagePickerVc.albumPickerPageUIConfigBlock) {
//                        imagePickerVc.albumPickerPageUIConfigBlock(self->_tableView);
//                    }
//                } else {
//                    [self->_tableView reloadData];
//                }
//            });
//        }];
//    });
//}
//
//@end
//
//
//@implementation TZCommonTools
//
//+ (UIEdgeInsets)tz_safeAreaInsets {
//    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
//    if (![window isKeyWindow]) {
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        if (CGRectEqualToRect(keyWindow.bounds, [UIScreen mainScreen].bounds)) {
//            window = keyWindow;
//        }
//    }
//    if (@available(iOS 11.0, *)) {
//        UIEdgeInsets insets = [window safeAreaInsets];
//        return insets;
//    }
//    return UIEdgeInsetsZero;
//}
//
//+ (BOOL)tz_isIPhoneX {
//    if ([UIWindow instancesRespondToSelector:@selector(safeAreaInsets)]) {
//        return [self tz_safeAreaInsets].bottom > 0;
//    }
//    return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
//            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)) ||
//            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896)) ||
//            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(896, 414)) ||
//            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(390, 844)) ||
//            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(844, 390)) ||
//            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(428, 926)) ||
//            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(926, 428)));
//}
//
//+ (BOOL)tz_isLandscape {
//    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight ||
//        [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft) {
//        return true;
//    }
//    return false;
//}
//
//+ (CGFloat)tz_statusBarHeight {
//    if ([UIWindow instancesRespondToSelector:@selector(safeAreaInsets)]) {
//        return [self tz_safeAreaInsets].top ?: 20;
//    }
//    return 20;
//}
//
//// 获得Info.plist数据字典
//+ (NSDictionary *)tz_getInfoDictionary {
//    NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
//    if (!infoDict || !infoDict.count) {
//        infoDict = [NSBundle mainBundle].infoDictionary;
//    }
//    if (!infoDict || !infoDict.count) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
//        infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
//    }
//    return infoDict ? infoDict : @{};
//}
//
//+ (NSString *)tz_getAppName {
//    NSDictionary *infoDict = [self tz_getInfoDictionary];
//    NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
//    if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
//    if (!appName) appName = [infoDict valueForKey:@"CFBundleExecutable"];
//    if (!appName) {
//        infoDict = [NSBundle mainBundle].infoDictionary;
//        appName = [infoDict valueForKey:@"CFBundleDisplayName"];
//        if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
//        if (!appName) appName = [infoDict valueForKey:@"CFBundleExecutable"];
//    }
//    return appName;
//}
//
//+ (BOOL)tz_isRightToLeftLayout {
//    if (@available(iOS 9.0, *)) {
//        if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft) {
//            return YES;
//        }
//    } else {
//        NSString *preferredLanguage = [NSLocale preferredLanguages].firstObject;
//        if ([preferredLanguage hasPrefix:@"ar-"]) {
//            return YES;
//        }
//    }
//    return NO;
//}
//
//+ (void)configBarButtonItem:(UIBarButtonItem *)item tzImagePickerVc:(TZImagePickerController *)tzImagePickerVc {
//    item.tintColor = tzImagePickerVc.barItemTextColor;
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = tzImagePickerVc.barItemTextColor;
//    textAttrs[NSFontAttributeName] = tzImagePickerVc.barItemTextFont;
//    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    
//    NSMutableDictionary *textAttrsHighlighted = [NSMutableDictionary dictionary];
//    textAttrsHighlighted[NSFontAttributeName] = tzImagePickerVc.barItemTextFont;
//    [item setTitleTextAttributes:textAttrsHighlighted forState:UIControlStateHighlighted];
//}
//
//+ (BOOL)isICloudSyncError:(NSError *)error {
//    if (!error) return NO;
//    if ([error.domain isEqualToString:@"CKErrorDomain"] || [error.domain isEqualToString:@"CloudPhotoLibraryErrorDomain"]) {
//        return YES;
//    }
//    return NO;
//}
//
//+ (BOOL)isAssetNotSelectable:(TZAssetModel *)model tzImagePickerVc:(TZImagePickerController *)tzImagePickerVc {
//    BOOL notSelectable = tzImagePickerVc.selectedModels.count >= tzImagePickerVc.maxImagesCount;
//    if (tzImagePickerVc.selectedModels && tzImagePickerVc.selectedModels.count > 0 && !tzImagePickerVc.allowPickingMultipleVideo) {
//        if (model.asset.mediaType == PHAssetMediaTypeVideo) {
//            notSelectable = true;
//        }
//    }
//    return notSelectable;
//}
//
//@end
