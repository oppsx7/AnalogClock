
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
bool flag=true;
@interface ClockView : NSView{
    NSTimer *t;
    NSDateComponents *cur_components;
    NSDateComponents *prev_components;
    BOOL change;
}
-(void)RotatePoint:(Point[]) pt rotateby:(int) iRotate withAngle:(int)iAngle;
-(void)DrawClock;
-(void)DrawHands:(NSDateComponents *) cur_time time_change:(BOOL)isChange;

@end

NS_ASSUME_NONNULL_END
