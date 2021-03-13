# Backend

## Get system & refresh token
```
REFRESH_JWT=$(curl -D /dev/stderr https://api.sandbox.swiftctrl.com/auth/system-access-token \
  -H 'Content-type: application/json' --data-binary @- << EOF | jq -r .refresh_token
{
  "license": "my_licence",
  "secret":"my_secret"
}
EOF
)

printf "Refresh JWT:\n%s\n" $REFRESH_JWT
```

## Get user token for user `user_id_to_use`
```
USER_JWT=$(curl -D /dev/stderr https://api.sandbox.swiftctrl.com/auth/user-access-token \
  -H 'Content-type: application/json' \
  -H "Authorization: Bearer ${REFRESH_JWT}" \
--data-binary @- << EOF | jq -r .
{
  "client_user_id": "email@example.com"
}
EOF
)

printf "User JWT:\n%s\n" $USER_JWT
```

## To get a new system refresh_token
```
REFRESH_JWT=$(curl -D /dev/stderr https://api.sandbox.swiftctrl.com/auth/system-access-token \
  -H "Authorization: Bearer ${REFRESH_JWT}" | jq -r .)
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

This method is called when a new QRCode is available in UIImageView format

```
- qrView: UIImageView containing the new available QRCode to display in your app
```

**didReceiveQRCode(qrBase64Image: String)**

This method is called when a new QRCode is available in Base64 format

```
- qrBase64Image: String containing the new Base64 available QRCode to display in your app
```

**didReceiveQRCode(qrBytesArray: [UInt8])**

This method is called when a new QRCode is available in bytes array format

```
- qrBytesArray: String containing the new bytes array available QRCode to display in your app
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
