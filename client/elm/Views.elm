module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, id, href, src, alt)
import WebData exposing (WebData(..))

import Models exposing (Model, SeriesCollection, Series, Route(..), getSingleSeries, getEpisode)
import Messages exposing (Msg)

import Views.MenuView
import Views.SeriesSingleView
import Views.SeriesListView
import Views.NewSeriesView
import Views.EpisodeView

-- VIEW
        
view : Model -> Html Msg
view model =
    div [ class "elm-container" ]
        [ Views.MenuView.view model
        , page model
        ]

        
page : Model -> Html Msg
page model =
    case model.route of
        SeriesCollectionRoute ->
            Views.SeriesListView.view model.series

        SeriesRoute id ->
            let
                singleSeries = 
                    getSingleSeries model.series id
            in
                case singleSeries of
                    Just s ->
                        Views.SeriesSingleView.view s
                    Nothing ->
                        notFoundView

        NewSeriesRoute ->
            Views.NewSeriesView.view model

        EpisodeRoute seriesId episodeId ->
            let
                singleSeries = 
                    getSingleSeries model.series seriesId
                episode =
                    getEpisode singleSeries episodeId
            in
                case singleSeries of
                    Just s ->
                        case episode of
                            Just e ->
                                Views.EpisodeView.view s e
                            _ ->
                                notFoundView
                    Nothing ->
                        notFoundView

        NotFoundRoute ->
            notFoundView


notFoundView : Html Msg
notFoundView =
    div []
        [ text "not found"]
