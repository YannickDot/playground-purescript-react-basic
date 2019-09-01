{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "my-project"
, dependencies =
    [ "affjax"
    , "arrays"
    , "console"
    , "effect"
    , "halogen"
    , "js-timers"
    , "numbers"
    , "psci-support"
    , "react-basic"
    , "react-basic-hooks"
    , "simple-json"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
