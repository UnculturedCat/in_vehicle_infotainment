// Copyright (C) 2024 Daniel Dickson Dillimono.
/*
   Main map view
*/

import QtQuick 2.15
import QtLocation
import QtPositioning
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Studio.Effects
import "../CustomWidgets"
import Search_Controller 1.0
//import "Search_Contoller"

Rectangle {
    color: "#D9D9D9"

    anchors{
        top: parent.top
        left: media_playback_screen.right
        right: parent.right
        bottom: parent.bottom
    }

    Search_Model{
        id: searchModel
        controller: maps_controller
    }

    Plugin{
        id: plugin
        name: "osm"
        PluginParameter { name: "osm.mapping.providersrepository.address"; value: "https://tile.thunderforest.com/transport/{z}/{x}/{y}.png?apikey=d12e3d8af8964a75aeecf1964ea87d71" }
        PluginParameter { name: "osm.mapping.highdpi_tiles"; value: true }
    }

    // PositionSource {
    //     id: positionSource
    //     active: true
    //     onPositionChanged: {
    //         //only center map on device location if the user did not search for anything
    //         if(geoCodeModel.status !== GeocodeModel.Ready || maps_controller.searchTerm === "")
    //             mapView.map.center = positionSource.position.coordinate
    //     }
    // }

    MapView{
        id: mapView
        anchors.fill: parent
        map.plugin: plugin
        map.zoomLevel: maps_controller.mapZoomLevel
        map.center: maps_controller.deviceLocation
        //User location marker
        MapItemView
        {
            id: userLocationItem
            model: maps_controller.positionSource
            parent: mapView.map
            delegate: MapQuickItem
            {
                coordinate: maps_controller.deviceLocation
                anchorPoint.x: userLocationImage.width * 0.5
                anchorPoint.y: userLocationImage.height

                sourceItem: Image {
                    id: userLocationImage
                    source: "../assets/car.png"
                    sourceSize{
                        width: 30
                        height: 30
                    }
                }
            }
        }

        //Search result marker(s)
        MapItemView
        {
            id: mapItemView
            model: searchModel
            parent: mapView.map
            delegate: MapQuickItem
            {
                coordinate: model.coordinate

                anchorPoint.x: makerImage.width * 0.5
                anchorPoint.y: makerImage.height

                sourceItem: Image {
                    id: makerImage
                    source: "../assets/location-pin.png"
                    sourceSize{
                        width: 30
                        height: 30
                    }
                }
            }
        }
    }

    // PlaceSearchModel{
    //     id: searchModel
    //     plugin: plugin
    //     searchTerm: maps_controller.searchTerm
    //     searchArea: QtPositioning.circle(maps_controller.positionSource.coordinate, 1000000)
    //     Component.onCompleted: update()
    //     onSearchTermChanged:{
    //         update()
    //     }
    // }

    // GeocodeModel{
    //     id: geoCodeModel
    //     plugin: plugin
    //     query: maps_controller.searchTerm
    //     autoUpdate: true
    //     bounds: QtPositioning.circle(maps_controller.positionSource.coordinate, 1000000)
    //     onLocationsChanged: {

    //         //This signal is triggered when the user's search query is valid. Therefore center the map around the first element in the search result: get(0).lat and get(0).long
    //         if(status === GeocodeModel.Ready && maps_controller.centerOnFirstSearchResult){
    //             mapView.map.center = QtPositioning.coordinate(geoCodeModel.get(0).coordinate.latitude, geoCodeModel.get(0).coordinate.longitude)
    //         }
    //     }
    // }

    SearchBar{
        id:searchbar
    }

    QuickDestinationNavBar{
        id:quickDestinationNavBar
    }

    MapControlPanel{
        id:map_control_panel
    }

}
