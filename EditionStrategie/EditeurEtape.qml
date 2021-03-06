import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import etape 1.0
import Qt.labs.folderlistmodel 2.12

Item {
    id: element
    width: 1500
    height: 800

    property var etapeEnCours: 0
    property int indiceEtape: -1

    Connections
    {
        target: gestEtape
        function onStepUpdated()
        {
            updateEtape()
        }
    }

    ListModel
    {
        id:listComportement
        ListElement{ _nom:"Canasson" ; stepIndex : 0; _color:"#000000ff"; colorEtape: "blue"; _dateMax:50;
            _deadLine : 12; _nbPoints : 45; _sequenceName: "test"; _tempsMax : 10; _tempsMoyen : 20}
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
            listComportement.append({"_nom" : gestEtape.getEtape(i).nomEtape, "stepIndex" : listComportement.count,
                                        "_color" : "#000000ff", "colorEtape" : gestEtape.getEtape(i).color,
                                        "_dateMax" : gestEtape.getEtape(i).dateMax, "_deadLine" : gestEtape.getEtape(i).deadline,
                                        "_nbPoints" : gestEtape.getEtape(i).nbPoints, "_sequenceName": gestEtape.getEtape(i).nameSequence,
                                        "_tempsMax" : gestEtape.getEtape(i).tempsMax, "_tempsMoyen": gestEtape.getEtape(i).tempsMoyen})
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
                    width:120
                    color:_color
                    radius: 10
                    border.color: "#ffffff"
                    border.width: 1
                    anchors.left: repeaterListAction.left
                    anchors.leftMargin: (stepIndex%2)==1?(stepIndex==1?0:(Math.floor(stepIndex/2))*130)+5:((stepIndex/2)*130)+5
                    anchors.top: repeaterListAction.top
                    anchors.topMargin:(stepIndex%2)==1?50:5


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

                        Etape
                        {
                            id:papaStep
                            color:colorEtape
                            nomEtape: _nom
                            dateMax:  _dateMax
                            deadline: _deadLine
                            nbPoints: _nbPoints
                            nameSequence: _sequenceName
                            tempsMax: _tempsMax
                            tempsMoyen: _tempsMoyen
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            z:1
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked:
                            {
                                console.log(stepIndex)
                                console.log(gestEtape.getNomEtape(stepIndex))
                                rectangle5.updateColor(stepIndex)
                                etapeEnCours = 0
                                indiceEtape = -1
                                textFieldNomEtape.text = papaStep.nomEtape
                                textFieldNbPoints.text = papaStep.nbPoints
                                textFieldTpsMoyen.text = papaStep.tempsMoyen
                                textFieldTpsMax.text = papaStep.tempsMax
                                textFieldDateMax.text = papaStep.dateMax
                                textFieldDeadline.text = papaStep.deadline
                                rectangleColor.color = papaStep.color
                                controlSequence.currentIndex = 0;
                                for(var i = 0; i < folderModel.count; i++)
                                {
                                    if(folderModel.get(i, "fileName") === papaStep.nameSequence)
                                    {
                                        controlSequence.currentIndex = i;
                                        break;
                                    }
                                }
                                etapeEnCours = papaStep
                                indiceEtape = stepIndex
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
        width: 150
        text: qsTr("")
        anchors.left: textNomEtape.right
        anchors.leftMargin: 15
        anchors.top: rectangle1.bottom
        anchors.topMargin: 20
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
            if(etapeEnCours !== 0 )
            {
                gestEtape.getEtape(indiceEtape).nomEtape = text
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
        width: 150
        text: qsTr("")
        anchors.leftMargin: 15
        anchors.topMargin: 20
        anchors.top: rectangle1.bottom
        anchors.left: textNbPoint.right
        validator: IntValidator{bottom : 0; top : 999999}
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
            if(etapeEnCours !== 0 )
            {
                gestEtape.getEtape(indiceEtape).nbPoints = parseInt(text)
            }
        }
    }

    Button {
        id: buttonAddEtape
        x: 1457
        width: 150
        height: 90
        text: qsTr("Ajouter étape")
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        onClicked:
        {
            gestEtape.createNewEtape()
            listComportement.append({"_nom" : "NewEtape", "stepIndex" : listComportement.count,
                                        "_color" : "#000000ff", "colorEtape" : "#0000ff",
                                        "_dateMax" : 0, "_deadLine" :0,
                                        "_nbPoints" : 0, "_sequenceName": "",
                                        "_tempsMax" : 0, "_tempsMoyen": 0})
        }
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
        width: 150
        text: qsTr("")
        anchors.topMargin: 20
        anchors.leftMargin: 30
        anchors.top: rectangle1.bottom
        anchors.left: textTempsMoyen.right
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
            if(etapeEnCours !== 0 )
            {
                gestEtape.getEtape(indiceEtape).tempsMoyen = parseInt(text)
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
        anchors.topMargin: 45
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
        width: 150
        text: qsTr("")
        anchors.leftMargin: 45
        anchors.topMargin: 35
        anchors.top: textFieldTpsMoyen.bottom
        anchors.left: textTempsMax.right
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
            if(etapeEnCours !== 0 )
            {
                gestEtape.getEtape(indiceEtape).tempsMax = parseInt(text)
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
        anchors.topMargin: 45
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
        width: 150
        text: qsTr("")
        anchors.leftMargin: 6
        anchors.topMargin: 35
        anchors.top: textFieldTpsMax.bottom
        anchors.left: textDateMax.right
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
            if(etapeEnCours !== 0 )
            {
                gestEtape.getEtape(indiceEtape).dateMax = parseInt(text)
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
        anchors.topMargin: 45
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
        width: 150
        text: qsTr("")
        anchors.topMargin: 35
        anchors.leftMargin: 142
        anchors.top: textFieldDateMax.bottom
        anchors.left: textDeadLine.right
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
            if(etapeEnCours !== 0 )
            {
                gestEtape.getEtape(indiceEtape).deadline = parseInt(text)
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
            if(etapeEnCours !== 0 )
            {
                gestEtape.getEtape(indiceEtape).save()
                gestEtape.updateEtape()
            }
        }
    }

    Rectangle {
        id: rectangleColor
        x: 275
        width: 15
        height: 15
        color: "#ffffff"
        radius: 15
        anchors.right: buttonColor.left
        anchors.rightMargin: 50
        anchors.top: buttonSave.bottom
        anchors.topMargin: 30

    }

    Button {
        id: buttonColor
        x: 375
        text: qsTr("Editer couleur")
        font.pointSize: 10
        font.bold: true
        anchors.top: buttonSave.bottom
        anchors.topMargin: 18
        anchors.right: textDeadLine.left
        anchors.rightMargin: 270
        onClicked: colorDialog.open()
    }

    ColorDialog {
        id: colorDialog
        title: "Choisir une couleur"
        color:rectangleColor.color
        onAccepted: {
            console.log("You chose: " + colorDialog.color)
            rectangleColor.color = colorDialog.color
            if(etapeEnCours !== 0 )
            {
                gestEtape.getEtape(indiceEtape).color = colorDialog.color
            }
        }
        onRejected: {
            console.log("Canceled")

        }

    }



    FolderListModel
    {
        id: folderModel
        folder:fileRoot+applicationDirPath+"/data/Sequence/"
        nameFilters: ["*.json"]
        showDirs: false
    }

    ComboBox {
        id: controlSequence
        width: 200
        height: 40
        anchors.right: textDeadLine.left
        anchors.rightMargin: 270
        anchors.top: buttonColor.bottom
        anchors.topMargin: 70
        model: folderModel
        currentIndex: 0
        onCurrentIndexChanged:
        {
            if(etapeEnCours !== 0)
            {
                gestEtape.getEtape(indiceEtape).nameSequence = folderModel.get(currentIndex, "fileName")
            }
        }

        delegate: ItemDelegate {
            width: controlSequence.width
            contentItem: Text {
                text: fileName
                color: "white"
                font: controlSequence.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            highlighted: controlSequence.highlightedIndex === index
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color:controlSequence.highlightedIndex === index ? "#262626" : "transparent"
            }
        }

        indicator: Canvas {
            id: canvas
            x: controlSequence.width - width - controlSequence.rightPadding
            y: controlSequence.topPadding + (controlSequence.availableHeight - height) / 2
            width: 12
            height: 8
            contextType: "2d"

            Connections {
                target: controlSequence
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
                context.fillStyle = controlSequence.pressed ? "#4d0000" : "#660000";
                context.fill();
            }
        }

        contentItem: Text {
            leftPadding: 10
            rightPadding: controlSequence.indicator.width + controlSequence.spacing

            text: folderModel.count > 0 ? folderModel.get(controlSequence.currentIndex, "fileName"):""
            font: controlSequence.font
            color: "white"
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 120
            implicitHeight: 40
            color:"#262626"
            border.color: controlSequence.pressed ? "#4d0000" : "#66000"
            border.width: controlSequence.visualFocus ? 2 : 1
            radius: 2
        }

        popup: Popup {
            y: controlSequence.height - 1
            width: controlSequence.width
            implicitHeight: contentItem.implicitHeight
            padding: 1

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: controlSequence.popup.visible ? controlSequence.delegateModel : null
                currentIndex: controlSequence.highlightedIndex

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
        id: textSequence
        x: 138
        height: 15
        color: "#ffffff"
        text: qsTr("Séquence associée : ")
        anchors.right: controlSequence.left
        anchors.rightMargin: 10
        anchors.top: buttonColor.bottom
        anchors.topMargin: 80
        font.bold: true
        font.pixelSize: 12
    }


}


/*##^##
Designer {
    D{i:39;anchors_y:287}D{i:38;anchors_y:299}D{i:41;anchors_width:120}D{i:54;anchors_width:93;anchors_x:15;anchors_y:410}
}
##^##*/
