#import <LocalAuthentication/LocalAuthentication.h>
#define LocalizedString(string) [NSBundle.mainBundle localizedStringForKey:string value:string table:nil]
#define rootViewController [[[[UIApplication sharedApplication] delegate] window] rootViewController]

%hook ConfirmationController

- (void)confirmButtonClicked {
	@autoreleasepool {
		LAContext *context = [[LAContext alloc] init];
		NSError *authError = nil;
		LAPolicy policy = LAPolicyDeviceOwnerAuthentication;
		if ([context canEvaluatePolicy:policy error:&authError]) {
			[context evaluatePolicy:policy
				localizedReason:LocalizedString(@"Authentication is required to perform operations.")
				reply:^(BOOL success, NSError *error) {
					if (success) {
						// This method has to be called from the main thread
						dispatch_sync(dispatch_get_main_queue(), ^{
							%orig;
						});
					}
				}
			];
		} else if (authError && authError.code == LAErrorPasscodeNotSet) {
			%orig;
		} else {
			UIAlertController* alert = [UIAlertController alertControllerWithTitle:LocalizedString(@"Cyiometrics Error") message:authError.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:LocalizedString(@"OK") style:UIAlertActionStyleDefault handler:^(id v1){}]];
			[self presentViewController:alert animated:YES completion:nil];
		}
	}
}

%end