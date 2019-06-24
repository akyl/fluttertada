
class WebSocketState {
  final int state;

  WebSocketState({this.state});

  factory WebSocketState.fromJson(Map<String, dynamic> json) {
    return WebSocketState(state: json['state'] as int);
  }

  Map<String, dynamic> toJson()=> {
    'state': state,
  };
}