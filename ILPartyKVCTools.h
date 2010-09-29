
#ifdef __OBJC__

#define ILMutableAccessorsForApparentlyImmutableKey(CapitalizedKey, ivar) \
- (void) insertObject:(id) o in##CapitalizedKey##AtIndex:(NSInteger) i; \
{ \
	[ivar insertObject:o atIndex:i]; \
} \
- (void) insert##CapitalizedKey:(NSArray*) o atIndexes:(NSIndexSet*) i; \
{ \
	[ivar insertObjects:o atIndexes:i]; \
} \
\
- (void) removeObjectFrom##CapitalizedKey##AtIndex:(NSInteger) i; \
{ \
	[ivar removeObjectAtIndex:i]; \
} \
\
- (void) remove##CapitalizedKey##AtIndexes:(NSIndexSet*) i; \
{ \
	[ivar removeObjectsAtIndexes:i]; \
} \
- (void) replaceObjectIn##CapitalizedKey##AtIndex:(NSInteger) i withObject:(id) o; \
{ \
	[ivar replaceObjectAtIndex:i withObject:o]; \
} \
- (void) replace##CapitalizedKey##AtIndexes:(NSIndexSet*) i with##CapitalizedKey:(NSArray*) o; \
{ \
	[ivar replaceObjectsAtIndexes:i withObjects:o]; \
}

#define ILAccessorForKVCMutableArray(name, key) \
- name; \
{ \
	return [self mutableArrayValueForKey:@#key]; \
}

#endif