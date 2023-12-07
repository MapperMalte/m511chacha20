import 'package:m511chacha20/chacha20.dart';
import 'package:m511chacha20/chacha20_file.dart';
import 'package:m511chacha20/chacha20_key.dart';
import 'package:m511chacha20/cipher_result.dart';
import 'package:m511chacha20/file_encryption_promise.dart';
import 'package:m511chacha20/file_list_encryption_promise.dart';
import 'package:m511chacha20/key_pair.dart';
import 'package:m511chacha20/nonce.dart';
import 'package:uuid/uuid.dart';

void main() async {
  KeyPair alice = KeyPair.fresh();
  KeyPair bob = KeyPair.fresh();

  String plainText =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla id arcu purus. Pellentesque pharetra enim et nulla lobortis porttitor. Pellentesque tincidunt pharetra mauris, quis finibus orci pharetra ut. Vivamus laoreet sollicitudin erat nec vestibulum. Phasellus auctor malesuada nunc, sit amet elementum nunc dictum ac. Donec tempus laoreet est vel eleifend. Etiam at ipsum dapibus, vulputate magna in, rhoncus sem. Sed eu ornare purus. Fusce hendrerit ornare lacus sed viverra. Quisque maximus tincidunt dapibus. Aliquam tincidunt arcu ut lorem varius consectetur. Sed nec dui felis.";

  BigInt aliceSharedSecret =
      KeyPair.computeSharedSecret(alice.privateKeyHex, bob.publicKeyHex);
  Nonce nonce = Nonce.fromUUID(const Uuid().v1());
  ChaCha20 chacha20 = ChaCha20(ChaCha20Key.fromBigInt(aliceSharedSecret));
  ChaCha20Key key = ChaCha20Key.fromBigInt(aliceSharedSecret);
  String cipherText = chacha20.encrypt(plainText, nonce);
  chacha20.decrypt(cipherText, nonce);
  await computeFileListEncryptionPromise(
    FileListEncryptionPromise(filePromises: [
      FileEncryptionPromise(
          inputFile: "plaintext_example.txt",
          nonce: nonce,
          password: key.data,
          outputFile: "encrypted_example.txt")
    ]),
    onCipherFinished: (CipherResult cipherResult) {
      // Your logic to handle the result
    }
  );
}
