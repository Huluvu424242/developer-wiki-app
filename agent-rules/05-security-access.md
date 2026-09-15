# Sicherheit: Zugriffsgrenzen

- Repository-Zugänge sind strikt an Repository, Umgebung und Zweck gebunden.
- Für einen PAT-basierten Zugriff auf `Huluvu424242/developer-wiki-app` darf ausschließlich ein eigens für dieses Repository und den konkreten Zweck bereitgestellter PAT verwendet werden.
- Ein Zugang für das persönliche Developer-Wiki oder andere Repositories darf nicht für das App-Repository verwendet werden und umgekehrt.
- Der in der App konfigurierte Wiki-PAT darf insbesondere nicht für Bugreports oder andere Zugriffe auf das App-Repository zweckentfremdet werden.
- Für unterschiedliche Repositories, Umgebungen und Zwecke werden getrennte Zugangsdaten verwendet.
- Verbundene GitHub-Connectoren und GitHub Apps verwenden eigene Installationsberechtigungen und gelten nicht als wiederverwendeter PAT. Auch für sie gilt Least Privilege.
- Das Vorhandensein eines Connectors rechtfertigt weder das Auslesen noch das Kopieren oder Ersetzen vorhandener PATs.
- Repository-Zugriff, Berechtigungen und Gültigkeitsdauer werden auf das technisch notwendige Minimum begrenzt.
- Fine-grained PATs sind gegenüber breit berechtigten Tokens zu bevorzugen; Schreibrechte werden nur vergeben, wenn Leserechte nicht ausreichen.
- Nicht mehr benötigte Zugangsdaten und Berechtigungen werden zeitnah widerrufen.
- Zugangsdaten für Entwicklung, Tests, CI und Produktion werden nicht miteinander geteilt.
