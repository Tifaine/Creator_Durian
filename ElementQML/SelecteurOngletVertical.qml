import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.13

Item {
    id: element
    height:100
    width: 900
    signal changeAffichage(var nb)
    property int indiceAffiche:0

    Component.onCompleted:
    {
        console.log(row.width / listModel.count, row.width, listModel.count)
    }

    Row {
        id: row
        anchors.fill: parent

        ListModel
        {
            id:listModel
            ListElement{ _nom:"Afficher étapes"   ; index : 0 }
            ListElement{ _nom:"Afficher positions"; index : 1 }
            ListElement{ _nom:"Afficher les deux" ; index : 2 }
        }

        Repeater
        {
            id:repeater
            model:listModel
            anchors.fill: parent

            RowLayout {
                id: rowLayout
                width: row.width/listModel.count
                height: 100

                MouseArea
                {
                    id: mouseArea1
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onClicked:
                    {
                        element.indiceAffiche=index
                        element.changeAffichage(index)
                    }
                    Rectangle {
                        id: rectangle4
                        color:indiceAffiche==index?"#262626":"transparent"
                        anchors.bottomMargin: 1
                        anchors.fill: parent
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Text {
                        id: element2
                        text: _nom
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        font.pixelSize: 12
                        color:indiceAffiche==index?"white":"white"
                    }

                    Rectangle {
                        id: rectangle2
                        height: 1
                        color: "white"
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.top: rectangle4.bottom
                        anchors.topMargin: 0
                        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                        Layout.preferredHeight: 1
                        Layout.fillWidth: true
                    }

                }
            }

        }

    }
}
