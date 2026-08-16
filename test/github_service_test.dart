import 'package:flutter_test/flutter_test.dart';
import 'package:developer_wiki_source_capture/models/source_template.dart';
import 'package:developer_wiki_source_capture/services/github_service.dart';
void main(){test('Issue-Body entspricht GitHub-Issue-Form-Struktur',(){final body=GitHubService.issueBody(sourceTemplates.first,{'source_title':'Test','urls':'https://example.org'});expect(body,'### Titel der Quelle\n\nTest\n\n### Link oder zusammengehörige Links\n\nhttps://example.org');});}
