#include <Foundation/Foundation.h>

@interface Node:NSObject
{
	int target_children;
	int target_metadata;
	NSMutableArray *children;
	NSMutableArray *metadata;
}

+ (Node*) node;
+ (Node*) nodeWithDigits:(NSMutableArray*)someDigits;
- (BOOL) hasTargetChildren;
- (BOOL) hasTargetMetadata;
- (BOOL) hasAllChildren;
- (BOOL) hasAllMetadata;
- (BOOL) done;
- (int) metadataSum;
- (int) value;
- (void) setTargetChildren:(int)aTarget;
- (void) setTargetMetadata:(int)aTarget;
- (void) addChild:(Node*)aChild;
- (void) addMetadata:(NSString*)aDigit;

@end

@interface NodeCollection:NSObject
{
	NSMutableArray *data;
}
+ (NodeCollection*) collection;
+ (NodeCollection*) fromStdin;
+ (NodeCollection*) collectionWithArray:(NSMutableArray*)someDigits;
- (int) metadataSum;
- (int) value;
- (void) addObject:(id)anObject;
@end

#include <stdio.h>

@implementation Node
+ (Node*)node
{
	Node *retval = [Node new];
	[retval autorelease];
	return retval;
}

+ (Node*) nodeWithDigits:(NSMutableArray*)someDigits
{
	Node* retval = [Node node];
	while([someDigits count]){
		if([retval done])
			break;

		NSString *digit = [someDigits objectAtIndex:0];

		if(![retval hasTargetChildren]) {
			[someDigits removeObjectAtIndex:0];
			[retval setTargetChildren:[digit intValue]];
			continue;
		}

		if(![retval hasTargetMetadata]) {
			[someDigits removeObjectAtIndex:0];
			[retval setTargetMetadata:[digit intValue]];
			continue;
		}

		if(![retval hasAllChildren]) {
			[retval addChild:[Node nodeWithDigits:someDigits]];
			continue;
		}

		if(![retval hasAllMetadata]) {
			[someDigits removeObjectAtIndex:0];
			[retval addMetadata:digit];
		}
	}
	return retval;
}

- init 
{
	self = [super init];
	target_children = -1;
	target_metadata = -1;
	children = [NSMutableArray new];
	metadata = [NSMutableArray new];
	return self;
}

- (void) dealloc 
{
	[children release];
	[metadata release];
	[super dealloc];
}

- (BOOL) hasTargetChildren
{
	if(target_children == -1)
		return NO;

	return YES;
}
- (BOOL) hasTargetMetadata
{
	if(target_metadata == -1)
		return NO;
	return YES;
}

- (BOOL) hasAllChildren
{
	return [children count] == target_children? YES : NO;
}

- (BOOL) hasAllMetadata
{
	return [metadata count] == target_metadata? YES : NO;
}

- (BOOL) done
{
	if(![self hasTargetChildren])
		return NO;
	if(![self hasTargetMetadata])
		return NO;
	if(![self hasAllChildren])
		return NO;
	if(![self hasAllMetadata])
		return NO;
	return YES;
}

- (void) setTargetChildren:(int)aTarget
{
	target_children = aTarget;
}

- (void) setTargetMetadata:(int)aTarget
{
	target_metadata = aTarget;
}

- (int) metadataSum
{
	int retval = 0;

	Node *node;
	NSEnumerator *nodeEnum = [children objectEnumerator];
	while((node = [nodeEnum nextObject])) {
		retval = retval + [node metadataSum];
	}

	NSString *digit;
	NSEnumerator *metadataEnum = [metadata objectEnumerator];
	while((digit = [metadataEnum nextObject])) {
		retval = retval + [digit intValue];
	}
	return retval;
}

- (void) addChild:(Node*)aChild
{
	[children addObject:aChild];
}

- (void) addMetadata:(NSString*)aDigit
{
	[metadata addObject:aDigit];
}

- (int) value
{
	if(!target_children)
		return [self metadataSum];

	int retval = 0;
	NSString *digit;
	NSEnumerator *metadataEnum = [metadata objectEnumerator];
	while((digit = [metadataEnum nextObject])){
		if([digit intValue] > [children count])
			continue;

		Node *child = [children objectAtIndex:[digit intValue] - 1];

		retval = retval + [child value];
	}
	return retval;
}



@end

@implementation NodeCollection

+ (NodeCollection*) collection
{
	NodeCollection *retval = [NodeCollection new];
	[retval autorelease];
	return retval;
}

+ (NodeCollection*)fromStdin
{
	NSMutableArray *digits = [NSMutableArray array];
	NSMutableString *digit = [NSMutableString stringWithString:@""];
	char ch;
	for(ch=getchar(); ch != EOF; ch = getchar()) {
		if(ch == 32) {
			[digits addObject:digit];
			digit = [NSMutableString stringWithString:@""];
			continue;
		}
		[digit appendFormat:@"%c",ch];
	}
	[digits addObject:digit];
	return [NodeCollection collectionWithArray:digits];
}


+ (NodeCollection*) collectionWithArray:(NSMutableArray*)someDigits
{
	NodeCollection *retval = [NodeCollection collection];
	while([someDigits count]){
		[retval addObject:[Node nodeWithDigits:someDigits]];
	}
	return retval;
}

- init
{
	self = [super init];
	data = [NSMutableArray new];
	return self;

}

- (void) dealloc
{
	[data release];
	[super dealloc];
}

- (int) metadataSum
{
	int retval = 0;
	Node *node;
	NSEnumerator *nodes = [data objectEnumerator];
	while((node = [nodes nextObject])) {
		retval = retval + [node metadataSum];
	}
	return retval;
}
- (int) value 
{
	int retval = 0;
	Node *node;
	NSEnumerator *nodes = [data objectEnumerator];
	while((node = [nodes nextObject])) {
		retval = retval + [node value];
	}
	return retval;
}

- (void) addObject:(id)anObject
{
	[data addObject:anObject];
}


@end

#include <stdlib.h>

int main(void)
{
	NSAutoreleasePool *myPool = [[NSAutoreleasePool alloc] init];
	NodeCollection *nodes = [NodeCollection fromStdin];
	printf("sum: %d\n", [nodes metadataSum]);
	printf("value: %d\n", [nodes value]);
	[myPool drain];
	return EXIT_SUCCESS;
}
