# Sicherheit: Datenbehandlung

- PATs, Passwörter, private Schlüssel, Keystore-Passwörter, Signierschlüssel, Webhook-Secrets und andere Zugangsdaten dürfen weder direkt noch codiert, verschleiert oder in Base64 im Repository abgelegt werden.
- Das Verbot gilt insbesondere für Quellcode, Konfiguration, Umgebungsdateien, Beispiele, Tests, Fixtures, Snapshots, Dokumentation, Issues, Pull Requests, Review-Kommentare, Commit-Nachrichten, URLs, Screenshots, Logs, Fehlermeldungen, Telemetrie und Build-Artefakte.
- Test- und Beispielwerte müssen eindeutig ungültig sein und dürfen keinem echten Secret entsprechen.
- Dateien wie `.env`, Keystores, Schlüsseldateien und lokal erzeugte Secret-Exporte werden durch geeignete Ignore-Regeln und Prozesse vor versehentlichem Einchecken geschützt.
- Zulässige Bereitstellung erfolgt ausschließlich über geeignete Secret Stores, GitHub Actions Secrets, nur zur Laufzeit gesetzte Umgebungsvariablen oder den geschützten Plattform-Speicher der App.
- Zugangsdaten werden nicht über ungeschützte lokale Dateien, öffentlich einsehbare CI-Variablen oder Kommandozeilenargumente mit sichtbarer Prozessliste transportiert.
- Anwendungen und Automationen halten Secrets nur so lange im Speicher, wie dies für den konkreten Vorgang erforderlich ist.
- Zugangsdaten aus Nutzereingaben, Dateien, Logs, verbundenen Diensten oder fremden Kontexten werden nicht für einen anderen als den ausdrücklich vorgesehenen Zweck verwendet.
- Secrets werden nicht an andere Repositories, Hosts oder Drittdienste übertragen und nur an den vorgesehenen Zielhost über eine verschlüsselte Verbindung gesendet.
- Externe Eingaben, Ziel-URLs und Antworten werden vor Nutzung validiert; unerwartete Weiterleitungen erhalten keine Zugangsdaten.
- Authorization-Header, Tokens, Cookies, signierte URLs, sensible Query-Parameter und andere Zugangsdaten werden nicht protokolliert und vor Logging, Anzeige, Serialisierung und Fehlerweitergabe entfernt oder redigiert.
