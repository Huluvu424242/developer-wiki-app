# Android-Teilen und Quellenziele

Die Developer-Wiki-App bietet getrennte Android-Share-Ziele, damit der fachliche Kontext des geteilten Inhalts erhalten bleibt.

| Android-Share-Ziel | Inhalt | Ziel in der App |
| --- | --- | --- |
| Developer Wiki – Link | `text/plain` aus Browser/Link-Kontext | 🌐 Quellenmetadaten |
| Developer Wiki – Text | `text/plain` aus Text-/Notiz-Kontext | 📝 Allgemeine Information |
| Developer Wiki – Bild | PNG, GIF, JPEG | 🖼️ Bild-Quelle |
| Developer Wiki – Dokument | PDF | 📄 Dokument-Quelle |

Nach der Android-Übergabe verwendet die App für alle Einstiegspunkte denselben fachlichen Formular- und Submit-Weg wie bei manueller Erfassung. Der automatisch bestimmte Quellentyp wird nicht in einen generischen Text- oder Dateiweg umgedeutet.

```text
Browser ──Teilen──> Developer Wiki – Link ───────> 🌐 Quellenmetadaten
Notiz   ──Teilen──> Developer Wiki – Text ───────> 📝 Allgemeine Information
Galerie ──Teilen──> Developer Wiki – Bild ───────> 🖼️ Bild-Quelle
PDF     ──Teilen──> Developer Wiki – Dokument ───> 📄 Dokument-Quelle
```

Ein unbekannter Dateityp erzeugt kein Quellen-Issue. Stattdessen zeigt die App den empfangenen MIME-Typ beziehungsweise eine verständliche Fehlermeldung. Fehlt im dynamischen Wiki-Vertrag die passende Quellenart oder Client-Fähigkeit, wird ebenfalls kein stiller Fallback durchgeführt.

Geteilte Bild- und Dokumentdateien werden nur in den privaten Cache der App kopiert und bei Abschluss, Ersetzen oder Verwerfen des Ablaufs wieder entfernt.
