enum FieldKind { input, textarea, dropdown }

class SourceField {
  const SourceField({required this.id, required this.label, required this.kind,
    this.description = '', this.placeholder = '', this.required = false,
    this.options = const [], this.initialValue = ''});
  final String id, label, description, placeholder, initialValue;
  final FieldKind kind;
  final bool required;
  final List<String> options;
}

class SourceTemplate {
  const SourceTemplate({required this.name, required this.titlePrefix,
    required this.description, required this.fields});
  final String name, titlePrefix, description;
  final List<SourceField> fields;
}

const agentInstruction =
    'Halte dich bei der Bearbeitung an alle für die betroffenen Dateien geltenden Anweisungen aus der AGENTS.md.';

const sourceTemplates = <SourceTemplate>[
  SourceTemplate(name: '🌐 Quellenmetadaten erfassen', titlePrefix: '[Quelle]: ',
    description: 'Eine externe, über Links erreichbare Quelle erfassen.', fields: [
      SourceField(id:'source_title', label:'Titel der Quelle', kind:FieldKind.input, required:true, placeholder:'Open Knowledge Format Specification'),
      SourceField(id:'urls', label:'Link oder zusammengehörige Links', kind:FieldKind.textarea, required:true, placeholder:'Pro Zeile eine vollständige URL'),
      SourceField(id:'summary', label:'Kurzbeschreibung', kind:FieldKind.textarea, required:true),
      SourceField(id:'source_type', label:'Art der Quelle', kind:FieldKind.dropdown, required:true, options:['Webseite','Dokumentation','Spezifikation oder Standard','Repository','Artikel oder Blogbeitrag','Video oder Podcast','Wissenschaftliche Veröffentlichung','Bild oder Screenshot','Sonstige Linkquelle']),
      SourceField(id:'language', label:'Sprache', kind:FieldKind.dropdown, required:true, options:['Deutsch','Englisch','Mehrsprachig','Andere oder unbekannt']),
      SourceField(id:'publisher', label:'Herausgeber oder Plattform', kind:FieldKind.input, placeholder:'GitHub'),
      SourceField(id:'agent_notes', label:'Hinweise an den KI-Agenten', kind:FieldKind.textarea),
      SourceField(id:'prompt_additions', label:'Promptergänzungen', kind:FieldKind.textarea, initialValue:agentInstruction),
      SourceField(id:'authors', label:'Autorinnen, Autoren oder verantwortliche Organisation', kind:FieldKind.input),
      SourceField(id:'published', label:'Veröffentlichungs- oder Aktualisierungsdatum', kind:FieldKind.input, placeholder:'YYYY-MM-DD'),
      SourceField(id:'retrieved', label:'Abrufdatum', kind:FieldKind.input, placeholder:'YYYY-MM-DD'),
      SourceField(id:'relevance', label:'Relevanz für das Developer Wiki', kind:FieldKind.textarea),
      SourceField(id:'image_content', label:'Textinhalt oder Kernaussagen von Bildern', kind:FieldKind.textarea),
      SourceField(id:'notes', label:'Hinweise zu Zugriff und Auswertung', kind:FieldKind.textarea),
    ]),
  SourceTemplate(name:'📝 Allgemeine Information fürs Wiki', titlePrefix:'[Information]: ',
    description:'Eigene Notizen, Erfahrungswissen oder allgemeine Informationen.', fields:[
      SourceField(id:'description',label:'Beschreibung',kind:FieldKind.textarea,required:true),
      SourceField(id:'agent_notes',label:'Hinweise an den KI-Agenten',kind:FieldKind.textarea),
      SourceField(id:'prompt_additions',label:'Promptergänzungen',kind:FieldKind.textarea,initialValue:agentInstruction),
      SourceField(id:'topic',label:'Thema oder Stichwörter',kind:FieldKind.input),
      SourceField(id:'relevance',label:'Zweck und Relevanz',kind:FieldKind.textarea),
      SourceField(id:'sources',label:'Quellen und weiterführende Links',kind:FieldKind.textarea),
      SourceField(id:'target',label:'Bezug zu bestehenden Wiki-Inhalten',kind:FieldKind.textarea),
      SourceField(id:'certainty',label:'Einschätzung der Information',kind:FieldKind.dropdown,options:['Eigene Beobachtung oder Erfahrung','Aus einer angegebenen Quelle übernommen','Noch zu prüfen','Unklar']),
      SourceField(id:'notes',label:'Weitere Hinweise',kind:FieldKind.textarea),
    ]),
  SourceTemplate(name:'🌍 Öffentliche Person fürs Wiki', titlePrefix:'[Öffentliche Person]: ',
    description:'Öffentliche Person; Internetrecherche ist erlaubt.', fields:[
      SourceField(id:'person_name',label:'Name der Person',kind:FieldKind.input,required:true),
      SourceField(id:'person_group',label:'Personenkreis',kind:FieldKind.input),
      SourceField(id:'person_notes',label:'Notizen und Stichpunkte zur Person',kind:FieldKind.textarea,required:true),
      SourceField(id:'agent_notes',label:'Hinweise an den KI-Agenten',kind:FieldKind.textarea),
      SourceField(id:'prompt_additions',label:'Promptergänzungen',kind:FieldKind.textarea,initialValue:'Behandle die beschriebene Person als öffentliche Person. Du darfst fehlende oder aktuelle Informationen im Internet recherchieren. Bevorzuge offizielle Primärquellen, belege ergänzte Aussagen nachvollziehbar und kennzeichne Unsicherheiten oder Namensgleichheiten. Falls im Wiki eine private Quelle zur selben Person existiert, verknüpfe beide Datensätze gegenseitig, halte private und öffentlich belegte Informationen jedoch in getrennten Wiki-Datensätzen und übernimm keine Aussagen zwischen ihnen.'),
    ]),
  SourceTemplate(name:'🔒 Privatperson fürs Wiki', titlePrefix:'[Privatperson]: ',
    description:'Private Angaben ohne Internetrecherche erfassen.', fields:[
      SourceField(id:'person_name',label:'Name der Person',kind:FieldKind.input,required:true),
      SourceField(id:'person_group',label:'Personenkreis',kind:FieldKind.input),
      SourceField(id:'person_notes',label:'Notizen und Stichpunkte zur Person',kind:FieldKind.textarea,required:true),
      SourceField(id:'agent_notes',label:'Hinweise an den KI-Agenten',kind:FieldKind.textarea),
      SourceField(id:'prompt_additions',label:'Promptergänzungen',kind:FieldKind.textarea,initialValue:'Behandle die beschriebene Person als Privatperson. Recherchiere weder zu ihr noch zu den gemachten Angaben im Internet und rufe keine externen Quellen zur Ergänzung oder Bestätigung ab. Verwende ausschließlich den fachlichen Inhalt dieser privaten Quelle. Falls im Wiki eine öffentliche Quelle zur selben Person existiert, verknüpfe beide Datensätze gegenseitig, halte private und öffentlich belegte Informationen jedoch in getrennten Wiki-Datensätzen und übernimm keine Aussagen zwischen ihnen.'),
    ]),
];
