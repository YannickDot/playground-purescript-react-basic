module Components.Toggle where

import Prelude
import React.Basic (Component, JSX, createComponent, make)
import React.Basic.DOM as R
import React.Basic.DOM.Events as RE

type Props
  = { initialValue :: Int
    }

component :: Component Props
component = createComponent "Toggle"

toggle :: Props -> JSX
toggle = make component { initialState, render }
  where
  initialState =
    { isOn: false
    , count: 0
    }

  render self =
    let
      currentCount = (self.props.initialValue + self.state.count)
    in
      R.div_
        [ R.h2_ [ R.text "Toggle" ]
        , R.p_
            [ R.text if self.state.isOn then "On" else "Off"
            ]
        , R.p_
            [ R.text $ "Count : " <> show currentCount
            ]
        , R.button
            { onClick:
              RE.capture_ do
                self.setState (\s -> s { isOn = not s.isOn, count = s.count + 1 })
            , children:
              [ R.text "Click here"
              ]
            }
        ]
