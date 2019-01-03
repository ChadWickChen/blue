


#import "MBProgressHUD.h"

@interface MBProgressHUD (PY)
/** 显示成功信息 */
+ (void)CD_showSuccess:(NSString *)success toView:(UIView *)view;
/** 显示失败信息 */
+ (void)CD_showError:(NSString *)error toView:(UIView *)view;
/** 显示加载信息 */
+ (void)CD_showLoading:(NSString *)loading toView:(UIView *)view;

@end
