    //
//  WebViewController.m
//  iLook
//
//  Created by Zhang Yinghui on 7/6/11.
//  Copyright 2011 LavaTech. All rights reserved.
//

#import "BrowserController.h"
#import "BCommon.h"

@interface BrowserController()
@property (nonatomic, retain) NSURL *curUrl;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIBarButtonItem *backBtn;
@property (nonatomic, retain) UIBarButtonItem *forwardBtn;
@property (nonatomic, retain) UILabel *urlLabel;
@property (nonatomic, retain) UILabel *titleLabel;
- (void) freshUI;
- (void) syncPageTitle;
@end


@implementation BrowserController
@synthesize url = _url;
@synthesize curUrl = _curUrl;
@synthesize webView = _webView;
@synthesize backBtn = _backBtn;
@synthesize forwardBtn = _forwardBtn;
@synthesize urlLabel = _urlLabel;
@synthesize titleLabel = _titleLabel;


- (void)dealloc {
	RELEASE(_url);
    RELEASE(_webView);
    RELEASE(_backBtn);
    RELEASE(_forwardBtn);
    RELEASE(_urlLabel);
    RELEASE(_titleLabel);
    [super dealloc];
}

- (id) initWithUrlString:(NSString *)urlString{	
    if (self = [super init]) {
        _url = [[NSURL URLWithString:urlString] retain];
	}
	return self;
};
- (id) initWithURL:(NSURL *)url{
    if (self = [super init]) {
        _url = [url retain];
	}
	return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
	self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
	self.webView.delegate = self;
	self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:self.webView];
	
	// left
	self.backBtn = createBarImageButtonItem(@"backward", self, @selector(goBack));
    self.forwardBtn = createBarImageButtonItem(@"forward", self, @selector(goForward));
    UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:self.backBtn,space,self.forwardBtn, nil]];
	
	
	//right
	UIBarButtonItem *done = createBarButtonItem(NSLocalizedString(@"Done", nil), self, @selector(quit));
    [self.navigationItem setRightBarButtonItem:done];
    
	//titleView
	CGRect rect = self.navigationController.navigationBar.bounds;
	rect.size.width -= 160;
	UIView *titleView = [[[UIView alloc] initWithFrame:rect] autorelease];
	titleView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    rect = CGRectInset(titleView.bounds, 0, 2);
	rect.size.height = 14;
	self.urlLabel = createLabel(rect, [UIFont systemFontOfSize:12], nil, [UIColor colorWithWhite:0.9 alpha:1], nil, CGSizeZero, UITextAlignmentCenter, 1, UILineBreakModeTailTruncation);    
	self.urlLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    rect.origin.y += rect.size.height;
    rect.size.height = titleView.bounds.size.height - rect.origin.y-5;
	self.titleLabel = createLabel(rect, [UIFont boldSystemFontOfSize:14], nil, [UIColor colorWithWhite:1.0 alpha:1], nil, CGSizeZero, UITextAlignmentCenter, 1, UILineBreakModeTailTruncation);    
	self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
	[titleView addSubview:self.urlLabel];
	[titleView addSubview:self.titleLabel];
	self.navigationItem.titleView = titleView;    
    
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.curUrl]];
}
- (void)setCurUrl:(NSURL *)curUrl{
    RELEASE(_curUrl);
    _curUrl = [curUrl retain];
	_urlLabel.text = [curUrl absoluteString];
    [self freshUI];
}
- (NSURL *)curUrl{
    if (!_curUrl) {
        [self setCurUrl:self.url];
    }
    return _curUrl;
}
- (void) goBack{
	if ([_webView canGoBack]) {
		[_webView goBack];
	}
}
- (void) goForward{
	if ([_webView canGoForward]) {
		[_webView goForward];
	}
}
- (void) syncPageTitle{
	NSString *t = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"] ; 	
	if([t length]){		
		self.titleLabel.text = t;
	}else{
        self.titleLabel.text = NSLocalizedString(@"Loading...", nil);
    }
}
- (void) quit{
	[self dismissModalViewControllerAnimated:YES];
}
- (void) freshUI{
	self.backBtn.enabled = [self.webView canGoBack]?YES:NO;
	self.forwardBtn.enabled = [self.webView canGoForward]?YES:NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {		
	}
	return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{    
    DLOG(@"load url:%@",webView.request.URL);
    [self setCurUrl:webView.request.URL];
    [self freshUI];
	[self syncPageTitle];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
	NSLog(@"webViewDidFinishLoad");
    [self freshUI];
	[self syncPageTitle];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{	
	[self syncPageTitle];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

+ (void) open:(id)url withController:(UIViewController *)viewController{
    if (![url isKindOfClass:[NSString class]] && ![url isKindOfClass:[NSURL class]]) {
        return;
    }
    BrowserController *bc = [[[BrowserController alloc] init] autorelease];
    [bc setUrl:[url isKindOfClass:[NSURL class]]?url:[NSURL URLWithString:url]];
    XUINavigationController *nav = [[[XUINavigationController alloc] initWithRootViewController:bc] autorelease];
    [viewController presentModalViewController:nav animated:YES];
}
@end
