#import "MyColourHex.h"

@implementation MyColourHex

- (void)awakeFromNib
{
	NSColor *color;
	if ([self isForeground]) {
		color = [[NSColor blackColor] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
		previousHex = [[NSString alloc] initWithString:@"#000000" ];
	} else { // Background
		color = [[NSColor whiteColor] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
		previousHex = [[NSString alloc] initWithString:@"#FFFFFF" ];
	}
	
	[self setWellFromColor:color];
	[self setSlidersFromColor:color];
	[self setHTMLFromColor:color];
	[self setRGBFromColor:color];
}

- (IBAction)updateFromHTML:(id)sender
{
	NSColor		*color;
	NSString	*red, *green, *blue, *hex;
	NSRange		range;
	
	hex = [htmlTextField stringValue];
	
	if ( [hex length] == 7 ) {
		// assuming the first char is #
		range = NSMakeRange( 1, 2);
		red = [NSString stringWithFormat:@"0x%@",[hex substringWithRange:range]];
		range = NSMakeRange( 3, 2);
		green = [NSString stringWithFormat:@"0x%@",[hex substringWithRange:range]];
		range = NSMakeRange( 5, 2);
		blue = [NSString stringWithFormat:@"0x%@",[hex substringWithRange:range]];
		
		// Save for undo futur wrong entry
		previousHex = hex;
		
		color = [NSColor colorWithDeviceRed:([MyColourHex hexStringToInt:red]/255.0)
										green:([MyColourHex hexStringToInt:green]/255.0)
										blue:([MyColourHex hexStringToInt:blue]/255.0)
										alpha:1.0];
		[self setWellFromColor:color];
		[self setSlidersFromColor:color];
		[self setRGBFromColor:color];
		[self setResultsFromColor:color];
	} else { // If wrong entry
		// Set previous value
		[htmlTextField setStringValue:previousHex];
	}
}

- (IBAction)updateFromWell:(id)sender
{
	NSColor*	color = [[colorWell color] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	if ( color != nil ) {
		[self setSlidersFromColor:color];
		[self setHTMLFromColor:color];
		[self setRGBFromColor:color];
		[self setResultsFromColor:color];
	}
}

- (IBAction)updateFromRGB:(id)sender
{
	NSColor		*color;
	NSNumber	*red, *green, *blue;
	NSNumberFormatter *stringToInt = [[NSNumberFormatter alloc] init];;
	
	red = [stringToInt numberFromString:[redField stringValue]];
	green = [stringToInt numberFromString:[greenField stringValue]];
	blue = [stringToInt numberFromString:[blueField stringValue]];
		
	color = [NSColor colorWithDeviceRed:([red intValue]/255.0)
									green:([green intValue]/255.0)
									blue:([blue intValue]/255.0)
									alpha:1.0];

	[self setWellFromColor:color];
	[self setSlidersFromColor:color];
	[self setHTMLFromColor:color];
	[self setResultsFromColor:color];
}

- (IBAction)updateFromSliders:(id)sender
{
	NSColor*	color = [NSColor colorWithDeviceRed:[redSlider floatValue]
                                       green:[greenSlider floatValue]
                                        blue:[blueSlider floatValue]
                                       alpha:1.0];
	[self setWellFromColor:color];
	[self setHTMLFromColor:color];
	[self setRGBFromColor:color];
	[self setResultsFromColor:color];
}

- (void)setWellFromColor:(NSColor*)color
{
	NSColor*	c = [color colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	[colorWell setColor:c];
}

-(void)setHTMLFromColor:(NSColor*)color
{
	float		red,green,blue,alpha;
	int			intRed, intGreen, intBlue;
	NSString *hex;
		
	[color getRed:&red
			green:&green
			blue:&blue
			alpha:&alpha];

	intRed = (red * 255);
	intGreen = (green * 255);
	intBlue = (blue * 255);
	
	hex = [NSString stringWithFormat: @"#%02X%02X%02X",intRed,intGreen,intBlue];
	
	[htmlTextField setStringValue:hex];
}

- (void)setSlidersFromColor:(NSColor*)color
{
    // break out the components, values will be between 0 and 1
    float red = [color redComponent];
    float green = [color greenComponent];
    float blue = [color blueComponent];

    // update the sliders to reflect the current values of the color
    // the minimum and maximum values for the sliders are set to 0 and 1
    // respectively, so they directly map to the NSColor components
    [redSlider setFloatValue:red];
    [greenSlider setFloatValue:green];
    [blueSlider setFloatValue:blue];
}

- (void)setRGBFromColor:(NSColor*)color
{
	float		red,green,blue,alpha;
	int			intRed, intGreen, intBlue;
	NSString	*stmp;
	
	[color getRed:&red
			green:&green
			blue:&blue
			alpha:&alpha];

	intRed = (red * 255);
	intGreen = (green * 255);
	intBlue = (blue * 255);
	
	stmp = [NSString stringWithFormat: @"%d",intRed];
	[redField setStringValue:stmp];
	stmp = [NSString stringWithFormat: @"%d",intGreen];
	[greenField setStringValue:stmp];
	stmp = [NSString stringWithFormat: @"%d",intBlue];
	[blueField setStringValue:stmp];
}

- (void)setResultsFromColor:(NSColor*)color
{
	NSColor		*c = [color colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	
	if ([self isForeground]) {
		[myResults setForegroundColor:c];
	} else { // Background
		[myResults setBackgroundColor:c];
	}
	[myResults setResults];
}


+(int)hexStringToInt:(NSString*)hexString
{
	unsigned int	returnInt = 0;
	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	(void) [scanner scanHexInt:&returnInt];
	return returnInt;
}


- (bool)isForeground
{
	return nil;
}

@end
