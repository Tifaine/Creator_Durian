import QtQuick 2.0
import QtCharts 2.3

Item {
    property int indexVG : 0
    property int indexVD : 0

    property bool indexDepaceG : false
    property bool indexDepaceD : false
    Connections
    {
        target:gestRoboclaw
        function onVitesseGaucheChanged(value)
        {


            if(indexDepaceD === false)
            {
                vG.append(indexVG, value)
                vCG.append(indexVG,gestRoboclaw.getConsigneVG())
            }else
            {
                vG.replace(indexVG, vG.at(indexVG).y, indexVG, value)
                vCG.replace(indexVG, vCG.at(indexVG).y, indexVG, gestRoboclaw.getConsigneVG())
            }

            indexVG++

            if(indexVG > scaleAxisXTop.max)
            {
                indexDepaceG = true
                indexVG%=2000
            }

            if(value > scaleAxisYTop.max)
            {
                scaleAxisYTop.max = value
            }

            if(value < scaleAxisYTop.min)
            {
                scaleAxisYTop.min = value
            }
        }
        function onVitesseDroitChanged(value)
        {

            if(indexDepaceD === false)
            {
                vD.append(indexVD, value)
                vCD.append(indexVD, gestRoboclaw.getConsigneVD())
            }else
            {
                vD.replace(indexVG, vD.at(indexVG).y, indexVG, value)
                vCD.replace(indexVG, vCD.at(indexVG).y, indexVG, gestRoboclaw.getConsigneVD())
            }

            indexVD++

            if(indexVD > scaleAxisXTop.max)
            {
                indexDepaceD = true
                indexVD%=2000
            }

            if(value > scaleAxisYTop.max)
            {
                scaleAxisYTop.max = value
            }

            if(value < scaleAxisYTop.min)
            {
                scaleAxisYTop.min = value
            }
        }
    }

    ChartView {
        id: line
        anchors.fill: parent
        //theme: ChartView.ChartThemeDark
        backgroundColor: "#00000000"
        legend.labelColor: "white"
        ValueAxis
        {
            id: scaleAxisXTop
            min:0
            max:2000
            labelsColor: "white"
        }

        ValueAxis
        {
            id: scaleAxisYTop
            min:0
            max:10
            labelsColor: "white"
        }

        LineSeries {
            id:vG
            name: "Vitesse gauche"
            color: "#ff0000"
            axisX: scaleAxisXTop
            axisY: scaleAxisYTop

        }

        LineSeries {
            id:vD
            name: "Vitesse droite"
            color: "#0000ff"
            axisX: scaleAxisXTop
            axisY: scaleAxisYTop

        }

        LineSeries {
            id:vCG
            name: "Vitesse gauche consigne"
            color: "#ffff00"
            axisX: scaleAxisXTop
            axisY: scaleAxisYTop

        }

        LineSeries {
            id:vCD
            name: "Vitesse droite consigne"
            color: "#ff00ff"
            axisX: scaleAxisXTop
            axisY: scaleAxisYTop

        }
    }


}

/*##^##
Designer {
    D{i:1;anchors_height:500;anchors_width:700;anchors_x:13;anchors_y:147}
}
##^##*/
