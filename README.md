## Installation

Add the header and implementation to your project.

In Build Phases for your current project, add a new "Run Script" build phase. Move it to the top. Drag the git-version.sh file into it.

Add a base tag in your repo.
e.g. 
> git tag -a 0.0.1a1

## Usage
In your appDelegate (or wherever you like):

	self.statusBarWindow = [[CSStatusBarWindow alloc] initWithFrame:application.statusBarFrame];
	[self.statusBarWindow makeKeyAndVisible];

	// Add some values.
	[self.statusBarWindow addGitDescription];
	[self.statusBarWindow addGitRef];
	[self.statusBarWindow addBundleVersion];
	[self.statusBarWindow addBundleShortVersionString];

	// Add random value:
	[self.statusBarWindow addInformation:@"Hello Dave"];