import QtQuick 2.0
import QtQuick.Controls 2.13

Item {
    id: element
    width: 550
    height: 650
    property bool isInit: false

    Connections
    {
        target:gestRoboclaw
        function onInitDone()
        {
            textFieldQPPSMaxG.text = gestRoboclaw.getQPPSMaxG()
            textFieldQPPSMaxD.text = gestRoboclaw.getQPPSMaxD()

            tfPG.text = gestRoboclaw.getCoeffPg();
            tfIG.text = gestRoboclaw.getCoeffIg();
            tfDG.text = gestRoboclaw.getCoeffDg();

            tfPD.text = gestRoboclaw.getCoeffPd();
            tfID.text = gestRoboclaw.getCoeffId();
            tfDD.text = gestRoboclaw.getCoeffDd();

            textFieldAccG.text = gestRoboclaw.getAccG()
            textFieldAccD.text = gestRoboclaw.getAccD()

            isInit = true
        }
    }

    Text {
        id: textQPPSMaxG
        x: 452
        color: "#ffffff"
        text: qsTr("QPPS Max Gauche :")
        anchors.right: textFieldQPPSMaxG.left
        anchors.rightMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 62
        font.pixelSize: 12
    }

    TextField {
        id: textFieldQPPSMaxG
        x: 574
        width: 60
        text: qsTr("10000")
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 20
        onTextChanged:
        {
            if(isInit)
            {
                gestRoboclaw.setQPPSMaxG(text);
            }
        }
    }

    Text {
        id: textQPPSMaxD
        x: 452
        color: "#ffffff"
        text: qsTr("QPPS Max Droit :")
        anchors.right: textFieldQPPSMaxD.left
        anchors.rightMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 112
        font.pixelSize: 12
    }

    TextField {
        id: textFieldQPPSMaxD
        x: 574
        width: 60
        text: qsTr("10000")
        horizontalAlignment: Text.AlignHCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: textFieldQPPSMaxG.bottom
        anchors.topMargin: 10
        onTextChanged:
        {
            if(isInit)
            {
                gestRoboclaw.setQPPSMaxD(text);
            }
        }
    }

    Text {
        id: element2
        x: 130
        y: 78
        width: 40
        color: "#ffffff"
        text: sliderVDroit.value
        anchors.left: element1.right
        anchors.leftMargin: 50
        anchors.bottom: sliderVDroit.top
        anchors.bottomMargin: 5
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
    }

    Text {
        id: element1
        x: 40
        y: 78
        width: 40
        color: "#ffffff"
        text: sliderVGauche.value
        horizontalAlignment: Text.AlignHCenter
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.bottom: sliderVGauche.top
        anchors.bottomMargin: 5
        font.pixelSize: 12
    }

    Slider {
        id: sliderVDroit
        x: 130
        y: 100
        anchors.left: sliderVGauche.right
        anchors.leftMargin: 50
        anchors.top: parent.top
        anchors.topMargin: 300
        stepSize: 10
        to: 15000
        from: -15000
        orientation: Qt.Vertical
        value: 0
        onValueChanged:
        {
            if(checkBoxSync.checked)
            {
                sliderVGauche.value = value
            }

            if(isInit)
            {
                gestRoboclaw.setConsigneVD(value);
            }
        }
    }

    Slider {
        id: sliderVGauche
        x: 40
        y: 100
        anchors.top: parent.top
        anchors.topMargin: 300
        anchors.left: parent.left
        anchors.leftMargin: 40
        stepSize: 10
        to: 15000
        from: -15000
        orientation: Qt.Vertical
        value: 0
        onValueChanged:
        {
            if(checkBoxSync.checked)
            {
                sliderVDroit.value = value
            }
            if(isInit)
            {
                gestRoboclaw.setConsigneVG(value);
            }
        }
    }

    Button {
        id: buttonStop
        width: 140
        height: 40
        text: qsTr("Stop")
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: sliderVDroit.bottom
        anchors.topMargin: 10
        onClicked:
        {
            sliderVDroit.value = 0
            sliderVGauche.value = 0
        }
    }

    CheckBox {
        id: checkBoxSync
        anchors.top: parent.top
        anchors.topMargin: 225
        anchors.left: parent.left
        anchors.leftMargin: 40

    }

    Text {
        id: element3
        color: "#ffffff"
        text: qsTr("Synchroniser vitesses")
        anchors.left: checkBoxSync.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 237
        font.pixelSize: 12
    }

    Text {
        id: textCoeffs
        x: 508
        color: "#ffffff"
        text: qsTr("Coefficients PID")
        anchors.top: parent.top
        anchors.topMargin: 245
        anchors.right: parent.right
        anchors.rightMargin: 50
        font.pixelSize: 12
    }


    TextField {
        id: tfPG
        x: 575
        width: 50
        text: qsTr("1")
        horizontalAlignment: Text.AlignHCenter
        anchors.right: tfPD.left
        anchors.rightMargin: 20
        anchors.top: textCoeffs.bottom
        anchors.topMargin: 30
        onTextChanged:
        {
            if(isInit)
            {
                gestRoboclaw.setCoeffPg(text);
            }
        }
    }

    TextField {
        id: tfIG
        x: 575
        width: 50
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        anchors.right: tfID.left
        anchors.rightMargin: 20
        anchors.top: tfPG.bottom
        anchors.topMargin: 20
        onTextChanged:
        {
            if(isInit)
            {
                gestRoboclaw.setCoeffIg(text);
            }
        }
    }

    TextField {
        id: tfDG
        x: 575
        width: 50
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        anchors.right: tfDD.left
        anchors.rightMargin: 20
        anchors.top: tfIG.bottom
        anchors.topMargin: 20
        onTextChanged:
        {
            if(isInit)
            {
                gestRoboclaw.setCoeffDg(text);
            }
        }
    }

    Text {
        id: textCoeffP
        x: 456
        y: -4
        color: "#ffffff"
        text: qsTr("Proportionnel")
        font.pixelSize: 12
        anchors.topMargin: 304
        anchors.rightMargin: 10
        anchors.right: tfPG.left
        anchors.top: parent.top
    }

    Text {
        id: textCoeffI
        x: 487
        y: -12
        color: "#ffffff"
        text: qsTr("Intégral")
        font.pixelSize: 12
        anchors.topMargin: 41
        anchors.rightMargin: 10
        anchors.right: tfIG.left
        anchors.top: textCoeffP.bottom
    }

    Text {
        id: textCoeffD
        x: 520
        y: -10
        color: "#ffffff"
        text: qsTr("Dérivé")
        font.pixelSize: 12
        anchors.topMargin: 45
        anchors.rightMargin: 10
        anchors.right: tfDG.left
        anchors.top: textCoeffI.bottom
    }

    TextField {
        id: tfPD
        x: 640
        y: 6
        width: 50
        text: qsTr("1")
        horizontalAlignment: Text.AlignHCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.topMargin: 30
        anchors.top: textCoeffs.bottom
        onTextChanged:
        {
            if(isInit)
            {
                gestRoboclaw.setCoeffPd(text);
            }
        }
    }

    TextField {
        id: tfID
        x: 640
        y: 6
        width: 50
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.topMargin: 20
        anchors.top: tfPG.bottom
        onTextChanged:
        {
            if(isInit)
            {
                gestRoboclaw.setCoeffId(text);
            }
        }
    }

    TextField {
        id: tfDD
        x: 640
        y: 6
        width: 50
        text: qsTr("0")
        horizontalAlignment: Text.AlignHCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.topMargin: 20
        anchors.top: tfIG.bottom
        onTextChanged:
        {
            if(isInit)
            {
                gestRoboclaw.setCoeffDd(text);
            }
        }
    }

    Text {
        id: textAcc
        width: 130
        height: 17
        color: "#ffffff"
        text: qsTr("Accélération")
        horizontalAlignment: Text.AlignHCenter
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: parent.top
        anchors.topMargin: 125
        font.pixelSize: 12
    }

    TextField {
        id: textFieldAccG
        width: 60
        height: 40
        text: qsTr("10000")
        horizontalAlignment: Text.AlignHCenter
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: textAcc.bottom
        anchors.topMargin: 20
        onTextChanged:
        {
            if(isInit)
            {
                gestRoboclaw.setAccG(text);
            }
        }
    }

    TextField {
        id: textFieldAccD
        width: 60
        height: 40
        text: qsTr("10000")
        horizontalAlignment: Text.AlignHCenter
        anchors.left: textFieldAccG.right
        anchors.leftMargin: 10
        anchors.top: textAcc.bottom
        anchors.topMargin: 20
        onTextChanged:
        {
            if(isInit)
            {
                gestRoboclaw.setAccD(text);
            }
        }
    }







}

/*##^##
Designer {
    D{i:1;anchors_y:52}D{i:2;anchors_y:109}D{i:3;anchors_y:98}D{i:4;anchors_y:98}D{i:5;anchors_x:138}
D{i:6;anchors_x:48}D{i:7;anchors_x:167;anchors_y:175}D{i:8;anchors_x:40;anchors_y:106}
D{i:9;anchors_x:30;anchors_y:305}D{i:10;anchors_x:40;anchors_y:24}D{i:11;anchors_x:92;anchors_y:37}
D{i:12;anchors_y:237}D{i:13;anchors_y:294}D{i:14;anchors_y:353}D{i:15;anchors_y:418}
D{i:16;anchors_y:237}D{i:17;anchors_y:237}D{i:18;anchors_y:237}D{i:19;anchors_y:294}
D{i:20;anchors_y:353}D{i:21;anchors_y:418}D{i:22;anchors_x:30;anchors_y:43}D{i:23;anchors_x:12;anchors_y:80}
D{i:24;anchors_x:84;anchors_y:80}
}
##^##*/
