[![CircleCI](https://circleci.com/gh/dgodevais/project-mango.svg?style=svg&circle-token=2d098af9a66e47c2b0d3b7f77d432695caa3b132)](https://circleci.com/gh/dgodevais/project-mango)

# Troov iOS Application
An event-driven dating application.

## Getting Started

### Environment Set up

1. Install Xcode if you don't have it already

Fill in the details for LINKEDIN_CLIENT_ID, LINKEDIN_CLIENT_SECRET, and LINKEDIN_REDIRECT_URL which can be found at 
https://www.linkedin.com/developers/apps/20992893/auth

Fill in the details for GOOGLE_API_KEY which can be found at
https://console.cloud.google.com/google/maps-apis/credentials?project=mango-dev-41d9c

2. Open the workspace file instead of the project file when starting Xcode:
```
mango.xcworkspace
```

3. Once you have the project open in Xcode you can run it. There are two targets to choose from:
```
1. mango (release version)
2. mango DEV (develop)
```

NOTE: You must also be added as a developer to the Facebook app in order to create a login.

### CI/CD Workflow

#### Build

The current build procedure is documented in `.circleci/config.yml`

#### Development Workflow

There are three main branches:
- `master`: production version of the application
- `staging`: changes to be integrated into production
- `dev`: changes that are yet to be tested

These are the following steps for developing the application:

1. Pull the latest code from staging:
```
$ git checkout staging
$ git pull
```

2. Create a new branch or use the `dev` branch for your changes
```
$ git checkout -b new_feat_branch
```
OR:
```
$ git checkout dev
```

**NB:** If you're using an existing branch e.g. `dev` remember to merge the latest changes from `staging` into your branch:

```
$ get checkout existing_branch
$ git merge staging
```

3. Commit and push your changes to the remote repository. This triggers a new build.

4. Create a PR to merge the changes from your branch into `staging`. Merge your changes into `staging` when the checks have been completed.

5. Create a PR to merge changes from `staging` into `master`. Merge your changes into `staging` when the checks have been completed.

### Generated Models ###
Every time you build the project using XCode a build script runs. This build script is called "Model Generation". It runs the following command:

```
npx openapi-generator-cli generate -g swift5 -i backend/api-spec-ref.json -o swift-client-take-two --skip-validate-spec
```

What this command does is take the [OpenAPI Generator CLI](https://github.com/OpenAPITools/openapi-generator-cli) and generates Swift models.

If the backend has changes that you want to integrate into the client update the "backend/api-spec-ref.json" file with the latest spec file from the backend.

### Libraries and Dependencies

#### Package

- Auth0 - A library for auhtenication
- KeychainSwift - A library for saving text and data in the Keychain with Swift.
- SwiftLint - A tool to enforce Swift style and conventions.
- Alamofire - HTTP Networking in Swift 
- KDCalendar - A calendar component with native events support.
- SDWebImageSwiftUI - SwiftUI Image loading and Animation framework powered by SDWebImage.
