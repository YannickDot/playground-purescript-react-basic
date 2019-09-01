module Components.FormExample where

import Prelude
import Data.Array (range)
import Data.Foldable (foldl)
import Data.Int (floor)
import Data.Maybe (fromMaybe)
import Data.Number (fromString)
import React.Basic (Component, JSX, createComponent, make)
import React.Basic.DOM as R
import React.Basic.DOM.Events as RE

type Props
  = Unit

type State
  = { years :: Int
    , initialAmount :: Number
    , percentReturns :: Number
    }

computeAmount :: Int -> Number -> Number -> Int
computeAmount years initialAmount percentReturns =
  (range 1 years)
    # foldl (\b -> \_ -> b + b * percentReturns / 100.0) initialAmount
    # floor

component :: Component Props
component = createComponent "FormExample"

formExample :: Props -> JSX
formExample = make component { initialState, render }
  where
  initialState :: State
  initialState =
    { years: 0
    , initialAmount: 0.0
    , percentReturns: 0.0
    }

  render self =
    let
      { initialAmount, percentReturns, years } = self.state

      onInputChange cb =
        RE.capture RE.targetValue
          ( \value ->
              let
                val = fromMaybe 0.0 $ value >>= fromString
              in
                cb val
          )
    in
      R.form_
        [ R.h2_
            [ R.text "Form Example"
            ]
        , R.div
            { style: R.css { display: "inline-block" }
            , children:
              [ R.p_ [ R.text "initialAmount" ]
              , R.input
                  { type: "number", placeholder: "initialAmount", onChange: onInputChange (\val -> self.setState \s -> s { initialAmount = val })
                  }
              ]
            }
        , R.div
            { style: R.css { display: "inline-block" }
            , children:
              [ R.p_ [ R.text "Years" ]
              , R.input
                  { type: "number"
                  , placeholder: "years"
                  , onChange: onInputChange (\val -> self.setState \s -> s { years = floor val })
                  }
              ]
            }
        , R.div
            { style: R.css { display: "inline-block" }
            , children:
              [ R.p_ [ R.text "percentReturns" ]
              , R.input
                  { type: "number", placeholder: "percentReturns", onChange: onInputChange (\val -> self.setState \s -> s { percentReturns = val })
                  }
              ]
            }
        , R.p_ [ R.text $ "Amount : " <> show (computeAmount years initialAmount percentReturns) ]
        ]
