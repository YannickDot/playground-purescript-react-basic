module Components.App where

import Prelude
import Components.FormExample (formExample)
import Components.Network (network)
import Components.Timer (timer)
import Components.Toggle (toggle)
import React.Basic (Component, JSX, createComponent, makeStateless)
import React.Basic.DOM as R

component :: Component Unit
component = createComponent "App"

app :: JSX
app =
  unit
    # makeStateless component \_ ->
        R.div_
          [ R.h1_ [ R.text "App" ]
          , toggle { initialValue: 5 }
          , timer { duration: 5000, lapDuration: 100 }
          , formExample unit
          , network unit
          ]
