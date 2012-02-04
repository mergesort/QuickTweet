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

%hook SBBulletinListView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
	NSString *filePath = @"/var/mobile/Library/Preferences/com.pathkiller.quicktweet.plist";
	NSMutableDictionary* plist = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];

	NSString *position = [plist objectForKey:@"position"];
	BOOL enabled = ([plist objectForKey:@"enabled"] != nil) ? [[plist objectForKey:@"enabled"] boolValue] : YES;

	if(filePath == nil)
		enabled = YES;
		
	if(!enabled)
	{
		%orig;
	}
	else
	{
		if ((self = %orig))
		{
			UIButton *tweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
			[tweetButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/QuickTweet/QuickTweet.png"] forState:UIControlStateNormal];
	
			int x = ([position isEqualToString:@"2"]) ? self.frame.size.width-63 : 8;
			tweetButton.frame = CGRectMake(x, self.frame.size.height-28, 55, 24);
	
			UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quickTweet_popTweetPane)];
			tap.numberOfTapsRequired = 1;
	
			[tweetButton addGestureRecognizer: tap];
			[self.slidingView addSubview: tweetButton];	
		}
	}	
	return self;
}

%new(v@:)

-(void) quickTweet_popTweetPane
{
	NSString *filePath = @"/var/mobile/Library/Preferences/com.pathkiller.quicktweet.plist";
	NSMutableDictionary* plist = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];

	BOOL shouldClose = ([plist objectForKey:@"shouldClose"] != nil) ? [[plist objectForKey:@"shouldClose"] boolValue] : YES;

	if(filePath == nil)
		shouldClose = YES;

	if(shouldClose)
        [[objc_getClass("SBBulletinListController") sharedInstance] hideListViewAnimated:YES];

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