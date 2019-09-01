module Components.Network where

import Prelude
import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat
import Data.Either (Either(..))
import Data.List.Types (NonEmptyList)
import Data.Maybe (Maybe(..), fromMaybe)
import Effect.Aff (launchAff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Foreign (ForeignError)
import React.Basic (Component, JSX, createComponent, make)
import React.Basic.DOM as R
import Simple.JSON as JSON

type TodoJSON
  = { userId :: Int
    , id :: Int
    , title :: String
    , completed :: Boolean
    }

type Props
  = Unit

data RequestStatus
  = Idle
  | Pending
  | NetworkSuccess
  | NetworkError
  | DecodeSuccess
  | DecodeError

instance showRoute :: Show RequestStatus where
  show Idle = "Idle"
  show Pending = "Pending"
  show NetworkSuccess = "NetworkSuccess"
  show NetworkError = "NetworkError"
  show DecodeSuccess = "DecodeSuccess"
  show DecodeError = "DecodeError"

url :: String
url = "https://jsonplaceholder.typicode.com/todos/"

decodeTodosJson :: String -> Either (NonEmptyList ForeignError) (Array TodoJSON)
decodeTodosJson = JSON.readJSON

component :: Component Props
component = createComponent "Network"

network :: Props -> JSX
network = make component { initialState, render, didMount }
  where
  initialState =
    { status: Idle
    , jsonString: Nothing
    , jsonData: Nothing
    }

  didMount { props, setState } =
    void $ launchAff
      $ do
          liftEffect $ setState \s -> s { status = Pending }
          res <- AX.get ResponseFormat.string url
          case res.body of
            Left err -> do
              liftEffect $ setState \s -> s { status = NetworkError }
              log $ "GET " <> url <> " response failed to decode: " <> AX.printResponseFormatError err
            Right json -> do
              liftEffect $ setState \s -> s { status = NetworkSuccess, jsonString = Just $ json }
              case decodeTodosJson json of
                Left _ -> liftEffect $ setState \s -> s { status = DecodeError }
                Right jsonData -> liftEffect $ setState \s -> s { status = DecodeSuccess, jsonData = Just jsonData }

  render self =
    R.div_
      [ R.h2_
          [ R.text "Network request"
          ]
      , R.p_ [ R.text $ "Status" <> " - " <> show self.state.status ]
      , R.p_ [ R.text "jsonString" ]
      , R.pre
          { style:
            R.css { maxHeight: "100px", overflowY: "scroll" }
          , children:
            [ R.text $ fromMaybe "" self.state.jsonString
            ]
          }
      , R.p_ [ R.text "Todos" ]
      , R.ul
          { style:
            R.css { maxHeight: "100px", overflowY: "scroll" }
          , children:
            case self.state.jsonData of
              Nothing -> []
              Just jsonData -> jsonData # map (\todo -> R.li_ [ R.text $ show todo.id <> " - " <> todo.title ])
          }
      ]
