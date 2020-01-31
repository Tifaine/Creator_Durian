import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

import etape 1.0

Item {
    id: element
    width: 1500
    height: 800
    property bool comefromXTf : false
    property bool comefromYTf : false
    Connections
    {
        target: gestEtape
        onStepUpdated: updateEtape()
    }

    Image {
        id: name
        anchors.leftMargin: 50
        anchors.rightMargin: 550
        anchors.bottomMargin: 100
        anchors.topMargin: 100
        anchors.fill: parent
        source: "file:///" + applicationDirPath + "/data/table.png"
    }

    ListModel
    {
        id:listEtape
        ListElement{ _x:25 ;  _y:100; index : 0; _color : "steelblue"}
    }

    Repeater
    {
        id:repeaterListEtape
        model:listEtape
        anchors.fill: parent
        Rectangle
        {
            x: _x
            y: _y
            z: 3
            height: 15
            width: 15
            radius: 15
            color: _color
            onXChanged:
            {
                if(etapeEnCours !== -1)
                {
                    _x = x
                    gestStrat.getEtape(index).x = x
                    if(comefromXTf === false)
                    {
                        tfX.text = Math.round((x + width / 2 - name.x) * 3000 / name.width - 1500)
                    }else
                    {
                        comefromXTf = false
                    }
                }
            }
            onYChanged:
            {
                if(etapeEnCours !== -1)
                {
                    _y = y
                    gestStrat.getEtape(index).y = y
                    if(comefromYTf === false)
                    {
                        tfY.text = Math.round((y + height / 2 - name.y) * 2000 / name.height)
                    }else
                    {
                        comefromYTf = false
                    }
                }
            }

            MouseArea
            {
                anchors.fill: parent
                drag.target: parent;
                propagateComposedEvents:true
                onPressed:
                {
                    etapeEnCours = index
                    tfX.text = Math.round((gestStrat.getEtape(index).x + width / 2 - name.x) * 3000 / name.width - 1500)
                    tfY.text = Math.round((gestStrat.getEtape(index).y + height / 2 - name.y) * 2000 / name.height)

                    updateTaux()
                }
            }
        }
    }

    ListModel
    {
        id:listComportement
        ListElement{ _nom:"Deplacement" ; index : 0; _color:"#00ffffff"}
    }

    Component.onCompleted:
    {
        listEtape.clear()
        gestStrat.clearList()
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
        anchors.right: buttonSave.left
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

                        MouseArea
                        {
                            anchors.fill: parent
                            z:1
                            acceptedButtons: Qt.LeftButton | Qt.RightButton

                            onClicked:
                            {

                                rectangle5.updateColor(index)
                                if(mouse.button === Qt.RightButton)
                                {
                                    contextMenu.popup()
                                }
                            }

                            Menu
                            {
                                id: contextMenu
                                MenuItem
                                {
                                    text: "Ajouter étape"
                                    onClicked:
                                    {
                                        element.state="State1"
                                        etapeEnCours = -1
                                        etapeDeBase = index
                                        listEtape.append({"_x" : 25, "_y" : 100, index : listEtape.count, _color : gestEtape.getEtape(index).color})

                                        gestStrat.addEtape(gestEtape.getEtape(etapeDeBase))
                                        etapeEnCours = listEtape.count-1
                                        gestStrat.getEtape(etapeEnCours).x = x
                                        gestStrat.getEtape(etapeEnCours).y = y

                                        tfX.text = Math.round((x + width / 2 - name.x) * 3000 / name.width - 1500)
                                        tfY.text = Math.round((y + height / 2 - name.y) * 2000 / name.height)

                                        updateTaux()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }



    ListModel
    {
        id:listTaux
        ListElement{ param:0 ; condition : 2; value:25; ratio:100; index:0}
        ListElement{ param:1 ; condition : 0; value:7; ratio:50; index:1}
    }

    property var etapeEnCours : -1
    property var etapeDeBase : -1
    Flickable
    {
        clip:true
        id: flickableTaux
        visible: false
        anchors.top: parent.top
        anchors.topMargin: 450
        anchors.right: parent.right
        anchors.rightMargin: 5
        flickableDirection: Flickable.VerticalFlick
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: name.right
        anchors.leftMargin: 5
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
            visible: false
            Component.onCompleted: listTaux.clear()
            property var taux : etapeEnCours!==-1?gestStrat.getEtape(etapeEnCours):0

            property int behaviorSelected:-1
            Repeater
            {
                id:repeaterTaux
                visible: false
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
                        width: (flickableTaux.width-25)/4
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
                        width: (flickableTaux.width-25)/4
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
                        width: (flickableTaux.width-25)/4
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
        visible: false
        anchors.bottom: textCond.top
        anchors.bottomMargin: 40
        color:"white"
        anchors.left: name.right
        anchors.leftMargin: 25
        font.bold: true
        font.pixelSize: 13
    }

    Button {
        id: buttonAjoutTaux
        width: 208
        height: 40
        text: qsTr("Ajouter un taux")
        visible: false
        anchors.bottom: textCond.top
        anchors.bottomMargin: 20
        anchors.left: element1.right
        anchors.leftMargin: 85
        font.bold: true
        font.pointSize: 9
        onClicked:
        {
            gestStrat.getEtape(etapeEnCours).addItemTaux()
            listTaux.append({"param" : 0, "condition" : 0, "value" : 0, "ratio" : 0, index:listTaux.count})
        }
    }

    function updateTaux()
    {
        if(etapeEnCours !== -1 )
        {
            listTaux.clear()
            for( var i = 0; i < gestStrat.getEtape(etapeEnCours).getNbTaux(); i++)
            {
                listTaux.append({"param" : gestStrat.getEtape(etapeEnCours).getParamTaux(i), "condition" : gestStrat.getEtape(etapeEnCours).getCondTaux(i), "value" : gestStrat.getEtape(etapeEnCours).getValueTaux(i), "ratio" : gestStrat.getEtape(etapeEnCours).getRatioTaux(i), index:listTaux.count})
            }
        }
    }

    Text {
        id: textParam
        width: 133
        height: 15
        color: "#ffffff"
        text: qsTr("Paramètre")
        visible: false
        anchors.bottom: flickableTaux.top
        anchors.bottomMargin: 5
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.left: name.right
        anchors.leftMargin: 5
        font.pixelSize: 13
    }

    Text {
        id: textCond
        width: 137
        height: 15
        color: "#ffffff"
        text: qsTr("Condition")
        visible: false
        anchors.bottom: flickableTaux.top
        anchors.bottomMargin: 5
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.left: textParam.right
        anchors.leftMargin: 0
        font.pixelSize: 13
    }

    Text {
        id: textValue
        width: 142
        height: 15
        color: "#ffffff"
        text: qsTr("Valeur")
        visible: false
        anchors.bottom: flickableTaux.top
        anchors.bottomMargin: 5
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        anchors.left: textCond.right
        anchors.leftMargin: 0
        font.pixelSize: 13
    }

    Text {
        id: textTaux
        width: 133
        height: 15
        color: "#ffffff"
        text: qsTr("Taux")
        visible: false
        anchors.bottom: flickableTaux.top
        anchors.bottomMargin: 5
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.left: textValue.right
        anchors.leftMargin: 0
        font.pixelSize: 13
    }

    Text {
        id: textNomAction
        color: "#ffffff"
        text: qsTr("Nom Action : ")
        visible: false
        font.bold: true
        anchors.left: name.right
        anchors.leftMargin: 10
        anchors.top: flickable.bottom
        anchors.topMargin: 10
        font.pixelSize: 13
    }

    Text {
        id: textX
        color: "#ffffff"
        text: qsTr("X : ")
        visible: false
        anchors.left: name.right
        anchors.leftMargin: 10
        anchors.top: textNomAction.bottom
        anchors.topMargin: 15
        font.bold: true
        font.pixelSize: 13
    }

    Text {
        id: textY
        color: "#ffffff"
        text: qsTr("Y : ")
        visible: false
        anchors.left: name.right
        anchors.leftMargin: 10
        anchors.top: textX.bottom
        anchors.topMargin: 20
        font.bold: true
        font.pixelSize: 13
    }

    TextField {
        id: tfX
        height: 25
        text: qsTr("Text Field")
        visible: false
        anchors.left: textX.right
        anchors.leftMargin: 10
        anchors.top: textNomAction.bottom
        anchors.topMargin: 11
        onTextChanged:
        {
            if(etapeEnCours !== -1 )
            {
                comefromXTf = true
                gestStrat.getEtape(etapeEnCours).x = ((parseInt(text) + 1500) * (name.width / 3000 ) + name.x ) - (15 / 2 )
            }
        }
    }

    TextField {
        id: tfY
        height: 25
        text: qsTr("Text Field")
        visible: false
        anchors.left: textY.right
        anchors.leftMargin: 10
        anchors.top: tfX.bottom
        anchors.topMargin: 11
        onTextChanged:
        {
            if(etapeEnCours !== -1 )
            {
                comefromYTf = true
                gestStrat.getEtape(etapeEnCours).y = parseInt(text) * name.height / 2000 + name.y - (15 / 2)
            }
        }

    }

    Button {
        id: buttonSave
        x: 1538
        text: qsTr("Sauvegarder")
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        onClicked:popup.open()
    }

    Popup {
        id: popup
        x: 500
        y: 300
        width: 200
        height: 100
        modal: true
        focus: true
        contentItem:
            Rectangle {
            anchors.fill: parent
            TextField
            {
                id:tfSaveName
                text:"Strat"
                height:40
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
            }
            Button
            {
                id:validButton
                text:"Enregistrer"
                anchors.top: tfSaveName.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: parent.width/2 + 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                onClicked:
                {
                    gestStrat.saveStrategie(tfSaveName.text)
                    popup.close()
                }
            }
            Button
            {
                id:closeButton
                text:"Annuler"
                anchors.top: tfSaveName.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: parent.width/2 + 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                onClicked:
                {
                    popup.close()
                }
            }
        }
    }

    ListModel {
        id: modelLoad
        ListElement { text: "-" }
    }

    Button {
        id: buttonLoad
        x: 1538
        text: qsTr("Charger")
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: buttonSave.bottom
        anchors.topMargin: 5
        onClicked:
        {
            modelLoad.clear()
            gestStrat.updateStrat()
            for(var i = 0; i < gestStrat.getNbStrat(); i++)
            {
                modelLoad.append({"text" : gestStrat.getNameStrat(i)})
            }

            popupLoad.open()
        }
    }


    Popup {
        id: popupLoad
        x: 500
        y: 300
        width: 200
        height: 100
        modal: true
        focus: true
        contentItem:
            Rectangle {
            anchors.fill: parent

            ComboBox {
                id: controlLoad
                height:40
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                model: modelLoad
                currentIndex: 0
                onCurrentIndexChanged:
                {

                }

                delegate: ItemDelegate {
                    width: controlLoad.width
                    contentItem: Text {
                        text: modelData
                        color: "white"
                        font: controlLoad.font
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: controlLoad.highlightedIndex === index
                    background: Rectangle {
                        implicitWidth: 120
                        implicitHeight: 40
                        color:controlLoad.highlightedIndex === index ? "#262626" : "transparent"
                    }
                }

                indicator: Canvas {
                    id: canvasLoad
                    x: controlLoad.width - width - controlLoad.rightPadding
                    y: controlLoad.topPadding + (controlLoad.availableHeight - height) / 2
                    width: 12
                    height: 8
                    contextType: "2d"

                    Connections {
                        target: controlLoad
                        onPressedChanged: canvasLoad.requestPaint()
                    }

                    onPaint: {
                        context.reset();
                        context.moveTo(0, 0);
                        context.lineTo(width, 0);
                        context.lineTo(width / 2, height);
                        context.closePath();
                        context.fillStyle = controlLoad.pressed ? "#4d0000" : "#660000";
                        context.fill();
                    }
                }

                contentItem: Text {
                    leftPadding: 10
                    rightPadding: controlLoad.indicator.width + controlLoad.spacing

                    text: controlLoad.displayText
                    font: controlLoad.font
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    implicitWidth: 120
                    implicitHeight: 40
                    color:"#262626"
                    border.color: controlLoad.pressed ? "#4d0000" : "#66000"
                    border.width: controlLoad.visualFocus ? 2 : 1
                    radius: 2
                }

                popup: Popup {
                    y: controlLoad.height - 1
                    width: controlLoad.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 1

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: controlLoad.popup.visible ? controlLoad.delegateModel : null
                        currentIndex: controlLoad.highlightedIndex

                        ScrollIndicator.vertical: ScrollIndicator { }
                    }

                    background: Rectangle {
                        border.color: "#4d0000"
                        color:"#363636"
                        radius: 2
                    }
                }
            }
            Button
            {
                id:validButtonLoad
                text:"Charger"
                anchors.top: controlLoad.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: parent.width/2 + 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                onClicked:
                {
                    //gestStrat.saveStrategie(tfSaveName.text)
                    popupLoad.close()
                }
            }
            Button
            {
                id:closeButtonLoad
                text:"Annuler"
                anchors.top: controlLoad.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: parent.width/2 + 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                onClicked:
                {
                    popupLoad.close()
                }
            }
        }
    }

    states: [
        State {
            name: "State1"

            PropertyChanges {
                target: flickableTaux
                visible: true
            }

            PropertyChanges {
                target: rectangleTaux
                visible: true
            }

            PropertyChanges {
                target: repeaterTaux
                visible: true
            }

            PropertyChanges {
                target: element1
                visible: true
            }

            PropertyChanges {
                target: buttonAjoutTaux
                visible: true
            }

            PropertyChanges {
                target: textParam
                visible: true
            }

            PropertyChanges {
                target: textCond
                visible: true
            }

            PropertyChanges {
                target: textValue
                visible: true
            }

            PropertyChanges {
                target: textTaux
                visible: true
            }

            PropertyChanges {
                target: textNomAction
                visible: true
            }

            PropertyChanges {
                target: textX
                visible: true
            }

            PropertyChanges {
                target: textY
                visible: true
            }

            PropertyChanges {
                target: tfX
                visible: true
            }

            PropertyChanges {
                target: tfY
                visible: true
            }
        }
    ]
}

/*##^##
Designer {
    D{i:19;anchors_height:100;anchors_width:959}D{i:58;anchors_height:15}D{i:60;anchors_height:15}
D{i:59;anchors_height:15}D{i:61;anchors_height:15}D{i:62;anchors_x:993;anchors_y:115}
D{i:63;anchors_x:960;anchors_y:141}D{i:64;anchors_x:960;anchors_y:175}D{i:65;anchors_x:987;anchors_y:137}
D{i:66;anchors_x:991;anchors_y:173}D{i:72;anchors_y:8}D{i:73;anchors_y:60}
}
##^##*/
