module Inventory (..) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import StartApp
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Json.Decode exposing (..)
import SocketIO


type alias Model =
  { items : List Item
  , errorMessage : String
  }


type alias Item =
  { id : Int
  , name : String
  , num_stocked : Int
  , price : Float
  }


itemDecoder : Decoder (List Item)
itemDecoder =
  list
    (object4
      Item
      ("id" := int)
      ("name" := string)
      ("num_stocked" := int)
      ("price" := float)
    )


type Action
  = Error String
  | FetchData
  | DataFetched (List Item)


app =
  StartApp.start
    { init = init
    , view = view
    , update = update
    , inputs = inputs
    }


main =
  app.html


port tasks : Signal (Task Never ())
port tasks =
  app.tasks


blankModel =
  { items = []
  , errorMessage = ""
  }


init =
  ( blankModel
  , fetchData
  )


update action model =
  case action of
    Error message ->
      ( { model | items = [], errorMessage = message }, Effects.none )

    FetchData ->
      ( blankModel, fetchData )

    DataFetched items ->
      ( { model | items = items }, Effects.none )


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ text model.errorMessage
    , if not (List.isEmpty model.items) then
        div
          [ class "row header" ]
          [ div [] [ text "Name" ]
          , div [] [ text "Price" ]
          , div [] [ text "In Stock" ]
          ]
      else
        button [ onClick address FetchData ] [ text "Load data" ]
    , div
        []
        (List.map
          (\item ->
            div
              [ class "row" ]
              [ div [] [ text item.name ]
              , div [] [ text (toString item.price) ]
              , div [] [ text (toString item.num_stocked) ]
              ]
          )
          model.items
        )
    ]


resultToAction : Result Http.Error (List Item) -> Action
resultToAction result =
  case result of
    Ok items ->
      DataFetched items

    Err err ->
      Error (toString err)


fetchData : Effects Action
fetchData =
  Http.post itemDecoder "http://localhost:3000/fetchItems" Http.empty
    |> Task.toResult
    |> Task.map resultToAction
    |> Effects.task


eventName =
  "update_counts"


socket : Task x SocketIO.Socket
socket =
  SocketIO.io "http://localhost:3001" SocketIO.defaultOptions


received : Signal.Mailbox String
received =
  Signal.mailbox ""


port responses : Task x ()
port responses =
  socket `Task.andThen` SocketIO.on eventName received.address


stringToAction : String -> Action
stringToAction receivedString =
  FetchData


inputs : List (Signal Action)
inputs =
  [ Signal.map stringToAction received.signal ]
