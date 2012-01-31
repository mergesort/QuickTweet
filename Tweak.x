#import <Twitter/Twitter.h>

//@author: Joseph Fabisevich
//@version: 1.0

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
	if ((self = %orig))
	{
		UIButton *tweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
		[tweetButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/QuickTweet/QuickTweet.png"] forState:UIControlStateNormal];

		tweetButton.frame = CGRectMake(8, self.frame.size.height-28, 55, 24);
			
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quickTweet_popTweetPane)];
		tap.numberOfTapsRequired = 1;
	
		[tweetButton addGestureRecognizer: tap];
		[self.slidingView addSubview: tweetButton];	
	}
	
	return self;
}

%new 

-(void) quickTweet_popTweetPane
{
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