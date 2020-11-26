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

## SDK calls are there: SwitchCtrl.shared*
