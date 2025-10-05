import QtQuick

Text {
  id: root
  required property string icon
  property real fill: 0
  property int grad: 0
  property int size: 25

  font.family: "Material Symbols Rounded"
  font.hintingPreference: Font.PreferFullHinting
  font.pixelSize: size
  font.variableAxes: {
    "FILL": fill,
    "GRAD": grad,
    "opsz": fontInfo.pixelSize,
    "wght": fontInfo.weight
  }

  renderType: Text.NativeRendering
  text: icon
  ColorBehavior on color {}
  Component.onCompleted: {
    // console.log("MaterialSymbol:", icon, "size:", size, "fill:", fill, "grad:", grad, width, height)
  }
}