pragma Singleton

import QtQuick
import Quickshell

Singleton {
    component Wiggle: WiggleAnimation { }
    component FadeIn: FadeInAnimation { }
    component SlideFadeTop: SlideFadeTopAnimation { }
    component PopIn: PopInAnimation { }
    component PopOut: PopOutAnimation { }
}
