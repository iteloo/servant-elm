module Generated.GiphyApi exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Json.Encode
import Http
import String


type alias Gif =
    { data : GifData
    }

type alias GifData =
    { image_url : String
    }

decodeGif : Decoder Gif
decodeGif =
    decode Gif
        |> required "data" decodeGifData

decodeGifData : Decoder GifData
decodeGifData =
    decode GifData
        |> required "image_url" string

getRandom : Maybe (String) -> Maybe (String) -> Http.Request (Gif)
getRandom query_api_key query_tag =
    let
        params =
            List.filter (not << String.isEmpty)
                [ query_api_key
                    |> Maybe.map (Http.encodeUri >> (++) "api_key=")
                    |> Maybe.withDefault ""
                , query_tag
                    |> Maybe.map (Http.encodeUri >> (++) "tag=")
                    |> Maybe.withDefault ""
                ]
    in
        Http.request
            { method =
                "GET"
            , headers =
                []
            , url =
                String.join "/"
                    [ "http://api.giphy.com/v1/gifs"
                    , "random"
                    ]
                ++ if List.isEmpty params then
                       ""
                   else
                       "?" ++ String.join "&" params
            , body =
                Http.emptyBody
            , expect =
                Http.expectJson decodeGif
            , timeout =
                Nothing
            , withCredentials =
                False
            }