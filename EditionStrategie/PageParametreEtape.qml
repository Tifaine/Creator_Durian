import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Item
{
    id: element1
    width:585
    height:800
    property var mEtape: 0
    visible:false

    function updateVisibility(isStepShowed)
    {
        if(!isStepShowed)
        {
            element1.visible = false;
        }else
        {
            if(mEtape !== 0)
            {
                element1.visible = true
            }else
            {
                element1.visible = false
            }
        }
    }

    function updateParam(etape)
    {

        mEtape = etape
        if(mEtape.toString().indexOf("Etape")===0)
        {
            element1.visible = true
            elementtextNomEtape.text = mEtape.nomEtape
            textInfoDateMax.text = mEtape.dateMax
            textInfoDeadLine.text = mEtape.deadline
            textInfoNbPt.text = mEtape.nbPoints
            textInfoSequenceName.text = mEtape.nameSequence
            textInfoTempsMax.text = mEtape.tempsMax
            textInfoTempsMoyen.text = mEtape.tempsMoyen
            updateTaux()
        }else
        {
            element1.visible = false
        }
    }

    Rectangle
    {
        width:1
        color:"white"
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    Text {
        id: element
        color: "#ffffff"
        text: qsTr("Paramètres étape")
        font.bold: true
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: parent.top
        anchors.topMargin: 40
        font.pixelSize: 15
    }

    Text {
        id: elementtextNomEtape
        x: 521
        color: "#ffffff"
        text: qsTr("Déplacement")
        font.bold: true
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.top: parent.top
        anchors.topMargin: 40
        font.pixelSize: 15
    }

    Text {
        id: textInfoDateMax
        color: "#ffffff"
        text: qsTr("0")
        anchors.left: textDateMax.right
        anchors.leftMargin: 25
        anchors.top: element.bottom
        anchors.topMargin: 50
        font.pixelSize: 12
    }

    Text {
        id: textDateMax
        width: 110
        color: "#ffffff"
        text: qsTr("Date max :")
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: element.bottom
        anchors.topMargin: 50
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: textDeadLine
        width: 110
        color: "#ffffff"
        text: qsTr("Deadline : ")
        anchors.top: textDateMax.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 25
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: textNbPoint
        width: 110
        color: "#ffffff"
        text: qsTr("Nombre de points")
        anchors.top: textDeadLine.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 25
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: textTempsMax
        width: 110
        color: "#ffffff"
        text: qsTr("Temps max : ")
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: textNbPoint.bottom
        anchors.topMargin: 30
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: textTempsMoyen
        width: 110
        color: "#ffffff"
        text: qsTr("Temps moyen : ")
        anchors.top: textTempsMax.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 25
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: textSequenceName
        width: 110
        color: "#ffffff"
        text: qsTr("Sequence liée : ")
        anchors.top: textTempsMoyen.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 25
        font.bold: true
        font.pixelSize: 12
    }

    Text {
        id: textInfoDeadLine
        color: "#ffffff"
        text: qsTr("0")
        anchors.left: textDeadLine.right
        anchors.leftMargin: 25
        anchors.top: textInfoDateMax.bottom
        anchors.topMargin: 30
        font.pixelSize: 12
    }

    Text {
        id: textInfoNbPt
        color: "#ffffff"
        text: qsTr("0")
        anchors.left: textNbPoint.right
        anchors.leftMargin: 25
        anchors.top: textInfoDeadLine.bottom
        anchors.topMargin: 30
        font.pixelSize: 12
    }

    Text {
        id: textInfoTempsMax
        color: "#ffffff"
        text: qsTr("0")
        anchors.left: textTempsMax.right
        anchors.leftMargin: 25
        anchors.top: textInfoNbPt.bottom
        anchors.topMargin: 30
        font.pixelSize: 12
    }

    Text {
        id: textInfoTempsMoyen
        color: "#ffffff"
        text: qsTr("0")
        anchors.left: textTempsMoyen.right
        anchors.leftMargin: 25
        anchors.top: textInfoTempsMax.bottom
        anchors.topMargin: 30
        font.pixelSize: 12
    }

    Text {
        id: textInfoSequenceName
        color: "#ffffff"
        text: qsTr("0")
        anchors.left: textSequenceName.right
        anchors.leftMargin: 25
        anchors.top: textInfoTempsMoyen.bottom
        anchors.topMargin: 30
        font.pixelSize: 12
    }

    Button {
        id: buttonAjoutTaux
        width: 208
        height: 40
        text: qsTr("Ajouter un taux")
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: textParam.top
        anchors.bottomMargin: 20

        font.bold: true
        font.pointSize: 9
        onClicked:
        {
            mEtape.addItemTaux()
            listTaux.append({"param" : 0, "condition" : 0, "value" : 0, "ratio" : 0, index:listTaux.count})
        }
    }

    function updateTaux()
    {
        if(mEtape !== 0 )
        {
            var count = mEtape.getNbTaux()
            listTaux.clear()
            for( var i = 0; i < count; i++)
            {
                listTaux.append({"param" : mEtape.getParamTaux(i), "condition" : mEtape.getCondTaux(i), "value" : mEtape.getValueTaux(i), "ratio" : mEtape.getRatioTaux(i), index:listTaux.count})
            }
        }
    }

    Text {
        id: textParam
        width: 133
        height: 15
        color: "#ffffff"
        text: qsTr("Paramètre")
        anchors.top: textInfoSequenceName.bottom
        anchors.topMargin: 45
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
        font.pixelSize: 13
    }

    Text {
        id: textCond
        width: 137
        height: 15
        color: "#ffffff"
        text: qsTr("Condition")
        anchors.top: textInfoSequenceName.bottom
        anchors.topMargin: 45
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.left: textParam.right
        anchors.leftMargin: 0
        font.pixelSize: 13
    }

    Text {
        id: textValue
        width: 88
        height: 15
        color: "#ffffff"
        text: qsTr("Valeur")
        anchors.top: textInfoSequenceName.bottom
        anchors.topMargin: 45
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        anchors.left: textCond.right
        anchors.leftMargin: 0
        font.pixelSize: 13
    }

    Text {
        id: textTaux
        width: 119
        height: 15
        color: "#ffffff"
        text: qsTr("Taux")
        anchors.top: textInfoSequenceName.bottom
        anchors.topMargin: 45
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.left: textValue.right
        anchors.leftMargin: 14
        font.pixelSize: 13
    }

    ListModel
    {
        id:listTaux
        ListElement{ param:0 ; condition : 2; value:25; ratio:100; index:0}
        ListElement{ param:1 ; condition : 0; value:7; ratio:50; index:1}
    }

    Flickable
    {
        clip:true
        id: flickableTaux
        anchors.top: textParam.bottom
        anchors.topMargin: 40
        anchors.right: parent.right
        anchors.rightMargin: 5
        flickableDirection: Flickable.VerticalFlick
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 05
        contentWidth: parent.width; contentHeight: 5000
        contentX: 0
        contentY:0

        ScrollBar.vertical: ScrollBar {
            parent: flickableTaux.parent
            anchors.top:flickableTaux.top
            anchors.right: flickableTaux.right
            anchors.bottom: flickableTaux.bottom
        }
        Rectangle
        {
            id:rectangleTaux
            anchors.fill: parent
            color:"transparent"
            Component.onCompleted: listTaux.clear()
            property var taux : mEtape!==0?mEtape:0

            property int behaviorSelected:-1
            Repeater
            {
                id:repeaterTaux
                model:listTaux
                anchors.fill: parent
                Rectangle
                {
                    id:rectTaux
                    height:50
                    color:"transparent"
                    radius: 10
                    anchors.left: repeaterTaux.left
                    anchors.leftMargin: 0
                    anchors.right: repeaterTaux.right
                    anchors.rightMargin: 0
                    anchors.top: repeaterTaux.top
                    anchors.topMargin:((51*index))

                    ComboBox {
                        id: controlParam
                        width: (flickableTaux.width-25)/4
                        height: 40
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        model: ["Temps", "Gobelet"]
                        currentIndex: param
                        onCurrentIndexChanged:
                        {
                            if(mEtape !== 0)
                            {
                                rectangleTaux.taux.setParamTaux(index, currentIndex)
                            }
                        }

                        delegate: ItemDelegate {
                            width: controlParam.width
                            contentItem: Text {
                                text: modelData
                                color: "white"
                                font: controlParam.font
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }
                            highlighted: controlParam.highlightedIndex === index
                            background: Rectangle {
                                implicitWidth: 120
                                implicitHeight: 40
                                color:controlParam.highlightedIndex === index ? "#262626" : "transparent"
                            }
                        }

                        indicator: Canvas {
                            id: canvas
                            x: controlParam.width - width - controlParam.rightPadding
                            y: controlParam.topPadding + (controlParam.availableHeight - height) / 2
                            width: 12
                            height: 8
                            contextType: "2d"

                            Connections {
                                target: controlParam
                                function onPressedChanged()
                                {
                                    canvas.requestPaint()
                                }
                            }


                            onPaint: {
                                context.reset();
                                context.moveTo(0, 0);
                                context.lineTo(width, 0);
                                context.lineTo(width / 2, height);
                                context.closePath();
                                context.fillStyle = controlParam.pressed ? "#4d0000" : "#660000";
                                context.fill();
                            }
                        }

                        contentItem: Text {
                            leftPadding: 10
                            rightPadding: controlParam.indicator.width + controlParam.spacing

                            text: controlParam.displayText
                            font: controlParam.font
                            color: "white"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitWidth: 120
                            implicitHeight: 40
                            color:"#262626"
                            border.color: controlParam.pressed ? "#4d0000" : "#66000"
                            border.width: controlParam.visualFocus ? 2 : 1
                            radius: 2
                        }

                        popup: Popup {
                            y: controlParam.height - 1
                            width: controlParam.width
                            implicitHeight: contentItem.implicitHeight
                            padding: 1

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: controlParam.popup.visible ? controlParam.delegateModel : null
                                currentIndex: controlParam.highlightedIndex

                                ScrollIndicator.vertical: ScrollIndicator { }
                            }

                            background: Rectangle {
                                border.color: "#4d0000"
                                color:"#363636"
                                radius: 2
                            }
                        }
                    }

                    Rectangle {
                        id: rectangleBottom
                        y: 384
                        height: 1
                        color: "#ffffff"
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                    }

                    Rectangle {
                        id: rectangleParamCond
                        width: 1
                        color: "#ffffff"
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        anchors.left: controlParam.right
                        anchors.leftMargin: 5
                    }


                    ComboBox {
                        id: controlCond
                        width: (flickableTaux.width-25)/4
                        height: 40
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: rectangleParamCond.left
                        anchors.leftMargin: 5
                        currentIndex: condition
                        onCurrentIndexChanged:
                        {
                            if (mEtape !== 0)
                            {
                                rectangleTaux.taux.setCondTaux(index, currentIndex)
                            }
                        }

                        model: [">", "=", "<"]

                        delegate: ItemDelegate {
                            width: controlCond.width
                            contentItem: Text {
                                text: modelData
                                color: "white"
                                font: controlCond.font
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }
                            highlighted: controlCond.highlightedIndex === index
                            background: Rectangle {
                                implicitWidth: 120
                                implicitHeight: 40
                                color:controlCond.highlightedIndex === index ? "#262626" : "transparent"
                            }
                        }

                        indicator: Canvas {
                            id: canvas1
                            x: controlCond.width - width - controlCond.rightPadding
                            y: controlCond.topPadding + (controlCond.availableHeight - height) / 2
                            width: 12
                            height: 8
                            contextType: "2d"

                            Connections {
                                target: controlCond
                                function onPressedChanged()
                                {
                                    canvas1.requestPaint()
                                }
                            }

                            onPaint: {
                                context.reset();
                                context.moveTo(0, 0);
                                context.lineTo(width, 0);
                                context.lineTo(width / 2, height);
                                context.closePath();
                                context.fillStyle = controlCond.pressed ? "#4d0000" : "#660000";
                                context.fill();
                            }
                        }

                        contentItem: Text {
                            leftPadding: 10
                            rightPadding: controlCond.indicator.width + controlCond.spacing

                            text: controlCond.displayText
                            font: controlCond.font
                            color: "white"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitWidth: 120
                            implicitHeight: 40
                            color:"#262626"
                            border.color: controlCond.pressed ? "#4d0000" : "#66000"
                            border.width: controlCond.visualFocus ? 2 : 1
                            radius: 2
                        }

                        popup: Popup {
                            y: controlCond.height - 1
                            width: controlCond.width
                            implicitHeight: contentItem.implicitHeight
                            padding: 1

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: controlCond.popup.visible ? controlCond.delegateModel : null
                                currentIndex: controlCond.highlightedIndex

                                ScrollIndicator.vertical: ScrollIndicator { }
                            }

                            background: Rectangle {
                                border.color: "#4d0000"
                                color:"#363636"
                                radius: 2
                            }
                        }
                    }


                    Rectangle {
                        id: rectangleCondValue
                        width: 1
                        color: "#ffffff"
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        anchors.left: controlCond.right
                        anchors.leftMargin: 5
                    }

                    TextField {
                        id: textFieldValue
                        width: flickableTaux.width/4 - 15
                        text: value
                        anchors.left: rectangleCondValue.right
                        anchors.leftMargin: 5
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        validator: IntValidator{bottom : 0; top : 100}
                        color: "white"
                        background: Rectangle {
                            color:"#22ffffff"
                            radius: 10
                            border.color: "#333"
                            anchors.fill: parent
                            border.width: 1
                        }
                        onTextChanged:
                        {
                            if(mEtape !== 0)
                            {
                                rectangleTaux.taux.setValueTaux(index, parseInt(text));
                            }
                        }
                    }

                    Rectangle {
                        id: rectangleValueRatio
                        width: 1
                        color: "#ffffff"
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        anchors.left: textFieldValue.right
                        anchors.leftMargin: 5
                    }

                    TextField {
                        id: textFieldRatio
                        width: (flickableTaux.width)/4 - 15
                        text: ratio
                        anchors.left: rectangleValueRatio.right
                        anchors.leftMargin: 5
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        validator: IntValidator{bottom : 0; top : 100}
                        color: "white"
                        background: Rectangle {
                            color:"#22ffffff"
                            anchors.fill: textFieldRatio
                            radius: 10
                            border.color: "#333"
                            border.width: 1
                        }
                        onTextChanged:
                        {
                            if(mEtape !== 0)
                            {
                                rectangleTaux.taux.setRatioTaux(index, parseInt(text));
                            }
                        }
                    }
                }
            }
        }
    }

}

/*##^##
Designer {
    D{i:2;anchors_y:29}D{i:4;anchors_x:135;anchors_y:0}D{i:5;anchors_x:25;anchors_y:106}
D{i:6;anchors_x:25;anchors_y:153}D{i:7;anchors_x:25;anchors_y:192}D{i:8;anchors_x:25;anchors_y:229}
D{i:9;anchors_x:25;anchors_y:270}D{i:10;anchors_x:25;anchors_y:312}D{i:11;anchors_x:159;anchors_y:154}
D{i:12;anchors_x:159;anchors_y:199}D{i:13;anchors_x:159;anchors_y:244}D{i:14;anchors_x:159;anchors_y:289}
D{i:15;anchors_x:159;anchors_y:334}D{i:19;anchors_y:430}
}
##^##*/
