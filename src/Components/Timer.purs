module Components.Timer where

import Prelude
import Data.Maybe (Maybe(..))
import Effect.Console (log)
import Effect.Timer (TimeoutId)
import Effect.Timer as T
import React.Basic (Component, JSX, StateUpdate(..), createComponent, make, runUpdate)
import React.Basic.DOM as R
import React.Basic.DOM.Events as RE

type Props
  = { duration :: Int, lapDuration :: Int
    }

type State
  = { isRunning :: Boolean
    , tid :: Maybe TimeoutId
    }

data Action
  = Start
  | Stop

component :: Component Props
component = createComponent "Timer"

timer :: Props -> JSX
timer = make component { initialState, render }
  where
  initialState = { isRunning: false, tid: Nothing, val: 0, iid: Nothing }

  update self action = case action of
    Start ->
      UpdateAndSideEffects
        (self.state { isRunning = true }) \{ state, props, setState } -> case state.tid of
        Nothing -> do
          iid <-
            T.setInterval props.lapDuration do
              setState \s -> s { val = s.val + 1 }
          tid <-
            T.setTimeout props.duration do
              T.clearInterval iid
              setState \s -> s { tid = Nothing, iid = Nothing, val = 0 }
              log $ "Timeout ended after " <> show props.duration <> "ms"
          setState \s -> s { tid = Just tid, iid = Just iid }
          pure unit
        Just _ -> pure unit
    Stop ->
      UpdateAndSideEffects
        (self.state { isRunning = false }) \{ state, setState } -> case state.tid of
        Nothing -> pure unit
        Just id -> do
          case state.iid of
            Nothing -> pure unit
            Just iid -> T.clearInterval iid
          T.clearTimeout id
          log "Stopped timeout."
          setState \s -> s { tid = Nothing, iid = Nothing, val = 0 }
          pure unit

  send = runUpdate update

  render self =
    R.div_
      [ R.h2_
          [ R.text "Timer"
          ]
      , R.p_
          [ R.text if self.state.isRunning then "Running " <> show self.state.val else ""
          ]
      , R.button
          { onClick: RE.capture_ $ send self Start
          , children: [ R.text "Start" ]
          }
      , R.button
          { onClick: RE.capture_ $ send self Stop
          , children: [ R.text "Stop" ]
          }
      ]
