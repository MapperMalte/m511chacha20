<!--
This package provides you with curve M-511 for ECDH and ChaCha20 for symmetric encryption.
This way, you have everything you need for end-to-end-encryption.

## Features

* M-511 is a super strong curve (256 bit security compared to Curve25519 112 bit).
* Easy encryption and decryption of multiple files in different Thread.

## Getting started

Add the package by writing

```dart
flutter pub add m511chacha20
```
Now you can generate a key with 
```
```dart
KeyPair.fresh()
```
and exchange it somehow with your chat partner. Keep in mind to sign the messages.
Once you have received the key from the partner you want to chat with, you can write

```dart
BigInt commonSecret = KeyPair.computeSharedSecret(bob.privateKeyHex,alice.publicKeyHex)
```
to compute a common Password. You can then use this password, to create a ChaCha20 encrypter:

```dart
ChaCha20 chaCha20 = ChaCha20(ChaCha20Key.fromBigInt(commonSecret));
```
and use this encrypter to encrypt and decrypt messages and maps

```dart
chaCha20.encrypt(plainText, nonce)
chaCha20.decrypt(cipherText, nonce)
```
with a nonce, like

```dart
Nonce.fromUUID(...) or
Nonce.fromString(..)
```
The nonce must be provided in addition to the password for each encryption/decryption.

You can also create a nonce directly from a Uint32List, but keep in mind it needs 8x32 bit,
needs to be completely random.

If you want to encrypt or decrypt Files, you can use
```dart
await computeFileListEncryptionPromise(
      FileListEncryptionPromise(
          filePromises: [
            FileEncryptionPromise(
                inputFile: "test/test_files/plaintext_example.txt",
                nonce: nonce,
                password: key,
                outputFile: "test/test_files/encrypted_example.txt"
            )
          ]
      ),
      onCipherFinished: (CipherResult cipherResult) {
        finishCalled = true;
      }
    )
```
## Usage

```dart
KeyPair alice = KeyPair.fresh();
KeyPair bob = KeyPair.fresh();

BigInt aliceSharedSecret = KeyPair.computeSharedSecret(
    alice.privateKeyHex,
    bob.publicKeyHex
);
BigInt bobSharedSecret = KeyPair.computeSharedSecret(
    bob.privateKeyHex,
    alice.publicKeyHex
);
BigInt commonSecret = KeyPair.computeSharedSecret(bob.privateKeyHex,alice.publicKeyHex);
Nonce nonce = Nonce.fromUUID(Uuid().v1());
ChaCha20 chacha20 = ChaCha20(ChaCha20Key.fromBigInt(commonSecret)); 
String cipherText = chacha20.encrypt(plainText, nonce);
String plainText = chacha20.decrypt(cipherText,nonce);

bool wasSuccess = await computeFileListEncryptionPromise(
  FileListEncryptionPromise(
      filePromises: [
        FileEncryptionPromise(
            inputFile: "test/test_files/plaintext_example.txt",
            nonce: nonce,
            password: key,
            outputFile: "test/test_files/encrypted_example.txt"
        )
      ]
  ),
  onCipherFinished: (CipherResult cipherResult) {
    // ADD YOUR LOGIC HERE
  }
)

```

## Additional information

You can contribute on github https://github.com/MapperMalte/m511chacha20