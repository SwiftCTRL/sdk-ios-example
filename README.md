# Backend

## Get system & refresh token
```
REFRESH_TOKEN=$(jq -r .refresh_token <<< $(curl -D /dev/stderr https://api.sandbox.swiftctrl.com/swift-directory/auth/system-access-token \
  -H 'Content-type: application/json' --data-binary @- << EOF
{
  "license": "my_licence",
  "secret":"my_secret"
}
EOF
))
```

## Get user token for user `user_id_to_use`
```
USER_TOKEN=$(jq -r . <<< $(curl -D /dev/stderr https://api.sandbox.swiftctrl.com/swift-directory/auth/user-access-token \
  -H 'Content-type: application/json' \
  -H "Authorization: Bearer ${REFRESH_TOKEN}" \
--data-binary @- << EOF
{
  "user_id": user_id_to_use
}
EOF
))

printf "User Token:\n%s\n" $USER_TOKEN
```

## To get a new system refresh_token
```
REFRESH_TOKEN=$(curl -D /dev/stderr https://api.sandbox.swiftctrl.com/swift-directory/auth/system-access-token \
  -H "Authorization: Bearer ${REFRESH_TOKEN}" | jq -r .)
```

# Mobile
```
brew install cocoapods

git clone --branch sdk_only git@github.com:SwiftCTRL/sdk-ios-example.git

cd sdk-ios-example

# Folder to checkout
pod --verbose install

open -a Xcode SwitchCTRLExample.xcworkspace
```

In QRViewController.swift (line 14), change private var userToken to the token you got

## SDK calls

### SwitchCtrl.shared


**initialize(with: String, delegate: SwiftCtrlObserver)**

This method is the entry point to link/communicate with the SwiftCTRL infrastructure and services.

```
- with userToken: your userToken that you already acquired
- delegate: a reference to an instance of SwiftCtrlObserver object
```	

**registerForQRCode(userToken: String)**

This method launch the QRCode generation for the logged in user and will start notifying your app of new QRcode available to display.

```
- userToken: your userToken that you already acquired
```	

**unregisterForQRCode(userToken: String)**

This method stop the SDK from generating new QRCode and unregister your delegate observer from the sdk

```
- userToken: your userToken that you already acquired
```	

**disconnet()**

```
SwiftCtrl.shared.disconnect()
```	

This will forget the logged in user amd all his data.
YOU MUST CALL THIS WHEN A USER LOGOUT



### SwiftCtrlObserver

**didReceiveQRCode(qrView: UIImageView)**

This method stop the SDK from generating new QRCode and unregister your delegate observer from the sdk

```
- qrView: UIImageView containing the new available QRCode to display in your app
```	

**didFinishInitialization()**

This callback inform the calling app that the SDK is initialized and ready to generate QRCodes.

In this method, you need to call:

```
SwiftCtrl.shared.registerForQRCode(userToken: String)
```	

To be able to start/receive new available QRCode.


**reportError(error: String)**

This callback will inform the calling app of any error happening from the SDK.

**Not implemented at the moment** Signature may change.

