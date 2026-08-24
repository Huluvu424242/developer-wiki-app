# App-Logo und Launcher-Icons

Das offizielle Logo der Developer-Wiki-App liegt als transparentes PNG-Master
unter [`assets/branding/developer-wiki-app-logo.png`](../assets/branding/developer-wiki-app-logo.png).
Es verbindet eine Wiki-Seite, eine eingehende Quellenkarte und vernetzte
Wissensknoten. Das Motiv ist eigenständig und verwendet keine GitHub- oder
Wikipedia-Markenzeichen.

## Android-Ressourcen

Die Android-Integration besteht aus:

- klassischen Launcher-PNGs für `mdpi`, `hdpi`, `xhdpi`, `xxhdpi` und `xxxhdpi`,
- einem Adaptive Icon mit hellem Hintergrund und transparenter Vordergrundebene,
- einer Rund-Icon-Referenz,
- einem einfarbigen VectorDrawable für Android Themed Icons ab API 33.

Das adaptive Vordergrundmotiv bleibt innerhalb der zentralen 66-Prozent-Zone
der 108-dp-Arbeitsfläche. Dadurch bleiben Quellenkarte, Pfeil, Buch und
Wissensknoten bei runden, Squircle- und abgerundet-quadratischen Masken sichtbar.

## Icons neu erzeugen

Die Rasterressourcen werden mit ImageMagick aus dem Master abgeleitet:

```bash
./tool/generate_app_icons.sh
```

Das Skript akzeptiert sowohl den modernen Befehl `magick` als auch den älteren
Befehl `convert`. Es beschneidet ausschließlich anhand des Alpha-Kanals,
erzeugt die fünf klassischen Dichtevarianten und legt das adaptive Motiv auf
eine transparente 108-dp-Arbeitsfläche. XML-Ressourcen und das monochrome Motiv
werden bewusst als Textdateien gepflegt und nicht generiert.

Nach einer Änderung des Masters sind die erzeugten Dateien gemeinsam zu
committen. Die folgenden Prüfungen sind anschließend erforderlich:

1. `flutter analyze`
2. `flutter test`
3. `flutter build apk --debug`
4. Installation auf einem Android-Gerät oder Emulator
5. Sichtprüfung mit runder, Squircle- und Rounded-Square-Maske sowie auf hellem
   und dunklem Systemhintergrund

## Weitere Plattformen

Das Repository enthält derzeit keine Windows- oder Linux-Runner. Sobald diese
Plattformziele ergänzt werden, werden ICO- beziehungsweise PNG-Ressourcen aus
demselben transparenten Master erzeugt. So bleibt die visuelle Identität über
alle Plattformen konsistent.
