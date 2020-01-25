import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: element
    width: 1500
    height: 800

    ListModel
    {
        id:listComportement
        ListElement{ _nom:"Deplacement" ; index : 0; _color:"#00ffffff"}
        ListElement{ _nom:"test" ; index : 1; _color:"#00ffffff"}
        ListElement{ _nom:"aaa" ; index : 2; _color:"#00ffffff"}
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
                if(behaviorSelected !== -1)
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
                                textFieldNomEtape.text = gestTypeAction.getNomAction(index)
                                radioButtonBlocant.checked = gestTypeAction.getIsBlocant(index)
                                listParam.clear();
                                listParam1.clear();
                                listAlias.clear();
                                rectangle6.behaviorSelected=-1
                                gestAction.clearParam()
                                for(var i =0; i<gestTypeAction.getNbParam(index);i++)
                                {
                                    listParam.append({_nom:gestTypeAction.getNameParam(index,i),value:gestTypeAction.getValueParam(index,i), index:listParam.count})
                                    listParam1.append({_nom:gestTypeAction.getNameParam(index,i),_color:"#00ffffff", index:listParam1.count})

                                    gestAction.setNouveauParam(gestTypeAction.getNameParam(index,i),gestTypeAction.getValueParam(index,i))

                                    for(var j=0;j<gestTypeAction.getNbAlias(index,gestTypeAction.getNameParam(index,i));j++)
                                    {
                                        gestAction.ajoutNouveauAlias(gestTypeAction.getNameParam(index,i),gestTypeAction.getNomAlias(index,gestTypeAction.getNameParam(index,i),j),gestTypeAction.getValueAlias(index,gestTypeAction.getNameParam(index,i),j))
                                    }
                                }
                                gestAction.setNomAction(gestTypeAction.getNomAction(index))
                                gestAction.setIsActionBlocante(gestTypeAction.getIsBlocant(index))
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
    }
}

/*##^##
Designer {
    D{i:14;anchors_x:24;anchors_y:125}D{i:15;anchors_x:83;anchors_y:113}D{i:16;anchors_x:356;anchors_y:127}
D{i:17;anchors_x:83;anchors_y:113}D{i:18;anchors_y:18}D{i:19;anchors_x:747;anchors_y:122}
D{i:20;anchors_x:83;anchors_y:113}D{i:21;anchors_x:747;anchors_y:122}D{i:22;anchors_x:83;anchors_y:113}
D{i:23;anchors_x:747;anchors_y:122}D{i:24;anchors_x:83;anchors_y:113}D{i:25;anchors_x:747;anchors_y:122}
D{i:26;anchors_x:83;anchors_y:113}D{i:27;anchors_x:301;anchors_y:218}
}
##^##*/
