import 'package:auto_gen_assets/auto_gen_assets.dart';

void main() {
  final success = AssetGenerator().generate();
  if (success) {
    print('✅ Assets generated.');
  } else {
    print('❌ Failed to generate assets.');
  }
}
