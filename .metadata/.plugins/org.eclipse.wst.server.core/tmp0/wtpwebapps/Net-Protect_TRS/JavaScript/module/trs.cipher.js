var AesUtil = function(salt, phrase, iv) {
	this.keySize = 128/32;
	this.iterationCount = 100;
	this.salt = salt;
	this.phrase = phrase;
	this.iv = iv;
};

AesUtil.prototype.generateKey = function() {
  var key = CryptoJS.PBKDF2(
      this.phrase, 
      CryptoJS.enc.Hex.parse(this.salt),
      { keySize: this.keySize, iterations: this.iterationCount });
  
      return key;
}

AesUtil.prototype.encrypt = function(plainText) {
	var key = this.generateKey();
	var encrypted = CryptoJS.AES.encrypt(
			plainText,
			key,
			{ iv: CryptoJS.enc.Utf8.parse(this.iv) });
	return encrypted.ciphertext.toString(CryptoJS.enc.Base64);
}

AesUtil.prototype.encryptJQSelectorValue = function( $selector ) {
	$selector.val( this.encrypt($selector.val()) );
}

AesUtil.prototype.encryptJQSelectorToSelectorValues = function( $selector, $selector2 ) {
    $selector2.val( this.encrypt($selector.val()) );
}

AesUtil.prototype.encryptValue = function( str ) {
    return this.encrypt(str);
}

AesUtil.prototype.getByteOfString = function( str ){
	  var data = [];
	  for( var i=0; i<str.length; i++){
		  data.push(str.charCodeAt(i));
	  }
	  return data;
}

AesUtil.prototype.decrypt = function(cipherText) {
  var key = this.generateKey();
  var cipherParams = CryptoJS.lib.CipherParams.create({
    ciphertext: CryptoJS.enc.Base64.parse(cipherText)
  });
  var decrypted = CryptoJS.AES.decrypt(
      cipherParams,
      key,
      { iv: CryptoJS.enc.Utf8.parse(this.iv) });
  return decrypted.toString(CryptoJS.enc.Utf8);
}

