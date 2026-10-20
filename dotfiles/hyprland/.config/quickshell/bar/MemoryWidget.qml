import qs
import qs.components
import qs.services

BarText {
  text: Icons.memory + String(Memory.usage).padStart(2, "0") + "%"
}
