//
//  SUScrollView.m
//  Pods
//
//  Created by 陈文琦 on 2018/1/11.
//

#import "SUScrollView.h"

#import <pop/POP.h>

typedef struct {
    BOOL    scrollViewDidScroll : 1;
    BOOL    scrollViewWillBeginDragging : 1;
    BOOL    scrollViewDidEndDragging : 1;
    BOOL    scrollViewWillBeginDecelerating : 1;
    BOOL    scrollViewDidEndDecelerating : 1;
} SUScrollDelegateCan;

//const CGFloat SUScroll
@interface SUScrollView ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) SUScrollDelegateCan delegateCan;

@end

@implementation SUScrollView

#pragma mark - Life Circle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panGestureTrigger:)];
    [self addGestureRecognizer:_panGestureRecognizer];
    
    self.clipsToBounds = YES;
    
    [self setup];
    
    return self;
}

- (void)setup {
    _contentSize = CGSizeZero;
    _bounces = YES;
}

#pragma mark - Setter Method
- (CGPoint)contentOffset {
    return self.bounds.origin;
}

#pragma mark - Getter Method
- (void)setDelegate:(id<SUScrollViewDelegate>)delegate {
    _delegate = delegate;
    
    _delegateCan.scrollViewDidScroll = [_delegate respondsToSelector:@selector(scrollViewDidScroll:)];
    _delegateCan.scrollViewWillBeginDragging = [_delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)];
    _delegateCan.scrollViewDidEndDragging = [_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)];
    _delegateCan.scrollViewWillBeginDecelerating = [_delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)];
    _delegateCan.scrollViewDidEndDecelerating = [_delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    if (CGPointEqualToPoint(contentOffset, self.contentOffset)) {
        return;
    }
    [self setContentOffset:contentOffset animated:NO];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    if (animated) {
        
    } else {
        CGRect bounds = self.bounds;
        bounds.origin.x = contentOffset.x - _contentInset.left;
        bounds.origin.y = contentOffset.y - _contentInset.top;
        self.bounds = bounds;
        
        [self setNeedsLayout];

        if (_delegateCan.scrollViewDidScroll) {
            [_delegate scrollViewDidScroll:self];
        }
    }
}

- (void)setContentSize:(CGSize)contentSize {
    if (CGSizeEqualToSize(contentSize, _contentSize)) {
        return;
    }
    _contentSize = contentSize;
    [self _confineContent];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    if (UIEdgeInsetsEqualToEdgeInsets(contentInset, _contentInset)) {
        return;
    }
    
    CGFloat x = contentInset.left - _contentInset.left;
    CGFloat y = contentInset.top - _contentInset.top;
    
    _contentInset = contentInset;
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x -= x;
    contentOffset.y -= y;
    self.contentOffset = contentOffset;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self _confineContent];
}

#pragma mark - Configure Method
- (void)_updateBounds {
}

- (void)_confineContent {
    self.contentOffset = [self _confinedContentOffset:self.contentOffset];
}

- (CGPoint)_confinedContentOffset:(CGPoint)contentOffset {
    CGRect scrollerBounds = UIEdgeInsetsInsetRect(self.bounds, _contentInset);
    
    if ((_contentSize.width-contentOffset.x) < scrollerBounds.size.width) {
        contentOffset.x = (_contentSize.width - scrollerBounds.size.width);
    }
    
    if ((_contentSize.height-contentOffset.y) < scrollerBounds.size.height) {
        contentOffset.y = (_contentSize.height - scrollerBounds.size.height);
    }
    
    contentOffset.x = MAX(contentOffset.x,0);
    contentOffset.y = MAX(contentOffset.y,0);
    
    contentOffset = [self _boundConfinedPoint:contentOffset];
    
    return contentOffset;
}

- (CGPoint)_boundConfinedPoint:(CGPoint)point {
    CGRect scrollerBounds = UIEdgeInsetsInsetRect(self.bounds, _contentInset);
    if (_contentSize.width <= scrollerBounds.size.width) {
        point.x = 0;
    }
    if (_contentSize.height <= scrollerBounds.size.height) {
        point.y = 0;
    }
    
    return point;
}

#pragma mark - Param Method
- (POPAnimatableProperty *)boundsOriginProperty {
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"suscrollview.contentoffset" initializer:^(POPMutableAnimatableProperty *prop) {
        // read value
        prop.readBlock = ^(id obj, CGFloat values[]) {
            values[0] = [obj contentOffset].x;
            values[1] = [obj contentOffset].y;
        };
        // write value
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            CGPoint contentOffset = CGPointMake(values[0], values[1]);
            if (![obj bounces]) {
                contentOffset = [obj _confinedContentOffset:contentOffset];
            }
                
            [obj setContentOffset:contentOffset];
        };
        // dynamics threshold
        prop.threshold = 0.01;
    }];
    
    return prop;
}

#pragma mark - Gesture Method
- (void)_panGestureTrigger:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Begin Pan");
        [self _beginDragging];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self _dragBy:[gesture translationInView:self]];
        [gesture setTranslation:CGPointZero inView:self];
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
               gesture.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"End Pan");
        [self _endDraggingWithDecelerationVelocity:[gesture velocityInView:self]];
    }
}

- (void)_beginDragging {
    [self pop_removeAllAnimations];
    
    if (_delegateCan.scrollViewWillBeginDragging) {
        [_delegate scrollViewWillBeginDragging:self];
    }
}

- (void)_dragBy:(CGPoint)point {
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x -= point.x;
    contentOffset.y -= point.y;
    if (_bounces) {
        contentOffset = [self _boundConfinedPoint:contentOffset];
    } else {
        contentOffset = [self _confinedContentOffset:contentOffset];
    }
    [self setContentOffset:contentOffset];
}

- (void)_endDraggingWithDecelerationVelocity:(CGPoint)velocity {
    velocity = [self _boundConfinedPoint:velocity];
    
    velocity.x = -velocity.x;
    velocity.y = -velocity.y;
    
    BOOL decelerate = !(velocity.x == 0 && velocity.y == 0);
    
    if (_delegateCan.scrollViewDidEndDragging) {
        [_delegate scrollViewDidEndDragging:self willDecelerate:decelerate];
    }
    if (decelerate) {
        if (_delegateCan.scrollViewWillBeginDecelerating) {
            [_delegate scrollViewWillBeginDecelerating:self];
        }
        
        POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
        decayAnimation.property = [self boundsOriginProperty];
        decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [self pop_addAnimation:decayAnimation forKey:@"decelerate"];
        
        __weak typeof(self) weakSelf = self;
        decayAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                if (weakSelf.delegateCan.scrollViewDidEndDecelerating) {
                    [weakSelf.delegate scrollViewDidEndDecelerating:weakSelf];
                }
            }
        };
        decayAnimation.animationDidApplyBlock = ^(POPAnimation *anim) {
            [weakSelf _popBackToBoundAnimationWithAnimation:anim];
        };
    } else {
        [self _popBackToBoundAnimationWithAnimation:nil];
    }
}

- (void)_popBackToBoundAnimationWithAnimation:(POPAnimation *)anim {
    CGPoint confinedContentOffset = [self _confinedContentOffset:self.contentOffset];
    if (CGPointEqualToPoint(self.contentOffset, confinedContentOffset)) return;
    
    //越界了
    [self pop_removeAllAnimations];
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [self boundsOriginProperty];
    if (anim) {
        springAnimation.velocity = [(POPDecayAnimation *)anim velocity];
    }
    springAnimation.toValue = [NSValue valueWithCGPoint:confinedContentOffset];
    springAnimation.springBounciness = 0.0;
    springAnimation.springSpeed = 5.0;
    [self pop_addAnimation:springAnimation forKey:@"bounce"];
    
    __weak typeof(self) weakSelf = self;
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            if (weakSelf.delegateCan.scrollViewDidEndDecelerating) {
                [weakSelf.delegate scrollViewDidEndDecelerating:weakSelf];
            }
        }
    };
}

@end
