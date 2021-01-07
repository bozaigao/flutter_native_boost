
class _ContainerEntry {
  final bool onlyFlutter;

  const _ContainerEntry({required this.onlyFlutter});
}
// ignore: public_member_api_docs
const entry = _ContainerEntry(onlyFlutter: false);
// ignore: public_member_api_docs
const flutterEntry = _ContainerEntry(onlyFlutter: true);
