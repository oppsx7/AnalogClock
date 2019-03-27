
#import "ClockView.h"

@implementation ClockView

- (void)viewDidMoveToWindow{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:
    NSWindowDidResizeNotification object:[self window]];
}
-(void)windowDidResize:(NSNotification*)notification{
    NSRect winrect=[[self window] frame];
    NSRect contentpane=[[self window] contentRectForFrameRect:winrect];
    NSRect view_rect=NSMakeRect(0.0, 0.0, contentpane.size.width, contentpane.size.height);
    [self setFrame:view_rect];
    [self setNeedsDisplay:true];
}
- (void)drawRect:(NSRect)dirtyRect {
    if(flag==true){
        t=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ontick) userInfo:nil repeats:true];
        flag=false;
    }
    [super drawRect:dirtyRect];
    NSAffineTransform *trans=[NSAffineTransform transform];
    [trans translateXBy:dirtyRect.size.width/2 yBy:dirtyRect.size.height/2];
    [trans rotateByDegrees:90];
    [trans concat];
    [self DrawClock];
    [[NSColor brownColor] setStroke];
    [self DrawHands:prev_components time_change:true];
}
-(void)ontick{
    NSDate *now=[NSDate date];
    NSCalendar *cal=[NSCalendar currentCalendar];
    cur_components = [cal components: (NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:now];
    change=cur_components.hour!=prev_components.hour||cur_components.minute!=prev_components.minute;
    [[NSColor whiteColor] setStroke];
    [self DrawHands:cur_components time_change:change];
    [[NSColor redColor] setStroke];
    [self DrawHands:cur_components time_change:true];
    prev_components=cur_components;
    [self setNeedsDisplay:true];
}
-(void)RotatePoint:(Point[]) pt rotateby:(int) iRotate withAngle:(int)iAngle{
    Point ptTemp;
    for(int i=0;i<iRotate;i++){
        ptTemp.h = (int)(pt[i].h*cos(2*pi*iAngle/360)+pt[i].v*sin(2*pi*iAngle/360));
        ptTemp.v = (int)(pt[i].v*cos(2*pi*iAngle/360)-pt[i].h*sin(2*pi*iAngle/360));
        pt[i]=ptTemp;
    }
}
-(void)DrawClock{
    Point pt[2];
    for(int i=0;i<360;i+=6){
        pt[0].h=0;
        pt[0].v=150;
        [self RotatePoint:pt rotateby:1 withAngle:i];
        pt[1].h=pt[1].v=i%5?5:10;
        pt[0].h-=pt[1].h/2;
        pt[0].v-=pt[1].v/2;
        NSRect rect=NSMakeRect(pt[0].h, pt[0].v, pt[1].h, pt[1].v);
        NSBezierPath *path=[NSBezierPath bezierPathWithOvalInRect:rect];
        [[NSColor colorWithCalibratedRed:0.37 green:0.34 blue:0.41 alpha:1.0] set];
        [path fill];
    }
}
-(void)DrawHands:(NSDateComponents *) cur_time time_change:(BOOL)isChange{
    static Point pt[3][2]={
        0,0,0,120,
        0,0,0,140,
        0,0,0,140,
    };
    int iAngle[3];
    Point ptTemp[3][2];
    iAngle[0]=(int)((cur_time.hour*30)%360+cur_time.minute/2);
    iAngle[1]=(int)(cur_time.minute*6);
    iAngle[2]=(int)(cur_time.second*6);
    memcpy(ptTemp, pt, sizeof(pt));
    for(int i=isChange?0:2;i<3;i++){
        [self RotatePoint:ptTemp[i] rotateby:2 withAngle:iAngle[i]];
        NSBezierPath *draw_line=[NSBezierPath bezierPath];
        [draw_line moveToPoint:NSMakePoint(ptTemp[i][0].h, ptTemp[i][0].v)];
        [draw_line lineToPoint:NSMakePoint(ptTemp[i][1].h, ptTemp[i][1].v)];
        [draw_line setLineWidth:2];
        [draw_line stroke];

    }
    
}

@end

