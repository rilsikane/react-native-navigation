#import "RNNBottomTabsController.h"

@implementation RNNBottomTabsController {
	NSUInteger _currentTabIndex;
}

- (id<UITabBarControllerDelegate>)delegate {
	return self;
}

- (void)viewDidLayoutSubviews {
	[self.presenter viewDidLayoutSubviews];
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
     tabFrame.size.height = 85;
     tabFrame.origin.y = self.view.frame.size.height - 85;
     self.tabBar.frame = tabFrame;
}

- (UIViewController *)getCurrentChild {
	return self.selectedViewController;
}

- (CGFloat)getTopBarHeight {
    for(UIViewController * child in [self childViewControllers]) {
        CGFloat childTopBarHeight = [child getTopBarHeight];
        if (childTopBarHeight > 0) return childTopBarHeight;
    }
    return [super getTopBarHeight];
}

- (void)setSelectedIndexByComponentID:(NSString *)componentID {
	for (id child in self.childViewControllers) {
		UIViewController<RNNLayoutProtocol>* vc = child;

		if ([vc conformsToProtocol:@protocol(RNNLayoutProtocol)] && [vc.layoutInfo.componentId isEqualToString:componentID]) {
			[self setSelectedIndex:[self.childViewControllers indexOfObject:child]];
		}
	}
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
	_currentTabIndex = selectedIndex;
	[super setSelectedIndex:selectedIndex];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return [[self presenter] getStatusBarStyle:self.resolveOptions];
}

#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	[self.eventEmitter sendBottomTabSelected:@(tabBarController.selectedIndex) unselected:@(_currentTabIndex)];
	_currentTabIndex = tabBarController.selectedIndex;
}
- (UITraitCollection *)traitCollection {
    return [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassCompact];
}

@end
