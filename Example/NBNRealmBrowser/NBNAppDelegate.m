#import "NBNAppDelegate.h"
#import "NBNViewController.h"
#import <Realm/Realm.h>

#define isIOS8 __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

@implementation NBNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    NBNViewController *viewController = [[NBNViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navController;

    [self copyDataBaseIfNeeded];

    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 1;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < 1) {
        // Nothing to do!
       }
    };

    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)copyDataBaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbPath = [self dbPath];
    if (![fileManager fileExistsAtPath:dbPath]) {
        NSString *bundleDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"default.realm"];
        [fileManager copyItemAtPath:bundleDBPath toPath:dbPath error:nil];
    }
}

- (NSString *)dbPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    return [documentsDirectory stringByAppendingPathComponent:@"default.realm"];
}

@end
