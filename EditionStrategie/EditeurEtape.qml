import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import etape 1.0
import itemTaux 1.0

Item {
    id: element
    width: 1500
    height: 800

    property int etapeEnCours: -1


    ListModel
    {
        id:listComportement
        ListElement{ _nom:"Deplacement" ; index : 0; _color:"#00ffffff"}
        ListElement{ _nom:"test" ; index : 1; _color:"#00ffffff"}
        ListElement{ _nom:"aaa" ; index : 2; _color:"#00ffffff"}
    }

    Component.onCompleted:
    {
        updateEtape()
    }

    function updateEtape()
    {
        listComportement.clear();
        for(var i = 0; i < gestEtape.getNbEtape(); i++)
        {
            listComportement.append({"_nom" : gestEtape.getEtape(i).nomEtape, "index" : listComportement.count, "_color" : "#00ffffff"})
        }
    }

    Flickable
    {
        clip:true
        id: flickable
        height: 100
        flickableDirection: Flickable.HorizontalFlick
        anchors.right: buttonAddEtape.left
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

                listComportement.setProperty(indice,"_color","#300000");
                if(behaviorSelected !== -1 && behaviorSelected !== indice)
                {
                    listComportement.setProperty(behaviorSelected,"_color","#00ffffff");
                }

                behaviorSelected = indice
            }

            property int behaviorSelected:-1
            Repeater
            {
                id:repeaterListAction
                model:listComportement
                anchors.fill: parent
                Rectangle
                {
                    id:rect
                    height:40
                    width:90
                    color:_color
                    radius: 10
                    border.color: "#ffffff"
                    border.width: 1
                    anchors.left: repeaterListAction.left
                    anchors.leftMargin: (index%2)==1?(index==1?0:(Math.floor(index/2))*100)+5:((index/2)*100)+5
                    anchors.top: repeaterListAction.top
                    anchors.topMargin:(index%2)==1?50:5


                    Rectangle
                    {
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
                            id: nomComportement
                            text: _nom
                            color:"white"
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }

                        /* Etape
                        {
                            id:etape
                            nomEtape: nomComportement.text
                            Component.onCompleted: gestEtape.addEtape(etape)
                        }*/

                        MouseArea
                        {
                            anchors.fill: parent
                            z:1
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            property var step: 0
                            onClicked:
                            {
                                step = gestEtape.getEtape(index)
                                rectangle5.updateColor(index)
                                etapeEnCours = -1
                                textFieldNomEtape.text = step.nomEtape
                                textFieldNbPoints.text = step.nbPoints
                                textFieldTpsMoyen.text = step.tempsMoyen
                                textFieldTpsMax.text = step.tempsMax
                                textFieldDateMax.text = step.dateMax
                                textFieldDeadline.text = step.deadline
                                etapeEnCours = index
                                updateTaux()
                            }
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
        anchors.rightMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.top: flickable.bottom
        anchors.topMargin: 0
    }

    Text {
        id: textNomEtape
        color: "#ffffff"
        text: qsTr("Nom étape : ")
        font.bold: true
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: rectangle1.bottom
        anchors.topMargin: 25
        font.pixelSize: 13

    }

    TextField {
        id: textFieldNomEtape
        text: qsTr("")
        anchors.left: textNomEtape.right
        anchors.leftMargin: 15
        anchors.top: rectangle1.bottom
        anchors.topMargin: 13
        onTextChanged:
        {
            if(etapeEnCours !== -1 )
            {
                gestEtape.getEtape(etapeEnCours).nomEtape = text
            }
        }
    }

    Text {
        id: textNbPoint
        color: "#ffffff"
        text: qsTr("Nombre de points : ")
        anchors.left: textFieldNomEtape.right
        anchors.leftMargin: 40
        anchors.top: rectangle1.bottom
        anchors.topMargin: 25
        font.bold: true
        font.pixelSize: 13

    }

    TextField {
        id: textFieldNbPoints
        x: 3
        y: 3
        text: qsTr("")
        anchors.leftMargin: 15
        anchors.topMargin: 13
        anchors.top: rectangle1.bottom
        anchors.left: textNbPoint.right
        validator: IntValidator{bottom : 0; top : 999999}
        onTextChanged:
        {
            if(etapeEnCours !== -1 )
            {
                gestEtape.getEtape(etapeEnCours).nbPoints = parseInt(text)
            }
        }
    }

    Button {
        id: buttonAddEtape
        x: 1457
        width: 90
        height: 90
        text: qsTr("Ajouter étape")
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
    }

    Text {
        id: textTempsMoyen
        color: "#ffffff"
        text: qsTr("Temps d'exécution moyen : ")
        font.bold: true
        anchors.left: textFieldNbPoints.right
        anchors.leftMargin: 40
        anchors.top: rectangle1.bottom
        anchors.topMargin: 25
        font.pixelSize: 13


        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                ToolTip.text=("Temps moyen mis pas le robot pour réaliser l'étape")
                ToolTip.visible=true
            }
            onExited: ToolTip.visible=false
        }
    }

    TextField {
        id: textFieldTpsMoyen
        x: -4
        y: -5
        text: qsTr("")
        anchors.topMargin: 13
        anchors.leftMargin: 30
        anchors.top: rectangle1.bottom
        anchors.left: textTempsMoyen.right
        validator: IntValidator{bottom : 0; top : 100}
        onTextChanged:
        {
            if(etapeEnCours !== -1 )
            {
                gestEtape.getEtape(etapeEnCours).tempsMoyen = parseInt(text)
            }
        }
    }

    Text {
        id: textTempsMax
        x: -2
        y: -2
        color: "#ffffff"
        text: qsTr("Temps d'exécution max : ")
        font.bold: true
        anchors.topMargin: 44
        anchors.leftMargin: 40
        anchors.top: textTempsMoyen.bottom
        font.pixelSize: 13
        anchors.left: textFieldNbPoints.right
        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                ToolTip.text=("Temps maximum autorisé au robot pour réaliser l'étape")
                ToolTip.visible=true
            }
            onExited: ToolTip.visible=false
        }
    }

    TextField {
        id: textFieldTpsMax
        x: -6
        y: -7
        text: qsTr("")
        anchors.leftMargin: 45
        anchors.topMargin: 20
        anchors.top: textFieldTpsMoyen.bottom
        anchors.left: textTempsMax.right
        validator: IntValidator{bottom : 0; top : 100}
        onTextChanged:
        {
            if(etapeEnCours !== -1 )
            {
                gestEtape.getEtape(etapeEnCours).tempsMax = parseInt(text)
            }
        }
    }

    Text {
        id: textDateMax
        x: 3
        y: 3
        color: "#ffffff"
        text: qsTr("Date max avant désactivation : ")
        font.bold: true
        anchors.topMargin: 40
        anchors.leftMargin: 40
        anchors.top: textTempsMax.bottom
        font.pixelSize: 13
        anchors.left: textFieldNbPoints.right
        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                ToolTip.text=("Date maximale de début de l'action avant qu'elle ne soit désactivée")
                ToolTip.visible=true
            }
            onExited: ToolTip.visible=false
        }
    }

    TextField {
        id: textFieldDateMax
        x: -1
        y: -2
        text: qsTr("")
        anchors.leftMargin: 5
        anchors.topMargin: 20
        anchors.top: textFieldTpsMax.bottom
        anchors.left: textDateMax.right
        validator: IntValidator{bottom : 0; top : 100}
        onTextChanged:
        {
            if(etapeEnCours !== -1 )
            {
                gestEtape.getEtape(etapeEnCours).dateMax = parseInt(text)
            }
        }
    }

    Text {
        id: textDeadLine
        x: 1
        y: 1
        color: "#ffffff"
        text: qsTr("Deadline : ")
        font.bold: true
        anchors.leftMargin: 40
        anchors.topMargin: 48
        anchors.top: textDateMax.bottom
        font.pixelSize: 13
        anchors.left: textFieldNbPoints.right
        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                ToolTip.text=("Date maximale de fin de l'action avant qu'elle ne soit désactivée")
                ToolTip.visible=true
            }
            onExited: ToolTip.visible=false
        }
    }

    TextField {
        id: textFieldDeadline
        x: -3
        y: -4
        text: qsTr("")
        anchors.topMargin: 20
        anchors.leftMargin: 142
        anchors.top: textFieldDateMax.bottom
        anchors.left: textDeadLine.right
        validator: IntValidator{bottom : 0; top : 100}
        onTextChanged:
        {
            if(etapeEnCours !== -1 )
            {
                gestEtape.getEtape(etapeEnCours).deadline = parseInt(text)
            }
        }
    }

    Button {
        id: buttonSave
        width: 200
        height: 50
        text: qsTr("Sauvegarder l'étape")
        font.bold: true
        font.pointSize: 10
        anchors.left: parent.left
        anchors.leftMargin: 275
        anchors.top: textFieldNomEtape.bottom
        anchors.topMargin: 65
        onClicked:
        {
            if(etapeEnCours !== -1 )
            {
                gestEtape.getEtape(etapeEnCours).save()
                gestEtape.updateEtape()
                updateEtape()
            }
        }
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
        width: 959
        height: 100
        flickableDirection: Flickable.VerticalFlick
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: textParam.bottom
        anchors.topMargin: 5
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
            property var taux : etapeEnCours!==-1?gestEtape.getEtape(etapeEnCours):0

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
                    anchors.leftMargin: 10
                    anchors.right: repeaterTaux.right
                    anchors.rightMargin: 10
                    anchors.top: repeaterTaux.top
                    anchors.topMargin:((51*index))

                    ComboBox {
                        id: controlParam
                        width: 250
                        height: 40
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        model: ["Temps", "Gobelet"]
                        currentIndex: param
                        onCurrentIndexChanged:
                        {
                            if(etapeEnCours !== -1)
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
                                onPressedChanged: canvas.requestPaint()
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
                        width: 250
                        height: 40
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: rectangleParamCond.left
                        anchors.leftMargin: 5
                        currentIndex: condition
                        onCurrentIndexChanged:
                        {
                            if (etapeEnCours !== -1)
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
                                onPressedChanged: canvas1.requestPaint()
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
                        text: value
                        anchors.left: rectangleCondValue.right
                        anchors.leftMargin: 5
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        validator: IntValidator{bottom : 0; top : 100}
                        onTextChanged:
                        {
                            if(etapeEnCours !== -1)
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
                        text: ratio
                        anchors.left: rectangleValueRatio.right
                        anchors.leftMargin: 5
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        validator: IntValidator{bottom : 0; top : 100}
                        onTextChanged:
                        {
                            if(etapeEnCours !== -1)
                            {
                                rectangleTaux.taux.setRatioTaux(index, parseInt(text));
                            }
                        }
                    }
                }
            }
        }
    }

    Text {
        id: element1
        text: qsTr("Tableau de taux :")
        color:"white"
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: buttonSave.bottom
        anchors.topMargin: 75
        font.bold: true
        font.pixelSize: 13
    }

    Button {
        id: buttonAjoutTaux
        width: 208
        height: 40
        text: qsTr("Ajouter un taux")
        anchors.top: buttonSave.bottom
        anchors.topMargin: 65
        anchors.left: element1.right
        anchors.leftMargin: 85
        font.bold: true
        font.pointSize: 9
        onClicked:
        {
            if(etapeEnCours !== -1 )
            {
                gestEtape.getEtape(etapeEnCours).addItemTaux()
                listTaux.append({"param" : 0, "condition" : 0, "value" : 0, "ratio" : 0, index:listTaux.count})
            }
        }
    }

    function updateTaux()
    {
        if(etapeEnCours !== -1 )
        {
            listTaux.clear()
            for( var i = 0; i < gestEtape.getEtape(etapeEnCours).getNbTaux(); i++)
            {
                listTaux.append({"param" : gestEtape.getEtape(etapeEnCours).getParamTaux(i), "condition" : gestEtape.getEtape(etapeEnCours).getCondTaux(i), "value" : gestEtape.getEtape(etapeEnCours).getValueTaux(i), "ratio" : gestEtape.getEtape(etapeEnCours).getRatioTaux(i), index:listTaux.count})
            }
        }
    }

    Text {
        id: textParam
        width: 254
        height: 15
        color: "#ffffff"
        text: qsTr("Paramètre")
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: buttonAjoutTaux.bottom
        anchors.topMargin: 20
        font.pixelSize: 13
    }

    Text {
        id: textCond
        width: 260
        height: 15
        color: "#ffffff"
        text: qsTr("Condition")
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.top: buttonAjoutTaux.bottom
        anchors.topMargin: 20
        anchors.left: textParam.right
        anchors.leftMargin: 0
        font.pixelSize: 13
    }

    Text {
        id: textValue
        width: 212
        height: 15
        color: "#ffffff"
        text: qsTr("Valeur")
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        anchors.top: buttonAjoutTaux.bottom
        anchors.topMargin: 20
        anchors.left: textCond.right
        anchors.leftMargin: 0
        font.pixelSize: 13
    }

    Text {
        id: textTaux
        width: 202
        height: 15
        color: "#ffffff"
        text: qsTr("Taux")
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.top: buttonAjoutTaux.bottom
        anchors.topMargin: 20
        anchors.left: textValue.right
        anchors.leftMargin: 0
        font.pixelSize: 13
    }
}

