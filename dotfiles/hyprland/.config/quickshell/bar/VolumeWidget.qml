import qs
import qs.components
import qs.services

BarText {
  text: Icons.volume + String(Audio.volume).padStart(2, "0") + "%"
}
