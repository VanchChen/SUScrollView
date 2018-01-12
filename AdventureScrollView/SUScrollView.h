//
//  SUScrollView.h
//  Pods
//
//  Created by 陈文琦 on 2018/1/11.
//

#import <UIKit/UIKit.h>

@class SUScrollView;
@protocol SUScrollViewDelegate <NSObject>

@optional
- (void)scrollViewDidScroll:(SUScrollView *)scrollView;                                               // any offset changes
// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(SUScrollView *)scrollView;
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(SUScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewWillBeginDecelerating:(SUScrollView *)scrollView;   // called on finger up as we are moving
- (void)scrollViewDidEndDecelerating:(SUScrollView *)scrollView;      // called when scroll view grinds to a halt
@end

@interface SUScrollView : UIView

@property (nonatomic, weak)   id<SUScrollViewDelegate>  delegate;

@property (nonatomic, assign) CGSize                    contentSize;
@property (nonatomic, assign) CGPoint                   contentOffset;
@property (nonatomic, assign) UIEdgeInsets              contentInset;
@property (nonatomic, assign) BOOL                      bounces;

@end
