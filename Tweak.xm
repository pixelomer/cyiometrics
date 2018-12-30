#import <LocalAuthentication/LocalAuthentication.h>
#define LocalizedString(string) [NSBundle.mainBundle localizedStringForKey:string value:string table:nil]
#define rootViewController [[[[UIApplication sharedApplication] delegate] window] rootViewController]

LAPolicy policy;

%hook ConfirmationController

- (void)confirmButtonClicked {
	@autoreleasepool {
		LAContext *context = [[LAContext alloc] init];
		[context evaluatePolicy:policy
			localizedReason:LocalizedString(@"Authentication is required to perform operations.")
			reply:^(BOOL success, NSError *error) {
				if (success || (error && (
					(error.code == LAErrorPasscodeNotSet) ||
					(
						(policy == LAPolicyDeviceOwnerAuthenticationWithBiometrics) && (
							(error.code == LAErrorTouchIDNotAvailable) ||
							(error.code == LAErrorTouchIDNotEnrolled)
						)
					)
				))) {
					// This method has to be called from the main thread
					dispatch_sync(dispatch_get_main_queue(), ^{
						%orig;
					});
				}
			}
		];
	}
}

%end

%ctor {
	if (kCFCoreFoundationVersionNumber >= 1240.10) policy = LAPolicyDeviceOwnerAuthentication;
	else policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
}