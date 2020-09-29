import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import dyna 1.0

Item {
    id:element
    width: 1500
    height: 800
    property var dynaSelected : -1

    ListModel
    {
        id:listDyna
        ListElement{ index : 0; _color:"#00ffffff"; value: 0; iddyna : 0; speedDyna : 0}
    }
    Component.onCompleted:
    {
        listDyna.clear()
    }

    Connections
    {
        target:gestDynamixel

        function onAjoutDyna(id)
        {
            listDyna.append({index : listDyna.count,_color:"#00ffffff", value: 0, iddyna : id, speedDyna : 0})
        }
    }

    Flickable
    {
        clip:true
        id: flickable
        height: 100
        flickableDirection: Flickable.HorizontalFlick
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        contentWidth: 5000; contentHeight: 100
        contentX: 0
        contentY:0

        ScrollBar.horizontal: ScrollBar {
            parent: flickable.parent
            anchors.left: flickable.left
            anchors.right: flickable.right
            anchors.bottom: flickable.bottom
        }
        Rectangle
        {
            id:rectangle5
            anchors.fill: parent
            color:"transparent"

            function updateColor(indice)
            {

                listDyna.setProperty(indice,"_color","#300000");
                if(behaviorSelected !== -1 && indice !== behaviorSelected)
                {
                    listDyna.setProperty(behaviorSelected,"_color","#00ffffff");
                }

                behaviorSelected = indice
            }

            property int behaviorSelected:-1
            Repeater
            {
                id:repeaterListDyna
                model:listDyna
                anchors.fill: parent
                Rectangle
                {
                    id:rect
                    height:85
                    width:85
                    color:_color
                    radius: 10
                    border.color: "#ffffff"
                    border.width: 1
                    anchors.left: repeaterListDyna.left
                    anchors.leftMargin: 100*index
                    anchors.top: repeaterListDyna.top
                    anchors.topMargin: 5

                    Dyna
                    {
                        id:dyna
                        nom:"Dyna"+iddyna
                        mValue: value
                        mid:iddyna
                        vitesse: speedDyna
                        Component.onCompleted: gestDynamixel.addDyna(dyna);

                        onValueChanged: textFieldValue.text = mValue
                        onVitesseChanged: textFieldSpeed.text = vitesse
                    }


                    Rectangle
                    {
                        id: rectangle
                        color: _color//"#0cfdfdfd"
                        radius: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 3
                        anchors.left: parent.left
                        anchors.leftMargin: 3
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        anchors.top: parent.top
                        anchors.topMargin: 3
                        Text {
                            id: nomDyna
                            text: dyna.nom
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.top: parent.top
                            anchors.topMargin: 5
                            color:"white"
                            font.bold: true
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            z:1
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked:
                            {
                                rectangle5.updateColor(index)
                                gestDynamixel.getValue(dyna)
                                dynaSelected = dyna
                                textFieldID.text = dyna.mid
                                textFieldNom.text = dyna.nom
                                textFieldSpeed.text = dyna.vitesse
                                textFieldValue.text = dyna.mValue
                            }
                        }

                        Text {
                            id: textIdDyna
                            text: "ID : "+dyna.mid
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.top: nomDyna.bottom
                            anchors.topMargin: 5
                            font.pixelSize: 10
                            color:"white"
                        }

                        Text {
                            id: textValueDyna
                            text: "Value : "+dyna.mValue
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.top: textIdDyna.bottom
                            anchors.topMargin: 5
                            font.pixelSize: 10
                            color:"white"
                        }

                        Text {
                            id: textSpeedDyna
                            text: "Vitesse : "+dyna.vitesse
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.top: textValueDyna.bottom
                            anchors.topMargin: 5
                            font.pixelSize: 10
                            color:"white"
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: rectangle1
        height: 1
        color: "#ffffff"
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: flickable.bottom
        anchors.topMargin: 5
    }

    Text {
        id: textID
        text: qsTr("ID :")
        color:"white"
        font.bold: true
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: rectangle1.bottom
        anchors.topMargin: 40
        font.pixelSize: 12
    }

    TextField {
        id: textFieldID
        text: qsTr("Text Field")
        anchors.left: textID.right
        anchors.leftMargin: 38
        anchors.top: rectangle1.bottom
        anchors.topMargin: 35
        width: 150
        color: "white"
        background: Rectangle {
            color:"#22ffffff"
            radius: 10
            border.color: "#333"
            anchors.fill: parent
            border.width: 1
        }
    }

    Text {
        id: textName
        text: qsTr("Nom :")
        color:"white"
        font.bold: true
        anchors.top: textFieldID.bottom
        anchors.topMargin: 45
        anchors.left: parent.left
        anchors.leftMargin: 25
        font.pixelSize: 12
    }

    TextField {
        id: textFieldNom
        text: qsTr("Text Field")
        anchors.left: textName.right
        anchors.leftMargin: 25
        anchors.top: textFieldID.bottom
        anchors.topMargin: 40
        width: 150
        color: "white"
        background: Rectangle {
            color:"#22ffffff"
            radius: 10
            border.color: "#333"
            anchors.fill: parent
            border.width: 1
        }
    }

    Text {
        id: textValue
        text: qsTr("Value :")
        color:"white"
        font.bold: true
        anchors.top: textFieldNom.bottom
        anchors.topMargin: 45
        anchors.left: parent.left
        anchors.leftMargin: 25
        font.pixelSize: 12
    }

    TextField {
        id: textFieldValue
        text: dynaSelected !== -1 ? dynaSelected.mValue:0
        anchors.left: textValue.right
        anchors.leftMargin: 19
        anchors.top: textFieldNom.bottom
        anchors.topMargin: 40
        width: 150
        color: "white"
        onTextChanged:
        {
            if(dynaSelected!==-1)
            {
                dial.value = text
            }
        }

        background: Rectangle {
            color:"#22ffffff"
            radius: 10
            border.color: "#333"
            anchors.fill: parent
            border.width: 1
        }

    }

    Button {
        id: buttonUpdateDyna
        x: 1339
        width: 135
        height: 135
        text: qsTr("Rechercher dyna")
        font.bold: true
        font.pointSize: 10
        anchors.top: rectangle1.bottom
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 30
        onClicked:
        {
            gestDynamixel.publishGetListDyna()
        }
    }

    Button {
        id: buttonMoins
        width: 50
        height: 50
        text: qsTr("-")
        anchors.left: textFieldValue.left
        anchors.leftMargin: 0
        anchors.top: textFieldValue.bottom
        anchors.topMargin: 15
        font.pointSize: 15
        font.bold: true
        onClicked:
        {
            dynaSelected.mValue = dynaSelected.mValue - 1
            textFieldValue.text = dynaSelected.mValue
            dial.value = dynaSelected.mValue
        }
    }

    Button {
        id: buttonPlus
        x: 221
        width: 50
        height: 50
        text: qsTr("+")
        anchors.top: textFieldValue.bottom
        anchors.topMargin: 15
        anchors.right: textFieldValue.right
        anchors.rightMargin: 0
        font.pointSize: 15
        font.bold: true
        onClicked:
        {
            dynaSelected.mValue = dynaSelected.mValue + 1
            textFieldValue.text = dynaSelected.mValue
            dial.value = dynaSelected.mValue
        }
    }

    Dial {
        id: dial
        width: 150
        height: 150
        value:dynaSelected !== -1 ? dynaSelected.mValue:0
        stepSize: 1
        to: 1023
        anchors.left: buttonMoins.left
        anchors.leftMargin: 0
        anchors.top: buttonMoins.bottom
        anchors.topMargin: 33
        onAngleChanged:
        {
            if(dynaSelected !== -1)
            {
                dynaSelected.mValue = parseInt(value)
                textFieldValue.text = dynaSelected.mValue
                gestDynamixel.setValue(dynaSelected)
            }
        }

        background:
            Rectangle {
            x: dial.width / 2 - width / 2
            y: dial.height / 2 - height / 2
            width: Math.max(64, Math.min(dial.width, dial.height))
            height: width
            color: "transparent"
            radius: width / 2
            border.color: "#300000"
            opacity: dial.enabled ? 1 : 0.3
            border.width: 3
        }

        handle: Rectangle {
            id: handleItem
            x: dial.background.x + dial.background.width / 2 - width / 2
            y: dial.background.y + dial.background.height / 2 - height / 2
            width: 13
            height: 13
            color: dial.pressed ? "#600000" : "#800000"
            radius: 7
            antialiasing: true
            opacity: dial.enabled ? 1 : 0.3
            transform: [
                Translate {
                    y: -Math.min(dial.background.width, dial.background.height) * 0.4 + handleItem.height / 2
                },
                Rotation {
                    angle: dial.angle
                    origin.x: handleItem.width / 2
                    origin.y: handleItem.height / 2
                }
            ]
        }
    }

    Text {
        id: textValueSpeed
        x: 0
        y: 0
        color: "#ffffff"
        text: qsTr("Vitesse :")
        anchors.top: textFieldNom.bottom
        anchors.topMargin: 45
        anchors.left: sliderSpeed.left
        font.pixelSize: 12
        anchors.leftMargin: 0
        font.bold: true

    }

    TextField {
        id: textFieldSpeed
        x: 0
        y: 0
        color: "#ffffff"
        text: dynaSelected !== -1 ? dynaSelected.vitesse:0
        anchors.right: sliderSpeed.right
        anchors.rightMargin: 0
        anchors.top: textFieldNom.bottom
        anchors.topMargin: 40
        anchors.left: textValueSpeed.right
        background: Rectangle {
            color: "#22ffffff"
            radius: 10
            border.color: "#333333"
            border.width: 1
            anchors.fill: parent
        }
        anchors.leftMargin: 9
        onTextChanged:
        {
            if(dynaSelected!==-1)
            {
                sliderSpeed.value = text
            }
        }
    }

    Button {
        id: buttonMoinsSpeed
        x: 0
        y: 0
        width: 50
        height: 50
        text: qsTr("-")
        anchors.top: textFieldValue.bottom
        anchors.topMargin: 15
        anchors.left: sliderSpeed.left
        font.pointSize: 15
        anchors.leftMargin: 0
        font.bold: true
        onClicked:
        {
            dynaSelected.vitesse = dynaSelected.vitesse - 1
            textFieldSpeed.text = dynaSelected.vitesse
            sliderSpeed.value = dynaSelected.vitesse
        }
    }

    Button {
        id: buttonPlusSpeed
        x: 478
        y: 0
        width: 50
        height: 50
        text: qsTr("+")
        anchors.top: textFieldValue.bottom
        anchors.topMargin: 15
        anchors.right: sliderSpeed.right
        anchors.rightMargin: 0
        font.pointSize: 15
        font.bold: true
        onClicked:
        {
            dynaSelected.vitesse = dynaSelected.vitesse + 1
            textFieldSpeed.text = dynaSelected.vitesse
            sliderSpeed.value = dynaSelected.vitesse
        }
    }

    Slider {
        id: sliderSpeed
        x: 378
        y: 380
        width: 300
        height: 40
        stepSize: 1
        to: 1023
        value: 30
        onValueChanged:
        {
            if(dynaSelected !== -1)
            {
                dynaSelected.vitesse = parseInt(value)
                textFieldSpeed.text = dynaSelected.vitesse


            }
        }
    }
}

/*##^##
Designer {
    D{i:16;anchors_width:200;anchors_x:130;anchors_y:241}D{i:17;anchors_x:26;anchors_y:144}
D{i:19;anchors_x:26;anchors_y:215}D{i:18;anchors_x:85;anchors_y:132}D{i:20;anchors_x:85;anchors_y:203}
D{i:22;anchors_x:85;anchors_y:273}D{i:21;anchors_x:26;anchors_y:285}D{i:23;anchors_x:26;anchors_y:133}
D{i:25;anchors_x:77;anchors_y:329}D{i:24;anchors_x:363;anchors_y:141}D{i:26;anchors_y:329}
D{i:27;anchors_x:93;anchors_y:411}D{i:28;anchors_x:77;anchors_y:329}D{i:30;anchors_x:93;anchors_y:411}
D{i:29;anchors_y:329}D{i:36;anchors_width:150;anchors_x:363;anchors_y:141}D{i:35;anchors_x:26;anchors_y:133}
D{i:37;anchors_x:77;anchors_y:329}D{i:38;anchors_x:77;anchors_y:329}D{i:39;anchors_y:329}
}
##^##*/
