import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import action 1.0

Item {
    id: element
    width: 1500
    height: 800

    property var actionEnCours : 0
    property int indiceParamEnCours: -1

    Component.onCompleted:
    {
        listAction.clear()
        listAlias.clear()
        listParam.clear()

        gestAction.updateAction()
    }

    Connections
    {
        target:gestAction
        function onNouvelleAction(name, isBlocante)
        {
            listAction.append({_nom:name, index:listAction.count, _color:"#00ffffff", isBlocante:isBlocante})
        }
        function onAddParam(name, defaultValue)
        {

            if(name === "Timeout")
            {
                var alreadyThere = false
                for( var i = 0; i < actionEnCours.getNbParam(); i++)
                {
                    if(actionEnCours.getNomParam(i) === "Timeout")
                    {
                        alreadyThere = true
                    }
                }

                if(!alreadyThere)
                {
                    actionEnCours.addParam();
                    actionEnCours.setNomParam(actionEnCours.getNbParam()-1, name);
                    actionEnCours.setValueDefaultParam(actionEnCours.getNbParam()-1, defaultValue);
                    updateParam(actionEnCours)
                }
            }else
            {
                actionEnCours.addParam();
                actionEnCours.setNomParam(actionEnCours.getNbParam()-1, name);
                actionEnCours.setValueDefaultParam(actionEnCours.getNbParam()-1, defaultValue);
                updateParam(actionEnCours)
            }
        }
        function onAddAlias(indiceParam, indiceAlias, name, value)
        {
            actionEnCours.addAlias(indiceParam)
            actionEnCours.setNomAlias(indiceParam, indiceAlias, name)
            actionEnCours.setValueAlias(indiceParam, indiceAlias, value)
            indiceParamEnCours = indiceParam
            updateAlias()
        }
    }

    ListModel
    {
        id:listAction
        ListElement{ _nom:"Deplacement" ; index : 0; _color:"#00ffffff"; isBlocante: 0}
    }

    Flickable
    {
        clip:true
        id: flickable
        height: 100
        flickableDirection: Flickable.HorizontalFlick
        anchors.right: buttonAddAction.left
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

                listAction.setProperty(indice,"_color","#300000");
                if(behaviorSelected !== -1 && indice !== behaviorSelected)
                {
                    listAction.setProperty(behaviorSelected,"_color","#00ffffff");
                }

                behaviorSelected = indice
            }

            property int behaviorSelected:-1
            Repeater
            {
                id:repeaterListAction
                model:listAction
                anchors.fill: parent
                Rectangle
                {
                    id:rect
                    height:40
                    width:110
                    color:_color
                    radius: 10
                    border.color: "#ffffff"
                    border.width: 1
                    anchors.left: repeaterListAction.left
                    anchors.leftMargin: (index%2)==1?(index==1?0:(Math.floor(index/2))*115)+5:((index/2)*115)+5
                    anchors.top: repeaterListAction.top
                    anchors.topMargin:(index%2)==1?50:5

                    Action
                    {
                        id:action
                        nomAction: _nom
                        isActionBlocante: isBlocante
                        Component.onCompleted:
                        {
                            gestAction.addAction(action)
                            actionEnCours = action
                        }
                    }

                    Rectangle
                    {
                        color: _color//"#0cfdfdfd"
                        radius: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 1
                        anchors.left: parent.left
                        anchors.leftMargin: 1
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
                                element.state = "State1"
                                listAlias.clear()
                                rectangleParamAlias.behaviorSelected = -1
                                actionEnCours = 0
                                indiceParamEnCours = -1
                                actionEnCours = action
                                updateParam(action)
                                tfNomAction.text = action.nomAction
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: rectangleHaut
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
        id: textNomAction
        color: "#ffffff"
        text: qsTr("Nom de l'action : ")
        visible: false
        font.bold: true
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: rectangleHaut.bottom
        anchors.topMargin: 15
        font.pixelSize: 13
    }

    TextField {
        id: tfNomAction
        width: 170
        height: 33
        text: qsTr("NomAction")
        visible: false
        anchors.left: textNomAction.right
        anchors.leftMargin: 10
        anchors.top: rectangleHaut.bottom
        anchors.topMargin: 7
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
            if(actionEnCours !== 0)
            {
                actionEnCours.nomAction = text
            }
        }
    }

    Rectangle {
        id: rectangleMilieu
        color: "#ffffff"
        visible: false
        anchors.rightMargin: parent.width/2
        anchors.leftMargin: parent.width/2-1
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.top: rectangleHaut.bottom
        anchors.topMargin: 5
    }

    CheckBox {
        id: cbBlocante
        width: 136
        height: 40
        text: qsTr("Action blocante ?")
        visible: false
        contentItem: Text
        {
            width: 130
            anchors.fill:parent
            text:cbBlocante.text
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.bold:true
            color:"white"
        }

        anchors.left: tfNomAction.right
        anchors.leftMargin: 60
        anchors.top: rectangleHaut.bottom
        anchors.topMargin: 10
        checked: actionEnCours !== 0?actionEnCours.isActionBlocante:false
        onCheckedChanged:
        {
            if(actionEnCours !== 0)
            {
                var isAlreadyThere = false
                for( var i = 0; i < actionEnCours.getNbParam(); i++)
                {
                    if(actionEnCours.getNomParam(i) === "Timeout")
                    {
                        isAlreadyThere = true
                    }
                }

                actionEnCours.isActionBlocante = checked


                    if(checked && !isAlreadyThere)
                    {
                        actionEnCours.addParam();
                        actionEnCours.setNomParam(actionEnCours.getNbParam()-1, "Timeout");
                        actionEnCours.setValueDefaultParam(actionEnCours.getNbParam()-1, "5000");
                        listParam.append({_nom:"Timeout", _valueDefaut:"5000", index:listParam.count, _color:"#00ffffff"})
                    }else if( !checked)
                    {
                        for( var i = 0; i < actionEnCours.getNbParam(); i++)
                        {
                            console.log(actionEnCours.getNomParam(i))
                            if(actionEnCours.getNomParam(i) === "Timeout")
                            {
                                actionEnCours.eraseParam(i)
                            }
                        }
                        updateParam(actionEnCours)
                    }

            }
        }
    }

    Button {
        id: buttonAddParam
        x: 637
        width: 140

        text: qsTr("Ajouter paramètre")
        visible: false
        anchors.right: rectangleMilieu.left
        anchors.rightMargin: 15
        anchors.top: rectangleHaut.bottom
        anchors.topMargin: 15
        onClicked:
        {
            if(actionEnCours!==0)
            {
                actionEnCours.addParam();
                actionEnCours.setNomParam(actionEnCours.getNbParam()-1, "Param");
                actionEnCours.setValueDefaultParam(actionEnCours.getNbParam()-1, "default");
            }
            listParam.append({_nom:"Param", _valueDefaut:"default", index:listParam.count, _color:"#00ffffff"})
        }
    }

    function updateParam(action)
    {
        listParam.clear()
        for (var i = 0; i < action.getNbParam(); i++)
        {
            listParam.append({_nom:action.getNomParam(i), _valueDefaut:action.getValueDefaultParam(i), index:listParam.count, _color:"#00ffffff"})
        }
    }

    ListModel
    {
        id:listParam
        ListElement{ _nom:"Deplacement" ; _valueDefaut : "0"; index: 0; _color:"#00ffffff"}
    }

    Flickable
    {
        clip:true
        id: flickableParam
        visible: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        flickableDirection: Flickable.VerticalFlick
        anchors.right: rectangleMilieu.left
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: textNomParamGene.bottom
        anchors.topMargin: 10
        contentWidth: width; contentHeight: 3000
        contentX: 0
        contentY:0

        ScrollBar.vertical: ScrollBar {
            parent: flickableParam.parent
            anchors.right: flickableParam.right
            anchors.top: flickableParam.top
            anchors.bottom: flickableParam.bottom
        }
        Rectangle
        {
            id:rectangleRepeater
            anchors.fill: parent
            color:"transparent"
            visible: false

            Repeater
            {
                id:repeaterParam
                visible: false
                model:listParam
                anchors.fill: parent
                Rectangle
                {
                    color:"transparent"
                    height: 33
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: ((index*1.1 * height) + 5)
                    TextField {
                        id: tfNomParam
                        width: 170
                        height: 33
                        text: _nom
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width/2 + 2
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.top: parent.top
                        anchors.topMargin: 0
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
                            if(actionEnCours !== 0)
                            {
                                actionEnCours.setNomParam(index, text)
                            }
                        }
                    }
                    TextField {
                        id: tfValDefParam
                        height: 33
                        text: _valueDefaut
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width/2 + 2
                        anchors.top: parent.top
                        anchors.topMargin: 0
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
                            if(actionEnCours !== 0)
                            {
                                actionEnCours.setValueDefaultParam(index, text)
                            }
                        }
                    }
                }
            }
        }
    }

    Text {
        id: textNomParamGene
        text: qsTr("Nom paramètre")
        visible: false
        color:"white"
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.right: textValeurDefautGene.left
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: buttonAddParam.bottom
        anchors.topMargin: 15
        font.pixelSize: 12
    }

    Text {
        id: textValeurDefautGene
        color:"white"
        text: qsTr("Valeur par défaut")
        visible: false
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        anchors.leftMargin: parent.width/4
        anchors.left: parent.left
        anchors.right: rectangleMilieu.left
        anchors.rightMargin: 5
        anchors.top: buttonAddParam.bottom
        anchors.topMargin: 15
        font.pixelSize: 12
    }

    Button {
        id: buttonSaveAction
        y: 126
        width: 150
        text: qsTr("Sauvegarder action")
        visible: false
        anchors.left: rectangleMilieu.right
        anchors.leftMargin: 210
        onClicked:
        {
            if(actionEnCours !== 0)
            {
                actionEnCours : 0
                indiceParamEnCours: -1
                actionEnCours.save()
                listAction.clear()
                listAlias.clear()
                listParam.clear()
                gestAction.updateAction()
                element.state = "état de base"
            }
        }
    }

    Button {
        id: buttonAjoutAlias
        x: 1152
        y: 126
        width: 150
        text: qsTr("Ajouter alias")
        visible: false
        anchors.right: buttonclearAlias.left
        anchors.rightMargin: 35
        onClicked:
        {
            if(indiceParamEnCours!==-1 && actionEnCours !== 0)
            {
                actionEnCours.addAlias(indiceParamEnCours)
                updateAlias()
            }
        }
    }

    Button {
        id: buttonclearAlias
        x: 1243
        width: 150
        text: qsTr("Clear alias")
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.top: rectangleHaut.bottom
        anchors.topMargin: 25
        onClicked:
        {
            if(actionEnCours !== 0)
            {
                actionEnCours.clearAlias(indiceParamEnCours)
                updateAlias()
            }
        }
    }

    Text {
        id: textListElem
        color: "#ffffff"
        text: qsTr("Liste paramètres")
        visible: false
        font.bold: true
        anchors.left: rectangleMilieu.right
        anchors.leftMargin: 5
        anchors.top: buttonclearAlias.bottom
        anchors.topMargin: 5
        font.pixelSize: 12
    }


    Flickable
    {
        clip:true
        id: flickableParamAlias
        height: 55
        visible: false
        flickableDirection: Flickable.HorizontalFlick
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: rectangleMilieu.right
        anchors.leftMargin: 5
        anchors.top: textListElem.bottom
        anchors.topMargin: 5
        contentWidth: 5000; contentHeight: 100
        contentX: 0
        contentY:0

        ScrollBar.horizontal: ScrollBar {
            parent: flickableParamAlias.parent
            anchors.left: flickableParamAlias.left
            anchors.right: flickableParamAlias.right
            anchors.bottom: flickableParamAlias.bottom
        }
        Rectangle
        {
            id:rectangleParamAlias
            anchors.fill: parent
            color:"transparent"
            visible: false

            function updateColor(indice)
            {
                listParam.setProperty(indice,"_color","#300000");

                if(behaviorSelected !== -1 && indice !== behaviorSelected)
                {
                    listParam.setProperty(behaviorSelected,"_color","#00ffffff");
                }

                behaviorSelected = indice
            }

            property int behaviorSelected:-1
            Repeater
            {
                id:repeaterParamAlias
                visible: false
                model:listParam
                anchors.fill: parent
                Rectangle
                {
                    id:rectParamAlias
                    height:40
                    width:90
                    color:_color
                    radius: 10
                    border.color: "#ffffff"
                    border.width: 1
                    anchors.left: repeaterParamAlias.left
                    anchors.leftMargin: index*100
                    anchors.top: repeaterParamAlias.top
                    anchors.topMargin: 5


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
                            id: nomParamAlias
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
                                rectangleParamAlias.updateColor(index)
                                indiceParamEnCours = index
                                updateAlias()
                            }
                        }
                    }
                }
            }
        }
    }


    Rectangle {
        id: rectangleDroite
        height: 1
        color: "#ffffff"
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: rectangleMilieu.right
        anchors.leftMargin: 5
        anchors.top: flickableParamAlias.bottom
        anchors.topMargin: 0
    }

    Text {
        id: textAlias
        color: "#ffffff"
        text: qsTr("Alias")
        visible: false
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.right: textValue.left
        anchors.rightMargin: 0
        anchors.left: rectangleMilieu.right
        anchors.leftMargin: 0
        anchors.top: rectangleDroite.bottom
        anchors.topMargin: 10
        font.pixelSize: 12
    }

    Text {
        id: textValue
        color: "#ffffff"
        text: qsTr("Value")
        visible: false
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.leftMargin: element.width/4
        anchors.topMargin: 10
        anchors.left: rectangleMilieu.right
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: rectangleDroite.bottom
        font.pixelSize: 12
    }

    ListModel
    {
        id:listAlias
        ListElement{ _nom:"Deplacement" ; _value : "0"; index: 0}
    }

    function updateAlias()
    {
        listAlias.clear()
        for(var i = 0; i < actionEnCours.getnbAlias(indiceParamEnCours); i++)
        {
            listAlias.append({_nom:actionEnCours.getNomAlias(indiceParamEnCours, i), index:listAlias.count, _value:actionEnCours.getValueAlias(indiceParamEnCours, i)})
        }
    }

    Flickable
    {
        clip:true
        id: flickableAlias
        visible: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        flickableDirection: Flickable.VerticalFlick
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: rectangleMilieu.right
        anchors.leftMargin: 10
        anchors.top: textAlias.bottom
        anchors.topMargin: 10
        contentWidth: width; contentHeight: 3000
        contentX: 0
        contentY:0

        ScrollBar.vertical: ScrollBar {
            parent: flickableAlias.parent
            anchors.right: flickableAlias.right
            anchors.top: flickableAlias.top
            anchors.bottom: flickableAlias.bottom
        }
        Rectangle
        {
            id:rectangleRepeaterAlias
            anchors.fill: parent
            color:"transparent"
            visible: false

            Repeater
            {
                id:repeaterAlias
                visible: false
                model:listAlias
                anchors.fill: parent
                Rectangle
                {
                    color:"transparent"
                    height: 33
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: ((index*1.1 * height) + 5)
                    TextField {
                        id: tfNomAlias
                        width: 170
                        height: 33
                        text: _nom
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width/2 + 2
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.top: parent.top
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
                            if(actionEnCours !== 0)
                            {
                                actionEnCours.setNomAlias(indiceParamEnCours, index, text)
                            }
                        }
                    }
                    TextField {
                        id: tfValAlias
                        height: 33
                        text: _value
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width/2 + 2
                        anchors.top: parent.top
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
                            if(actionEnCours !== 0)
                            {
                                actionEnCours.setValueAlias(indiceParamEnCours, index, text)
                            }
                        }
                    }
                }
            }
        }
    }

    Button {
        id: buttonAddAction
        x: 1514
        width: 70
        text: qsTr("Ajouter action")
        contentItem: Text {
            text: buttonAddAction.text
            font: buttonAddAction.font
            wrapMode: Text.Wrap
            opacity: enabled ? 1.0 : 0.3
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        anchors.bottom: rectangleHaut.top
        anchors.bottomMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 15
        onClicked:
        {
            //ListElement{ _nom:"Deplacement" ; index : 0; _color:"#00ffffff"}
            listAction.append({_nom:"Action", index:listAction.count, _color:"#00ffffff"})
        }
    }
    states: [
        State {
            name: "State1"

            PropertyChanges {
                target: textNomAction
                visible: true
            }

            PropertyChanges {
                target: tfNomAction
                visible: true
            }

            PropertyChanges {
                target: rectangleMilieu
                visible: true
            }

            PropertyChanges {
                target: cbBlocante
                visible: true
            }

            PropertyChanges {
                target: buttonAddParam
                visible: true
            }

            PropertyChanges {
                target: flickableParam
                visible: true
            }

            PropertyChanges {
                target: rectangleRepeater
                visible: true
            }

            PropertyChanges {
                target: repeaterParam
                visible: true
            }

            PropertyChanges {
                target: textNomParamGene
                visible: true
            }

            PropertyChanges {
                target: textValeurDefautGene
                visible: true
            }

            PropertyChanges {
                target: buttonSaveAction
                visible: true
            }

            PropertyChanges {
                target: buttonAjoutAlias
                visible: true
            }

            PropertyChanges {
                target: buttonclearAlias
                visible: true
            }

            PropertyChanges {
                target: textListElem
                visible: true
            }

            PropertyChanges {
                target: flickableParamAlias
                visible: true
            }

            PropertyChanges {
                target: rectangleParamAlias
                visible: true
            }

            PropertyChanges {
                target: repeaterParamAlias
                visible: true
            }

            PropertyChanges {
                target: rectangleDroite
                visible: true
            }

            PropertyChanges {
                target: textAlias
                visible: true
            }

            PropertyChanges {
                target: textValue
                visible: true
            }

            PropertyChanges {
                target: flickableAlias
                visible: true
            }

            PropertyChanges {
                target: rectangleRepeaterAlias
                visible: true
            }

            PropertyChanges {
                target: repeaterAlias
                visible: true
            }
        }
    ]
}

/*##^##
Designer {
    D{i:14;anchors_x:30;anchors_y:115}D{i:15;anchors_x:140;anchors_y:116}D{i:17;anchors_height:200;anchors_width:200;anchors_x:508;anchors_y:300}
D{i:19;anchors_y:108}D{i:18;anchors_x:329;anchors_y:108}D{i:20;anchors_y:108}D{i:21;anchors_height:100}
D{i:31;anchors_x:507;anchors_y:164}D{i:27;anchors_x:507;anchors_y:164}D{i:26;anchors_x:65;anchors_y:164}
D{i:34;anchors_x:967}D{i:35;anchors_width:150;anchors_x:1152}D{i:36;anchors_y:116}
D{i:37;anchors_x:756;anchors_y:172}D{i:46;anchors_width:200;anchors_x:1090;anchors_y:529}
D{i:47;anchors_x:761;anchors_y:253}D{i:48;anchors_x:1462;anchors_y:269}D{i:60;anchors_y:8}
}
##^##*/
