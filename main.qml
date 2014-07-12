import QtQuick 2.2
import Bacon2D 1.0
import QtQuick.Controls 1.1

ApplicationWindow {
    id: win
    height: mainCol.height
    width: mainCol.width
    maximumHeight: mainCol.height
    minimumHeight: mainCol.height
    maximumWidth: mainCol.width
    minimumWidth: mainCol.width
    property bool snapToGrid: false
    property int gridSize: 32
    title: "Bacon2D Editor"

    menuBar: MenuBar {
        Menu {
            title: "File"
            MenuItem { 
                text: "Save"
                onTriggered: { 
                    scene.reset()
                    scene.running = false
                    qmlWriter.save(game, "mygame/game.qml")
                }
            }
            MenuItem { 
                text: "Quit" 
                onTriggered: Qt.quit()
            }
        }

        Menu {
            title: "Placement"
            MenuItem {
                text: "Snap to grid"
                checkable: true
                checked: win.snapToGrid
                onToggled: {
                    win.snapToGrid = checked
                }
            }
            Menu {
                title: "Grid Size"
                MenuItem { text: "8x8"; checkable: true; checked: win.gridSize == 8; onToggled: checked ? win.gridSize = 8 : '' }
                MenuItem { text: "16x16"; checkable: true; checked: win.gridSize == 16; onToggled: checked ? win.gridSize = 16 : '' }
                MenuItem { text: "32x32"; checkable: true; checked: win.gridSize == 32; onToggled: checked ? win.gridSize = 32 : '' }
                MenuItem { text: "64x64"; checkable: true; checked: win.gridSize == 64; onToggled: checked ? win.gridSize = 64 : '' }
            }
        }
    }

    Component {
        id: selectionComponent
        MouseArea {
            anchors.fill: parent
            enabled: !scene.running
            onClicked: propertyEditor.selectedItem = parent
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
                        running: false
                        property var originalProperties: []
                        clip: true
                        physics: true
                        Component.onCompleted: {scene.running = false}
        
                        function reset() {
                            for(var i = 0; i < scene.originalProperties.length; i++) {
                                var item = scene.originalProperties[i]["item"]
                                item.x = scene.originalProperties[i]["x"]
                                item.y = scene.originalProperties[i]["y"]
                                if(item.linearVelocity != undefined) {
                                    item.linearVelocity = Qt.point(0, 0)
                                    item.awake = true
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

                            Button {
                                width: 26
                                height: 26
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right
                                iconSource: "add.png"
                                tooltip: "Create New Entity"
                                onClicked: entityEditor.show()
                            }

                        }
                    }
                }

                Item {
                    id: propertyEditor
                    width: parent.width
                    property var selectedItem
                    visible: selectedItem != undefined

                    Label {
                        id: propLabel
                        text: "Properties"
                        anchors.top: parent.top
                        anchors.topMargin: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onSelectedItemChanged: {
                        bodyTypeCombo.currentIndex = selectedItem.bodyType == Entity.Static ? 0 : 1
                    }

                    Grid {
                        anchors.top: propLabel.bottom
                        anchors.topMargin: 10
                        anchors.right: parent.right
                        width: parent.width - 10
                        columns: 2
                        spacing: 10
                       
                        Label { text: "Body Type:" } 
                        ComboBox {
                            id: bodyTypeCombo
                            width: parent.width / 1.8
                            model: ListModel {
                                id: bodyTypeModel
                                ListElement { text: "Static"; bodyType: Entity.Static }
                                ListElement { text: "Dynamic"; bodyType: Entity.Dynamic }
                            }
                            onCurrentIndexChanged: propertyEditor.selectedItem.bodyType = bodyTypeModel.get(currentIndex).bodyType
                        }

                        Label { text: "X:" } 
                        SpinBox {
                            value: propertyEditor.selectedItem.x
                            onValueChanged: propertyEditor.selectedItem.x = value
                            maximumValue: game.width
                            minimumValue: 0
                        }

                        Label { text: "Y:" }
                        SpinBox {
                            value: propertyEditor.selectedItem.y
                            onValueChanged: propertyEditor.selectedItem.y = value
                            maximumValue: game.height
                            minimumValue: 0
                        }

                        Label { text: "Z:" }
                        SpinBox {
                            value: propertyEditor.selectedItem.z
                            onValueChanged: propertyEditor.selectedItem.z = value
                            maximumValue: 1000
                            minimumValue: 0
                        }

                        Label { 
                            text: "Restitution:"
                        }
                        SpinBox {
                            value: propertyEditor.selectedItem.restitution
                            onValueChanged: propertyEditor.selectedItem.restitution = value
                            maximumValue: 10
                            minimumValue: 0
                            stepSize: 0.1
                            decimals: 2
                        }

                        Label {
                            text: "Friction:"
                        }
                        SpinBox {
                            value: propertyEditor.selectedItem.friction
                            onValueChanged: propertyEditor.selectedItem.friction = value
                            maximumValue: 10
                            minimumValue: 0
                            stepSize: 0.1
                            decimals: 2
                        }

                        Label {
                            text: "Density:"
                        }
                        SpinBox {
                            value: propertyEditor.selectedItem.density
                            onValueChanged: propertyEditor.selectedItem.density = value
                            maximumValue: 10
                            minimumValue: 1
                            stepSize: 0.1
                            decimals: 2
                        }

                    }
                }
            }

        }

        Row {

            spacing: 10
            
            Button {
                text: "Debug view: " + (scene.debug ? "on" : "off")
                onClicked: {
                    scene.debug = !scene.debug;
                }
            }

            Button {
                text: scene.running ? "Pause" : "Play"
                onClicked: scene.running = !scene.running
            }

            Button {
                text: "Reset"
                onClicked: scene.reset()
            }
        }

        StatusBar {
            Label { 
                text: scene.running ? "Playing" : "Paused"
            }
        }

        EntityEditor {
            id: entityEditor
        }

    }

}
