import QtQuick 2.2
import Bacon2D 1.0
import QtQuick.Controls 1.1

ApplicationWindow {
    height: mainCol.height
    width: mainCol.width
    maximumHeight: mainCol.height
    minimumHeight: mainCol.height
    maximumWidth: mainCol.width
    minimumWidth: mainCol.width
    title: "Bacon2D Editor"

    menuBar: MenuBar {
        Menu {
            title: "File"
            MenuItem { 
                text: "Save"
                onTriggered: { 
                    world.reset()
                    world.running = false
                    qmlWriter.save(game, "mygame/game.qml")
                }
            }
            MenuItem { 
                text: "Quit" 
                onTriggered: Qt.quit()
            }
        }
    }

    Column {
        id: mainCol
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        spacing: 5

        Row {
            spacing: 5

            Rectangle {
                border.color: "#000000"
                border.width: 1
                width: 800
                height: 600

                Game {
                    id: game
                    anchors.fill: parent
                    currentScene: scene

                    Scene {
                        id: scene
                        anchors.fill: parent
        
                        World {
                            id: world
                            anchors.fill: parent
                            running: false
                            clip: true
                            property var originalProperties: []
        
                            DebugDraw {
                                id: debugDraw
                                anchors.fill: parent
                                world: world
                                opacity: 1
                                visible: false
                            }

                            function reset() {
                                for(var i = 0; i < world.originalProperties.length; i++) {
                                    var item = world.originalProperties[i]["item"]
                                    item.x = world.originalProperties[i]["x"]
                                    item.y = world.originalProperties[i]["y"]
                                    if(item.linearVelocity != undefined) {
                                        item.linearVelocity = Qt.point(0, 0)
                                        item.awake = true
                                    }
                                }
                            }
                        }
                    }
                }
            }

            SplitView {
                orientation: Qt.Vertical
                width: 200
                height: game.height

                Item {
                    width: parent.width
                    height: game.height/2
                    Label {
                        id: entityLabel
                        text: "Entities"
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Rectangle {
                        color: "#FFFFFF"
                        border.color: "#000000"
                        border.width: 1
                        anchors.fill: parent
                        anchors.topMargin: 20
            
                        GridView {
                            anchors.fill: parent
                            anchors.topMargin: 5
                            anchors.bottomMargin: 5
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            cellWidth: 63
                            cellHeight: 63
                            interactive: false
                            clip: true

                            model: entityModel
                            delegate: PaletteItem {
                                z: 10
                                width: 58
                                height: 58
                                componentFile: model.display
                                Component.onCompleted: { 
                                    var comp = Qt.createComponent(model.display)
                                    var obj = comp.createObject()
                                    image = "mygame/" + obj.image
                                }
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    Label {
                        text: "Properties"
                        anchors.top: parent.top
                        anchors.topMargin: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

        }

        Row {

            spacing: 10
            
            Button {
                text: "Debug view: " + (debugDraw.visible ? "on" : "off")
                onClicked: {
                    debugDraw.visible = !debugDraw.visible;
                }
            }

            Button {
                text: world.running ? "Pause" : "Play"
                onClicked: world.running = !world.running
            }

            Button {
                text: "Reset"
                onClicked: world.reset()
            }
        }

        StatusBar {
            Label { 
                text: world.running ? "Playing" : "Paused"
            }
        }

    }

}
