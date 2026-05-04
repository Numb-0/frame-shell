import QtQuick
import qs.config

Canvas {
    id: pie
    required property real progress
    property color fillColor: Theme.colors.foregroundDim

    implicitWidth: 16
    implicitHeight: 16

    onPaint: {
        const ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);
        ctx.beginPath();
        ctx.moveTo(width / 2, height / 2);
        const startAngle = -Math.PI / 2;
        const endAngle = startAngle + (progress * 2 * Math.PI);
        ctx.arc(width / 2, height / 2, width / 2, startAngle, endAngle, false);
        ctx.lineTo(width / 2, height / 2);
        ctx.fillStyle = fillColor;
        ctx.fill();
    }

    onProgressChanged: requestPaint()
    onFillColorChanged: requestPaint()
}
