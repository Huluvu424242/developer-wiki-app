import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/source_template.dart';

class GitHubService {
  GitHubService(this.token, {this.owner='Huluvu424242', this.repo='Developer-Wiki'});
  final String token, owner, repo;
  Map<String,String> get _headers => {'Accept':'application/vnd.github+json',
    'Authorization':'Bearer $token','X-GitHub-Api-Version':'2022-11-28'};

  Future<String> createIssue({required String title, required String body}) async {
    final response = await http.post(Uri.parse('https://api.github.com/repos/$owner/$repo/issues'),
      headers:{..._headers,'Content-Type':'application/json'},
      body:jsonEncode({'title':title,'body':body,'labels':['quelle']}));
    if (response.statusCode != 201) throw Exception(_message(response));
    return (jsonDecode(response.body) as Map<String,dynamic>)['html_url'] as String;
  }

  Future<String> login() async {
    final response=await http.get(Uri.parse('https://api.github.com/user'),headers:_headers);
    if(response.statusCode!=200) throw Exception(_message(response));
    return (jsonDecode(response.body) as Map<String,dynamic>)['login'] as String;
  }

  static String issueBody(SourceTemplate template, Map<String,String> values) =>
    template.fields.where((f)=>(values[f.id]??'').trim().isNotEmpty)
      .map((f)=>'### ${f.label}\n\n${values[f.id]!.trim()}').join('\n\n');

  static String _message(http.Response r) {
    try { return (jsonDecode(r.body) as Map<String,dynamic>)['message']?.toString() ?? 'HTTP ${r.statusCode}'; }
    catch (_) { return 'HTTP ${r.statusCode}'; }
  }
}
