import QtQuick 2.12
import QtQuick.Controls 2.13

Item {
    property var step:0
    visible: false
    id: element
    width: 550
    height: 650

    function affiche(etape)
    {
        visible = true
        step = etape
        nameEtape.text = etape.nomEtape
        xEtape.text = etape.xEtape
        yEtape.text = etape.yEtape
        tiDescription.text = gestEtape.getEtape(gestEtape.getIndiceEtape(step)).description
        controlType.currentIndex = gestEtape.getEtape(gestEtape.getIndiceEtape(step)).type
    }

    Text {
        id: textEtape
        color: "#ffffff"
        text: qsTr("Étape : ")
        anchors.left: parent.left
        anchors.leftMargin: 35
        anchors.top: parent.top
        anchors.topMargin: 35
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: nameEtape
        width: 100
        color: "#ffffff"
        text: qsTr("Init")
        anchors.left: textEtape.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 35
        font.pixelSize: 12
    }

    Text {
        id: textX
        color: "#ffffff"
        text: qsTr("X : ")
        fontSizeMode: Text.FixedSize
        font.bold: true
        anchors.left: nameEtape.right
        anchors.leftMargin: 150
        anchors.top: parent.top
        anchors.topMargin: 35
        font.pixelSize: 12
    }

    TextEdit {
        id: xEtape
        width: 35
        color: "#ffffff"
        text: qsTr("-1500")
        anchors.left: textX.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 35
        font.pixelSize: 12
    }

    Text {
        id: textY
        x: 413
        y: 35
        color: "#ffffff"
        text: qsTr("Y : ")
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: yEtape
        width: 30
        color: "#ffffff"
        text: qsTr("2000")
        anchors.left: textY.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 35
        font.pixelSize: 12
    }

    Rectangle {
        id: rectangle
        height: 100
        color: "#00ffffff"
        radius: 5
        anchors.right: parent.right
        anchors.rightMargin: 35
        anchors.left: parent.left
        anchors.leftMargin: 35
        anchors.top: textEtape.bottom
        anchors.topMargin: 25
        border.color: "#4d0000"
        border.width: 2

        TextInput {
            id: tiDescription
            color: "#ffffff"
            text: "Init"
            clip: true
            wrapMode: Text.WrapAnywhere
            selectedTextColor: "#ffffff"
            anchors.rightMargin: 3
            anchors.leftMargin: 3
            anchors.bottomMargin: 3
            anchors.topMargin: 3
            anchors.fill: parent
            font.pixelSize: 11
            onTextChanged:
            {
                gestEtape.getEtape(gestEtape.getIndiceEtape(step)).setDescription(text)
            }
        }
    }

    ComboBox {
        id: controlType
        width: 250
        height: 40
        anchors.top: rectangle.bottom
        anchors.topMargin: 25
        anchors.left: textType.right
        anchors.leftMargin: 10
        model: ["Init", "Verre vert", "Verre rouge", "Verres extérieurs base", "Verres extérieurs hors base", "Dépose base", "Dépose port secondaire"]

        onCurrentIndexChanged: step===0 ? 0:step.type = currentIndex
        delegate: ItemDelegate {
            width: controlType.width
            contentItem: Text {
                text: modelData
                color: "white"
                font: controlType.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            highlighted: controlType.highlightedIndex === index
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color:controlType.highlightedIndex === index ? "#262626" : "transparent"
            }
        }

        indicator: Canvas {
            id: canvas
            x: controlType.width - width - controlType.rightPadding
            y: controlType.topPadding + (controlType.availableHeight - height) / 2
            width: 12
            height: 8
            contextType: "2d"

            Connections {
                target: controlType
                onPressedChanged: canvas.requestPaint()
            }

            onPaint: {
                context.reset();
                context.moveTo(0, 0);
                context.lineTo(width, 0);
                context.lineTo(width / 2, height);
                context.closePath();
                context.fillStyle = controlType.pressed ? "#4d0000" : "#660000";
                context.fill();
            }
        }

        contentItem: Text {
            leftPadding: 10
            rightPadding: controlType.indicator.width + controlType.spacing

            text: controlType.displayText
            font: controlType.font
            color: "white"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 120
            implicitHeight: 40
            color:"#262626"
            border.color: controlType.pressed ? "#4d0000" : "#66000"
            border.width: controlType.visualFocus ? 2 : 1
            radius: 2
        }

        popup: Popup {
            y: controlType.height - 1
            width: controlType.width
            implicitHeight: contentItem.implicitHeight
            padding: 1

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: controlType.popup.visible ? controlType.delegateModel : null
                currentIndex: controlType.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                border.color: "#4d0000"
                color:"#363636"
                radius: 2
            }
        }
    }

    Text {
        id: textType
        color: "#ffffff"
        text: qsTr("Type : ")
        font.bold: true
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.top: rectangle.bottom
        anchors.topMargin: 30
        font.pixelSize: 12
    }
}

/*##^##
Designer {
    D{i:0;height:650;width:795}D{i:1;anchors_x:22;anchors_y:23}D{i:2;anchors_x:74;anchors_y:23}
D{i:3;anchors_x:266;anchors_y:35}D{i:4;anchors_x:279;anchors_y:35}D{i:6;anchors_x:438;anchors_y:35}
D{i:8;anchors_height:20;anchors_width:80;anchors_x:60;anchors_y:28}D{i:7;anchors_height:200;anchors_width:200;anchors_x:35;anchors_y:82}
D{i:9;anchors_x:46;anchors_y:225}D{i:21;anchors_x:15;anchors_y:241}
}
##^##*/
