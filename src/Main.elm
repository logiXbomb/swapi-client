module Main exposing (Msg(..), init, main, subscriptions, update, view)

import Browser exposing (UrlRequest(..))
import Browser.Navigation exposing (Key)
import Html.Styled exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Url exposing (Url)


init : String -> Url -> Key -> ( List Person, Cmd Msg )
init flags url key =
    ( [], getPeople )


view model =
    { title = "fdsa"
    , body =
        [ toUnstyled <|
            div []
                (List.map
                    (\p ->
                        div []
                            [ text
                                p.name
                            ]
                    )
                    model
                )
        ]
    }


update msg model =
    case msg of
        GetPeople (Ok res) ->
            ( res, Cmd.none )

        _ ->
            ( model, Cmd.none )


type alias Person =
    { name : String }


personDecoder : Decoder Person
personDecoder =
    Decode.map Person
        (field "name" string)


peopleDecoder : Decoder (List Person)
peopleDecoder =
    field "results" (list personDecoder)


type Msg
    = ChangedUrl Url
    | ClickedLink UrlRequest
    | GetPeople (Result Http.Error (List Person))


getPeople =
    Http.get
        { url = "https://swapi.co/api/people/"
        , expect = Http.expectJson GetPeople peopleDecoder
        }


subscriptions model =
    Sub.none


main =
    Browser.application
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }
