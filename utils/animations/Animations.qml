pragma Singleton

import QtQuick
import Quickshell
import "." as Anim

Singleton {
    component Wiggle: Anim.Wiggle { }
    component Fade: Anim.Fade { }
    component SlideFromTop: Anim.SlideFromTop { }
}
