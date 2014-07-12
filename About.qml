import QtQuick 2.2
import QtQuick.Controls 1.1

ApplicationWindow {
    id: about
    height: 400
    width: 400
    maximumHeight: 400
    minimumHeight: 400
    maximumWidth: 400
    minimumWidth: 400
    title: "Vegan2D"

    Image {
        id: banner
        anchors.top: parent.top
        source: "images/vegan2d-about-banner.png"
        fillMode: Image.PreserveAspectCrop
    }

    Column {
        anchors.top: banner.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        spacing: 10

        Label {
            font.bold: true
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "Vegan2D 0.1"
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "A game creation tool for the Bacon2D game engine."
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "<a href='http://www.bacon2d.com'>http://www.bacon2d.com</a><br />"
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("http://www.bacon2d.com")
            }
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "Authors:"
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "Mike Sheldon - <a href='mailto:mike@mikeasoft.com'>mike@mikeasoft.com</a>"
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("mailto:mike@mikeasoft.com")
            }
        }

    }

    Button {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        text: "Close"
        onClicked: about.hide()
    }

}
