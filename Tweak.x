#import <Twitter/Twitter.h>

//@author: Joseph Fabisevich
//Settings additions by @pathkiller29
//@version: 1.1

%config(generator=internal)
@class ViewController;
@interface SBBulletinListView : UIView
{
    UIView *_slidingView;
}
- (id)slidingView;
- (id)initWithFrame:(struct CGRect)fp8 delegate:(id)fp24;
@end

static BOOL enabled;
static BOOL closeNC;
static NSString *position;

static void LoadSettings() {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.pathkiller.quicktweet.plist"];
	enabled = [[dict objectForKey:@"enabled"] boolValue] ? [[dict objectForKey:@"enabled"] boolValue] : YES;
	closeNC = [[dict objectForKey:@"shouldClose"] ? [[dict objectForKey:@"shouldClose"] : YES;
	position = [[dict objectForKey:@"position"] copy];
	[dict release];	
}

%hook SBBulletinListView
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate {
	if (enabled) {
		if ((self = %orig)) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			[button setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/QuickTweet/QuickTweet.png"] forState:UIControlStateNormal];
			int x = ([position isEqualToString:@"2"]) ? self.frame.size.width-63 : 8;
			button.frame = CGRectMake(x, self.frame.size.height-28, 55, 24);
			UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTweet)];
			[button addGestureRecognizer:tap];
			[self.slidingView addSubview:button];
			[tap release];
			[button release];
		}
	} else {
		%orig;
	}	
	return self;
}

%new(v@:)

-(void)showTweet {
	if (shouldClose) [[objc_getClass("SBBulletinListController") sharedInstance] hideListViewAnimated:YES];

	UIWindow *originalWindow = [[UIApplication sharedApplication] keyWindow];

	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	UIViewController *viewController = [[UIViewController alloc] init];
	
	window.windowLevel = UIWindowLevelAlert;
	window.rootViewController = viewController;
	[window makeKeyAndVisible];
		
	TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];

	[viewController presentViewController:twitter animated:YES completion:nil];

	twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) 
	{	
		[viewController dismissModalViewControllerAnimated:YES];
			
		[viewController release];
		[window release];
	
		[originalWindow makeKeyAndVisible];
	};	
}
%end 

%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)LoadSettings, CFSTR("com.pathkiller.quicktweet/prefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();
	[pool drain];
}