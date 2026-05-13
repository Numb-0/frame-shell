//@ pragma UseQApplication
//@ pragma DropExpensiveFonts

import Quickshell
import qs.widgets
import qs.config

ShellRoot {
  Bar { id: bar }
  NetworkDashboard { id: networkDashboard }
  Applauncher { id: applauncher }
  VolumeOSD { id: volumeOSD }
  PowerActions { id: powerActions }
  Notifications { id: notifications }
  Dashboard { id: dashboard }
  Mixer { id: mixer }
}
