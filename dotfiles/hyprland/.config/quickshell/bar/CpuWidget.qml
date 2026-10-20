import qs
import qs.components
import qs.services

BarText {
  text: Icons.cpu + String(Cpu.usage).padStart(2, "0") + "%"
}
